/**
 * Author: samisams
  */

import 'package:flutter/material.dart';
import 'package:queue/navigationDrawer/navigationDrawer.dart';
import 'package:queue/services/api_service.dart';
import 'package:queue/services/shared_service.dart';

class profilePage extends StatefulWidget {
  const profilePage({Key? key}) : super(key: key);
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<profilePage> {
  static final String path = "lib/src/pages/profile/profile3.dart";
  //final image = avatars[1];
  final primary = Color.fromARGB(255, 91, 94, 173);
  static const String routeName = '/profilePage';
  static final GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  bool isApiCallProcess = false;
  var fullname = '';
  var username = '';
  var email = '';
  var status = '';
  var cereatedAt = '';
  @override
  void initState() {
    super.initState();
    getUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 91, 94, 173),
        toolbarHeight: 80,
        title: Text("Profile"),
        centerTitle: true,
      ),
      drawer: navigationDrawer(),
      backgroundColor: Color(0xfff0f0f0),
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            SizedBox(
              height: 250,
              width: double.infinity,
            ),
            Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5.0),
                ),
                margin: EdgeInsets.fromLTRB(0, 20.0, 0, 0),
                child: Column(children: <Widget>[
                  ListTile(
                    title: Text(
                      "Profile",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: primary,
                      ),
                    ),
                  ),
                  Divider(),
                  ListTile(
                    title: Text(
                      "Full Name",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: primary,
                      ),
                    ),
                    subtitle: Text(fullname),
                    leading: Icon(Icons.person),
                  ),
                  ListTile(
                    title: Text(
                      "Username",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: primary,
                      ),
                    ),
                    subtitle: Text(username),
                    leading: Icon(Icons.web),
                  ),
                  ListTile(
                    title: Text(
                      "Email",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: primary,
                      ),
                    ),
                    subtitle: Text(email),
                    leading: Icon(Icons.email),
                  ),
                  ListTile(
                    title: Text(
                      "Phone",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: primary,
                      ),
                    ),
                    subtitle: Text("+977-9815225566"),
                    leading: Icon(Icons.phone),
                  ),
                  ListTile(
                    title: Text(
                      "Joined Date",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: primary,
                      ),
                    ),
                    subtitle: Text(cereatedAt),
                    leading: Icon(Icons.calendar_view_day),
                  ),
                ])),
          ],
        ),
      ),
    );
  }

  Widget userProfile() {
    return FutureBuilder(
      future: APIService.getUserProfile(),
      builder: (
        BuildContext context,
        AsyncSnapshot<String> model,
      ) {
        if (model.hasData) {
          return Center(child: Text(model.data!));
        }

        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Future<void> getUserProfile() async {
    try {
      var loginDetails = await SharedService.loginDetails();
      if (this.mounted) {
        setState(() {
          fullname = loginDetails!.firstName.toString();
          username = loginDetails.username.toString();
          email = loginDetails.email.toString();
          status = loginDetails.status.toString();
          cereatedAt = loginDetails.cereatedAt.toString();
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
