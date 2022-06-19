/**
 * Author: Damodar Lohani
 * profile: https://github.com/lohanidamodar
  */

import 'package:flutter/material.dart';
import 'package:queue/config.dart';
import 'package:queue/navigationDrawer/navigationDrawer.dart';
import 'package:queue/services/shared_service.dart';

class SettingPage extends StatelessWidget {
  static final String path = "lib/src/pages/settings/settings2.dart";
  final TextStyle whiteText = TextStyle(
    color: Color.fromARGB(255, 44, 51, 114),
  );
  final TextStyle greyTExt = TextStyle(
    color: Color.fromARGB(255, 44, 51, 114),
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff0f0f0),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 91, 94, 173),
        toolbarHeight: 80,
        title: Text("Setting"),
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
      body: Theme(
        data: Theme.of(context).copyWith(
          brightness: Brightness.light,
          primaryColor: Colors.purple,
        ),
        child: DefaultTextStyle(
          style: TextStyle(
            color: Color.fromARGB(255, 44, 51, 114),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              children: <Widget>[
                const SizedBox(height: 30.0),
                Row(
                  children: <Widget>[
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 44, 51, 114),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Color.fromARGB(255, 44, 51, 114),
                          width: 2.0,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Jane Doe",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                            ),
                          ),
                          Text(
                            "Nepal",
                            style: TextStyle(
                              color: Color.fromARGB(255, 44, 51, 114),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                ListTile(
                  title: Text(
                    "Languages",
                    //  style: whiteBoldText,
                  ),
                  subtitle: Text(
                    "English US",
                    style: greyTExt,
                  ),
                  trailing: Icon(
                    Icons.keyboard_arrow_right,
                    color: Color.fromARGB(255, 44, 51, 114),
                  ),
                  onTap: () {},
                ),
                ListTile(
                  title: Text(
                    "Profile Settings",
                    //   style: whiteBoldText,
                  ),
                  subtitle: Text(
                    "Jane Doe",
                    style: greyTExt,
                  ),
                  trailing: Icon(
                    Icons.keyboard_arrow_right,
                    color: Color.fromARGB(255, 44, 51, 114),
                  ),
                  onTap: () {},
                ),
                SwitchListTile(
                  title: Text(
                    "Email Notifications",
                    // style: whiteBoldText,
                  ),
                  subtitle: Text(
                    "On",
                    style: greyTExt,
                  ),
                  value: true,
                  onChanged: (val) {},
                ),
                SwitchListTile(
                  title: Text(
                    "Push Notifications",
                    // style: whiteBoldText,
                  ),
                  subtitle: Text(
                    "Off",
                    style: greyTExt,
                  ),
                  value: false,
                  onChanged: (val) {},
                ),
                ListTile(
                  title: Text(
                    "Logout",
                    // style: whiteBoldText,
                  ),
                  onTap: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
