/**
 * Author: samisams
  */

import 'package:flutter/material.dart';
import 'package:queue/navigationDrawer/navigationDrawer.dart';
import 'package:queue/services/shared_service.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({Key? key}) : super(key: key);
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  //final image = avatars[1];
  final primary = Color.fromARGB(255, 91, 94, 173);
  static const String routeName = '/aboutPage';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 91, 94, 173),
        toolbarHeight: 80,
        title: Text("About"),
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
                      "About",
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
                      "Virtuale Queue System",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: primary,
                      ),
                    ),
                    subtitle: Text("Developed By Samsom Mamushet"),
                    leading: Icon(Icons.web),
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
                    subtitle: Text("+251 973316377"),
                    leading: Icon(Icons.phone),
                  ),
                  ListTile(
                    title: Text(
                      "Date",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: primary,
                      ),
                    ),
                    subtitle: Text("18 May 2022"),
                    leading: Icon(Icons.calendar_view_day),
                  ),
                ])),
          ],
        ),
      ),
    );
  }
}
