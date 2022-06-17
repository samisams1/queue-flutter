/**
 * Author: Samisams 
  */

import 'package:flutter/material.dart';
import 'package:queue/config.dart';
import 'package:queue/models/branch_response_model.dart';
import 'package:queue/navigationDrawer/navigationDrawer.dart';
import 'package:queue/pages/servicePage.dart';
import 'package:queue/services/branch.dart';
import 'package:queue/services/shared_service.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';
import 'package:snippet_coder_utils/hex_color.dart';
import 'package:flutter/gestures.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SchoolList extends StatefulWidget {
  SchoolList({Key? key}) : super(key: key);
  static final String path = "lib/src/pages/lists/list2.dart";

  _SchoolListState createState() => _SchoolListState();
}

class _SchoolListState extends State<SchoolList> {
  var ticketNumberListener1 = '';
  var isTicketExist = 0;
  late IO.Socket socket;

  final TextStyle dropdownMenuItem =
      TextStyle(color: Colors.black, fontSize: 18);

  final primary = Color.fromARGB(255, 91, 94, 173);
  final secondary = Color(0xfff29a94);

  List<BranchResponseModel> _branchList = <BranchResponseModel>[];
  bool isApiCallProcess = false;
  static final GlobalKey<FormState> globalFormKeyBranch =
      GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    connectToServer();
    fetchUsers().then((value) {
      setState(() {
        _branchList = (value);
        print(_branchList.length);
      });
    });
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: HexColor("#0358ad"),
          body: ProgressHUD(
            child: Form(
              key: globalFormKeyBranch,
              child: _branchList.length < 0
                  ? _branchnUI(context)
                  : _getTicketNoneBranchUI(context),
            ),
            inAsyncCall: isApiCallProcess,
            opacity: 0.3,
            key: UniqueKey(),
          )),
    );
  }

  @override
  Widget _branchnUI(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff0f0f0),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 91, 94, 173),
        toolbarHeight: 80,
        title: Text(Config.appName),
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
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: <Widget>[
              Container(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Material(
                        elevation: 5.0,
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        child: TextField(
                          // controller: TextEditingController(text: locations[0]),
                          cursorColor: Theme.of(context).primaryColor,
                          style: dropdownMenuItem,
                          decoration: InputDecoration(
                              hintText: "Search Branch",
                              hintStyle: TextStyle(
                                  color: Colors.black38, fontSize: 16),
                              prefixIcon: Material(
                                elevation: 0.0,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30)),
                                child: Icon(Icons.search),
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 13)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 38),
                height: MediaQuery.of(context).size.height,
                width: double.infinity,
                child: ListView.builder(
                    itemCount: _branchList.length,
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
              builder: (context) =>
                  ServicePage(value: _branchList[index].id.toString()),
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
                      _branchList[index].value.toString(),
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
            ],
          ),
        ));
  }

  @override
  Widget _getTicketNoneBranchUI(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 91, 94, 173),
          toolbarHeight: 80,
          title: Text("Get Ticket"),
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

                          getTicketForNoeBranch();
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

  getTicketForNoeBranch() async {
    var loginDetails = await SharedService.loginDetails();
    var id = loginDetails!.id.toInt();
    socket.emit("get_ticket", id);
    socket.emit("is_Ticket_Available", id);
  }

  void allTicketListener() {
    socket.on('total_Number_of_ticket', (data) {
      print("samisams");
      print("samisams");
      if (this.mounted) {
        setState(() {
          ticketNumberListener1 = data.toString();
        });
      }
      print(data);

      print(ticketNumberListener1);
    });
  }
}
