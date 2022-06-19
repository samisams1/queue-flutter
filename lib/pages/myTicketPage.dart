/**
 * Author: samisams
  */
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:queue/config.dart';
import 'package:queue/models/ticketResponse.dart';
import 'package:queue/pages/homePage.dart';
import 'package:queue/pages/servicePage.dart';
import 'package:queue/pages/ticketDetailPage.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../navigationDrawer/navigationDrawer.dart';
import 'package:snippet_coder_utils/hex_color.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';
import 'package:queue/services/shared_service.dart';

class MyticketPage extends StatefulWidget {
  MyticketPage({Key? key}) : super(key: key);

  _MyticketPageState createState() => _MyticketPageState();
}

class _MyticketPageState extends State<MyticketPage> {
  static const String routeName = '/myTicketPage';
  static final GlobalKey<FormState> globalFormKey1 = GlobalKey<FormState>();
  bool isApiCallProcess = false;
  // ticketRespose? ticket;
  var ticket = [];
  var customerBeforYou = '';
  var windowNumber = '';
  var totalTicket = 0;
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
      socket.emit('my_ticket', id);
      CustomerBeforYou();
      myTicketListener();
      socket.on('disconnect', (_) => print('disconnect'));
      socket.on('fromServer', (_) => print(_));
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: HexColor("#0358ad"),
          body: ProgressHUD(
            child: Form(
              //   key: globalFormKeyBranch,
              child: totalTicket > 0 ? _MyTicketUI(context) : _EmptyUI(context),
            ),
            inAsyncCall: isApiCallProcess,
            opacity: 0.3,
            key: UniqueKey(),
          )),
    );
  }

  @override
  Widget _MyTicketUI(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff0f0f0),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 91, 94, 173),
        toolbarHeight: 80,
        title: Text("My Ticket"),
        centerTitle: true,
      ),
      drawer: navigationDrawer(),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 5),
                height: MediaQuery.of(context).size.height,
                width: double.infinity,
                child: ListView.builder(
                    itemCount: totalTicket,
                    itemBuilder: (BuildContext context, int index) {
                      return buildList(context, index);
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildList(BuildContext context, int index) {
    return new GestureDetector(
        //onTap: (() => print("sasaw")),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TicketDetailPage(),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: Colors.white,
          ),
          width: 70,
          height: 70,
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "TicketNo",
                      style: TextStyle(
                          color: primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 12),
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    Text(
                      '${ticket[index]["ticketNumber"]}',
                      style: TextStyle(
                          color: primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "before you",
                      style: TextStyle(
                          color: primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 12),
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    Text(
                      customerBeforYou.toString(),
                      style: TextStyle(
                          color: primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "status",
                      style: TextStyle(
                          color: primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 12),
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    Text(
                      '${ticket[index]["status"]}',
                      style: TextStyle(
                          color: primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "window",
                      style: TextStyle(
                          color: primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 14),
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    '${ticket[index]["status"]}' == "unCalled"
                        ? Text(
                            '${ticket[index]["windowNumber"]}',
                            style: TextStyle(
                                color: Color.fromRGBO(243, 159, 2, 1),
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          )
                        : Text(
                            '${ticket[index]["windowNumber"]}',
                            style: TextStyle(
                                color: Color.fromARGB(255, 30, 243, 2),
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  @override
  Widget _EmptyUI(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 91, 94, 173),
          toolbarHeight: 80,
          title: Text("My Ticket"),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(
                Icons.logout,
                color: Color.fromARGB(255, 255, 254, 254),
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
        backgroundColor: Color(0xfff0f0f0),
        body: SingleChildScrollView(
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
                    color: Color.fromARGB(255, 52, 73, 175),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Center(
                    child: Text(
                  'Empty Please Get ticket',
                  style: TextStyle(
                      color: primary,
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold),
                )),
              ),
              Align(
                  //  padding: EdgeInsets.only(left: Center, bottom: 30, top: 50),
                  child: RaisedButton(
                onPressed: () {
                  //wrong way: use context in same level tree with MaterialApp
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomePage()));
                },
                child: const Text('Go To Ticket '),
                color: primary,
                textColor: Colors.white,
              )),
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
        ));
  }

  void myTicketListener() {
    socket.on('my_ticket', (data) {
      // var ticket = data;
      if (this.mounted) {
        setState(() {
          ticket = data;
          totalTicket = data.length;
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
