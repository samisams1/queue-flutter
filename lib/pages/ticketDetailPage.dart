import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:queue/config.dart';
import 'package:queue/models/ticketResponse.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../navigationDrawer/navigationDrawer.dart';
import 'package:snippet_coder_utils/hex_color.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';
import 'package:queue/services/shared_service.dart';

class TicketDetailPage extends StatefulWidget {
  const TicketDetailPage({Key? key}) : super(key: key);
  @override
  _TicketDetailPageState createState() => _TicketDetailPageState();
}

class _TicketDetailPageState extends State<TicketDetailPage> {
  static const String routeName = '/myTicketPage';
  static final GlobalKey<FormState> globalFormKey1 = GlobalKey<FormState>();
  bool isApiCallProcess = false;
  // ticketRespose? ticket;
  var ticket = [];
  var customerBeforYou = '';
  var windowNumber = '';
  final primary = Color.fromARGB(255, 91, 94, 173);
  final secondary = Color(0xfff29a94);
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
      socket.emit('specific_my_ticket', id);
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
          backgroundColor: Color.fromARGB(255, 91, 94, 173),
          toolbarHeight: 80,
          title: Text("Ticket"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back,
                color: Color.fromARGB(255, 253, 251, 251)),
            onPressed: () => Navigator.of(context).pop(),
          ),
          centerTitle: true,
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
        backgroundColor: Color(0xfff0f0f0),
        body: ListView.builder(
            itemCount: ticket.length,
            itemBuilder: (BuildContext context, int index) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Center(
                          child: Text(
                        "--------------------------------",
                        style: TextStyle(
                            color: primary,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold),
                      )),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 0),
                      child: Center(
                          child: Text(
                        "Queue Before You  : " + customerBeforYou.toString(),
                        style: TextStyle(
                            color: Color.fromARGB(255, 245, 141, 4),
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Open Sans'),
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
                            color: primary,
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
                            color: primary,
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
                            color: primary,
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold),
                      )),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Center(
                          child: Text(
                        '${ticket[index]["updatedAt"]}',
                        style: TextStyle(
                            color: primary,
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold),
                      )),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Center(
                          child: Text(
                        "Thank you for commig",
                        style: TextStyle(
                            color: primary,
                            fontSize: 30.0,
                            fontFamily: 'Open Sans',
                            fontWeight: FontWeight.bold),
                      )),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Center(
                          child: Text(
                        "--------------------------------",
                        style: TextStyle(
                            color: primary,
                            fontSize: 20.0,
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
                  ],
                ),
              );
            }),
      ));

  void myTicketListener() {
    socket.on('specific_my_ticket', (data) {
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
