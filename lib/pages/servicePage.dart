/**
 * Author: Samisams 
  */

import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:queue/components/dialog.dart';
import 'package:queue/config.dart';
import 'package:queue/models/branch_response_model.dart';
import 'package:queue/models/service_response_model.dart';
import 'package:queue/navigationDrawer/navigationDrawer.dart';
import 'package:queue/pages/aboutPage.dart';
import 'package:queue/pages/homePage.dart';
import 'package:queue/pages/servicePage.dart';
import 'package:queue/services/branch.dart';
import 'package:queue/services/service.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';
import 'package:snippet_coder_utils/hex_color.dart';
import 'package:flutter/gestures.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:queue/services/shared_service.dart';
import 'package:snippet_coder_utils/FormHelper.dart';

class ServicePage extends StatefulWidget {
  final value;

  ServicePage({Key? key, this.value}) : super(key: key);

  static final String path = "lib/src/pages/lists/list2.dart";

  _ServicePageState createState() => _ServicePageState();
}

class _ServicePageState extends State<ServicePage> {
  final TextStyle dropdownMenuItem =
      TextStyle(color: Colors.black, fontSize: 18);

  final primary = Color.fromARGB(255, 91, 94, 173);
  final secondary = Color(0xfff29a94);

  List<ServiceResponseModel> _servicehList = <ServiceResponseModel>[];
  bool isApiCallProcess = false;
  static final GlobalKey<FormState> globalFormKeyService =
      GlobalKey<FormState>();

  static const String routeName = '/homePage';
  static final GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  var ticketNumberListener1 = '';
  var isTicketExist;
  late IO.Socket socket;

  @override
  void initState() {
    final branchId = widget.value;
    super.initState();
    fetchService(branchId).then((value) {
      setState(() {
        _servicehList = (value);
        print(_servicehList.length);
      });
    });
    super.initState();
    connectToServer();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: HexColor("#0358ad"),
          appBar: AppBar(
            backgroundColor: Color.fromARGB(255, 91, 94, 173),
            toolbarHeight: 80,
            title: Text("Get Ticket" + _servicehList.length.toString()),
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
              key: globalFormKeyService,
              child: _servicehList.length > 0
                  ? _ServiceUI(context)
                  : _GetTicketUI(context),
            ),
            inAsyncCall: isApiCallProcess,
            opacity: 0.3,
            key: UniqueKey(),
          )),
    );
  }

  /*Widget build11(BuildContext context) {
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
*/
  @override
  Widget _ServiceUI(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff0f0f0),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 10),
                height: MediaQuery.of(context).size.height,
                width: double.infinity,
                child: ListView.builder(
                    itemCount: _servicehList.length,
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
    var serviceId = _servicehList[index].id;
    return new GestureDetector(
        //onTap: (() => print("sasaw")),
        onTap: () {
          /*  Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => getTicketListener(serviceId),
            ),
          );*/
          _showTextInputDialog(context, serviceId);
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
                      _servicehList[index].value.toString(),
                      style: TextStyle(
                          color: primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                    SizedBox(
                      height: 6,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      ticketNumberListener1,
                      style: TextStyle(
                          color: primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                    SizedBox(
                      height: 6,
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }

  @override
  Widget _GetTicketUI(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xfff0f0f0),
        body: SingleChildScrollView(
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
                    color: Color.fromARGB(255, 23, 32, 78),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Center(
                    child: Text(
                  'Waiting customer....',
                  style: TextStyle(
                      color: primary,
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
                      color: primary,
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold),
                )),
              ),
              isTicketExist != 0
                  ? Center(
                      child: FormHelper.submitButton(
                        "Get Ticket",
                        () {
                          /* Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/ticket',
                          (route) => false,
                    ); */

                          getTicketForBranchOnly();
                        },
                        width: 500,
                        height: 70,
                        btnColor: primary,
                        borderColor: Color.fromARGB(255, 252, 252, 253),
                        txtColor: Color.fromARGB(255, 252, 252, 253),
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
                                color: Color.fromARGB(255, 25, 42, 88),
                                fontSize: 17.0),
                            children: <TextSpan>[
                              const TextSpan(
                                text: 'You Have Already Active Ticket ',
                              ),
                              TextSpan(
                                text: 'view',
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 91, 130, 245),
                                  fontWeight: FontWeight.bold,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.pushNamed(
                                      context,
                                      '/myTicket',
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
        ));
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
      // String serviceId = "1";
      // Connect to websocket
      socket.connect();

      // Handle socket events
      socket.on('connect', (_) => print('connect: ${socket.id}'));
      //socket.on('message', sendMessage(message));
      // socket.on('message', getTicket(message));
      socket.emit('is_Ticket_Available');
      socket.emit('service_queue');
      // isTicketAvailable();
      socket.emit('total_Number_of_ticket');
      allTicketListener();
      socket.on('disconnect', (_) => print('disconnect'));
      socket.on('fromServer', (_) => print(_));
    } catch (e) {
      print(e.toString());
    }
  }

  getTicketListener(serviceId) async {
    //static Future<Int> getTicketListener(serviceId) async {
    var loginDetails = await SharedService.loginDetails();
    var id = loginDetails!.id.toInt();
    socket.emit("get_ticket", serviceId);
    socket.emit("is_Ticket_Available", id);
    print("serviceId");
    print(serviceId);
    print("abiy");
  }

  void allTicketListener() {
    socket.on('total_Number_of_ticket', (data) {
      print("samisams");
      print(data);
      print("samisams");
      if (this.mounted) {
        setState(() {
          ticketNumberListener1 = data.toString();
        });
      }
      print(ticketNumberListener1);
    });
  }

  getTicketForBranchOnly() async {
    var loginDetails = await SharedService.loginDetails();
    var id = loginDetails!.id.toInt();
    socket.emit("get_ticket", id);
    socket.emit("is_Ticket_Available", id);
  }

  final _textFieldController = TextEditingController();

  Future<String?> _showTextInputDialog(BuildContext context, serviceId) async {
    return showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text('Are You Sure to get ticket?'),
            actions: [
              FlatButton(
                onPressed: () => Navigator.pop(context, false), // passing false
                child: Text('No'),
              ),
              FlatButton(
                onPressed: () => Navigator.pop(context, true), // passing true
                child: Text('Yes'),
              ),
            ],
          );
        }).then((exit) {
      if (exit == null) return;

      if (exit) {
        getTicketListener(serviceId);
      } else {
        // user pressed No button
      }
    });
  }
}
