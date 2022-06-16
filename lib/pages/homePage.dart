import 'package:flutter/material.dart';
import 'package:queue/config.dart';
import 'package:flutter/gestures.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../navigationDrawer/navigationDrawer.dart';
import 'package:snippet_coder_utils/hex_color.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';
import 'package:queue/services/shared_service.dart';
import 'package:queue/routes/pageRoute.dart';

class homePage extends StatefulWidget {
  const homePage({Key? key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<homePage> {
  static const String routeName = '/homePage';
  static final GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  bool isApiCallProcess = false;
  var ticketNumberListener1 = '';
  var isTicketExist;
  late IO.Socket socket;
  @override
  void initState() {
    super.initState();
    connectToServer();
  }

  Future<void> connectToServer() async {
    try {
      var loginDetails = await SharedService.loginDetails();
      var token = loginDetails!.accessToken;
      // Configure socket transports must be sepecified

      socket = IO.io(
          Config.socketURL,
          IO.OptionBuilder()
              .setTransports(['websocket']) // for Flutter or Dart VM
              .disableAutoConnect()
              .setQuery({'token': token})
              .build());
      print("token");
      print("sasaw kebede");
      String message = "mesage from Cient to connect";
      // Connect to websocket
      socket.connect();

      // Handle socket events
      socket.on('connect', (_) => print('connect: ${socket.id}'));
      socket.on('message', sendMessage(message));
      socket.emit('is_Ticket_Available');
      socket.emit('total_Number_of_ticket');
      isTicketAvailable();
      allTicketListener();
      socket.on('disconnect', (_) => print('disconnect'));
      socket.on('fromServer', (_) => print(_));
    } catch (e) {
      print(e.toString());
    }
  }

  Widget build(BuildContext context) {
    return new Scaffold(
        backgroundColor: Color(0xff696b9e),
        appBar: AppBar(
          backgroundColor: HexColor("0a0000"),
          toolbarHeight: 80,
          title: Text(Config.appName),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.logout,
                color: Color.fromARGB(255, 228, 10, 10),
              ),
              onPressed: () {
                SharedService.logout(context);
              },
            ),
            const SizedBox(
              width: 10,
            ),
          ],
        ),
        drawer: navigationDrawer(),
        body: ProgressHUD(
          child: Form(
            key: globalFormKey,
            child: _homeUI(context),
          ),
          inAsyncCall: isApiCallProcess,
          opacity: 0.3,
          key: UniqueKey(),
        ));
  }

  @override
  Widget _homeUI(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.only(left: 20, bottom: 30, top: 50),
            child: Text(
              "Home",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
                color: Color.fromARGB(255, 250, 247, 247),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Center(
                child: Text(
              'Waiting customer.. ',
              style: TextStyle(
                  color: Color.fromARGB(255, 250, 247, 247),
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold),
            )),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Center(
                child: Text(
              ticketNumberListener1,
              style: TextStyle(
                  color: Color.fromARGB(255, 250, 247, 247),
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold),
            )),
          ),
          const SizedBox(
            height: 20,
          ),
          isTicketExist == 0
              ? Center(
                  child: FormHelper.submitButton(
                    "Get Ticket",
                    () {
                      /* Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/ticket',
                          (route) => false,
                    ); */

                      getTicketListener();
                    },
                    btnColor: HexColor("0a0000"),
                    borderColor: Color.fromARGB(255, 252, 252, 253),
                    txtColor: Color.fromARGB(255, 250, 247, 247),
                    borderRadius: 10,
                  ),
                )
              : Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      right: 25,
                    ),
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(
                            color: Color.fromARGB(255, 250, 247, 247),
                            fontSize: 17.0),
                        children: <TextSpan>[
                          const TextSpan(
                            text: 'You Have Already Active Ticket ',
                          ),
                          TextSpan(
                            text: 'view',
                            style: const TextStyle(
                              color: Color.fromARGB(255, 250, 247, 247),
                              fontWeight: FontWeight.bold,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.pushNamed(
                                  context,
                                  '/register',
                                );
                              },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
          const SizedBox(
            height: 20,
          ),
          const SizedBox(
            height: 20,
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  sendMessage(String message) {
    socket.emit(
      "message",
      {
        "id": socket.id,
        "message": message, //--> message to be sent
        "username": "samisams",
        "sentAt": DateTime.now().toLocal().toString().substring(0, 16),
      },
    );
  }

  void allTicketListener() {
    socket.on('total_Number_of_ticket', (data) {
      print(data);
      if (this.mounted) {
        setState(() {
          ticketNumberListener1 = data.toString();
        });
      }
      print(ticketNumberListener1);
    });
  }

  getTicketListener() async {
    var loginDetails = await SharedService.loginDetails();
    var id = loginDetails!.id.toInt();
    socket.emit("get_ticket", id);
    socket.emit("is_Ticket_Available", id);
  }

  void isTicketAvailable() async {
    var loginDetails = await SharedService.loginDetails();
    var id = loginDetails!.id.toInt();
    socket.emit("is_Ticket_Available", id);
    socket.on('is_Ticket_Available', (data) {
      print(data);
      if (this.mounted) {
        setState(() {
          isTicketExist = data;
        });
      }
      print("samisams");
      print(isTicketExist);
    });
  }
}
