import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:queue/config.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../navigationDrawer/navigationDrawer.dart';
import 'package:snippet_coder_utils/hex_color.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';
import 'package:queue/services/shared_service.dart';

class notificationPage extends StatefulWidget {
  const notificationPage({Key? key}) : super(key: key);
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<notificationPage> {
  static const String routeName = '/notificationPage';
  static final GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  bool isApiCallProcess = false;
  var ticketNumberListener1 = '';
  late IO.Socket socket;
  @override
  void initState() {
    super.initState();
    connectToServer();
    initPlatform();
  }

  Future<void> connectToServer() async {
    try {
      // var loginDetails = await SharedService.loginDetails();
      // var  token = loginDetails!.accessToken;
      // Configure socket transports must be sepecified

      socket = IO.io(
          Config.socketURL,
          IO.OptionBuilder()
              .setTransports(['websocket']) // for Flutter or Dart VM
              .disableAutoConnect()
              /*  .setQuery({
                'token':
                    "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwiaWF0IjoxNjUzODUzMTYwLCJleHAiOjE2NTM5Mzk1NjB9.OerHBDCaN3QmfMlHXIDx_2t83KO8uRfGPQDS275a-JQ"
              })*/
              .build());
      //.setExtraHeaders({'Connection': 'Upgrade'})
      // .setQuery({'token': token, 'username':'admin'})
      // .setQuery(query): { token: 'cde' }
      //  .setQuery({'token' :token}).build()

      /* socket = IO.io('http://10.0.2.2:8080', <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false,

      });
      */
      print("token");
      print("sasaw kebede");
      String message = "mesage from Cient to connect";
      // Connect to websocket
      socket.connect();

      // Handle socket events
      socket.on('connect', (_) => print('connect: ${socket.id}'));
      socket.on('message', sendMessage(message));
      allTicketListener();
      socket.on('disconnect', (_) => print('disconnect'));
      socket.on('fromServer', (_) => print(_));
    } catch (e) {
      print(e.toString());
    }
  }

  Widget build(BuildContext context) {
    return new Scaffold(
        backgroundColor: HexColor("0358ad"),
        appBar: AppBar(
          backgroundColor: HexColor("0a0000"),
          title: Text("Notification"),
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
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 8,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white,
                  Colors.white,
                ],
              ),
              borderRadius: BorderRadius.only(
                //topLeft: Radius.circular(100),
                //topRight: Radius.circular(150),
                bottomRight: Radius.circular(100),
                bottomLeft: Radius.circular(100),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Center(
                    child: Text(
                      "Queue App",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 40,
                        color: HexColor("#283B71"),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),

                /*  Align(
                  alignment: Alignment.center,
                  child: Image.asset(
                    "assets/images/ShoppingAppLogo.png",
                    fit: BoxFit.contain,
                    width: 250,
                  ),
                ),*/
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 20, bottom: 30, top: 50),
            child: Text(
              "Notification",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Center(
                child: Text(
              'Waiting customer.. ',
              style: TextStyle(
                  color: Colors.white,
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
                  color: Colors.white,
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold),
            )),
          ),
          const SizedBox(
            height: 20,
          ),
          Center(
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
              btnColor: HexColor("283B71"),
              borderColor: Colors.white,
              txtColor: Colors.white,
              borderRadius: 10,
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

  Future<void> initPlatform() async {
    await OneSignal.shared.setAppId("f177ce5a-fc3a-4cf0-81e2-f0ff8ec8b35e");
    print("samisams");
    await OneSignal.shared
        .getDeviceState()
        .then((value) => {print(value!.userId)});
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

  getTicketListener() {
    socket.emit(
      "new_message",
      2,
    );
  }
}
