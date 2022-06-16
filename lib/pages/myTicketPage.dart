import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:queue/config.dart';
import 'package:queue/models/ticketResponse.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../navigationDrawer/navigationDrawer.dart';
import 'package:snippet_coder_utils/hex_color.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';
import 'package:queue/services/shared_service.dart';

class MyTicketPage extends StatefulWidget {
  const MyTicketPage({Key? key}) : super(key: key);
  @override
  _MyTicketPageState createState() => _MyTicketPageState();
}

class _MyTicketPageState extends State<MyTicketPage> {
  static const String routeName = '/myTicketPage';
  static final GlobalKey<FormState> globalFormKey1 = GlobalKey<FormState>();
  bool isApiCallProcess = false;
  // ticketRespose? ticket;
  var ticket = [];
  var customerBeforYou = '';
  var windowNumber = '';
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
      var id = loginDetails.id;
      socket.emit('customer_befor_you', id);
      socket.emit('my_ticket', id);
      CustomerBeforYou();
      myTicketListener();
      socket.on('disconnect', (_) => print('disconnect'));
      socket.on('fromServer', (_) => print(_));
    } catch (e) {
      print(e.toString());
    }
  }

  Widget build(BuildContext context) {
    return new Scaffold(
        backgroundColor: HexColor("1e1616"),
        appBar: AppBar(
          backgroundColor: HexColor("00060c"),
          toolbarHeight: 80,
          title: Text("My Ticket"),
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
            key: globalFormKey1,
            child: _ticketUI(context),
          ),
          inAsyncCall: isApiCallProcess,
          opacity: 0.3,
          key: UniqueKey(),
        ));
  }

  @override
  Widget _ticketUI(BuildContext context) => MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color(0xff696b9e),
        body: ListView.builder(
            itemCount: ticket.length,
            itemBuilder: (BuildContext context, int index) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Padding(
                      padding: EdgeInsets.only(left: 20, bottom: 30, top: 50),
                      child: Text(
                        "My Ticket",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 0),
                      child: Center(
                          child: Text(
                        "Queue Before You  : " + customerBeforYou.toString(),
                        style: TextStyle(
                            color: Color.fromARGB(255, 252, 250, 250),
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold),
                      )),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Center(
                          child: Text(
                        "Ticket number :" +
                            "A0" +
                            '${ticket[index]["ticketNumber"]}',
                        style: TextStyle(
                            color: Color.fromARGB(255, 252, 250, 250),
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold),
                      )),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Center(
                          child: Text(
                        "Status  :" + '${ticket[index]["status"]}',
                        style: TextStyle(
                            color: Color.fromARGB(255, 252, 250, 250),
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold),
                      )),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Center(
                          child: Text(
                        "Window Number :" + '${ticket[index]["windowNumber"]}',
                        style: TextStyle(
                            color: Color.fromARGB(255, 252, 250, 250),
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold),
                      )),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Center(
                          child: Text(
                        "Called Time :" + '${ticket[index]["updatedAt"]}',
                        style: TextStyle(
                            color: Color.fromARGB(255, 252, 250, 250),
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold),
                      )),
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
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              );
            }),
      ));

  @override
  Widget _ticketUI1(BuildContext context) {
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
                  Color.fromARGB(255, 228, 7, 7),
                  Color.fromARGB(255, 27, 2, 2),
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
              "My Ticket",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 0),
            child: Center(
                child: Text(
              "Queue Before You  : " + customerBeforYou.toString(),
              style: TextStyle(
                  color: Color.fromARGB(255, 12, 0, 0),
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold),
            )),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Center(
                child: Text(
              ticket != null ? ticket.toString() : "samisams",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold),
            )),
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

  void myTicketListener() {
    socket.on('my_ticket', (data) {
      print(data);
      // var ticket = data;
      if (this.mounted) {
        setState(() {
          ticket = data;
        });
      }
    });
  }

  void CustomerBeforYou() {
    socket.on('customer_befor_you', (data) {
      print(data);
      print("habitishermi");
      if (this.mounted) {
        setState(() {
          customerBeforYou = data.toString();
        });
      }
      print(customerBeforYou);
    });
  }
}
