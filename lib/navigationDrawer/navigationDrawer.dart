import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:queue/pages/login_page.dart';
import 'package:queue/services/shared_service.dart';
import 'package:snippet_coder_utils/hex_color.dart';
import '../widget/createDrawerBodyItem.dart';
import 'createDrawerHeader.dart';
import 'package:queue/routes/pageRoute.dart';
import 'package:snippet_coder_utils/hex_color.dart';
import 'package:flutter/material.dart';
import 'package:queue/pages/Oval.dart';

class navigationDrawer extends StatefulWidget {
  const navigationDrawer({Key? key}) : super(key: key);
  @override
  _navigationDrawerState createState() => _navigationDrawerState();
}

class _navigationDrawerState extends State<navigationDrawer> {
//class navigationDrawer extends StatelessWidget {
  final primary = Color.fromARGB(255, 91, 94, 173);
  final secondary = Color.fromARGB(255, 250, 247, 247);
  final Color active = Colors.grey.shade800;
  final Color divider = Color.fromARGB(255, 91, 94, 173);

  var username = '';
  var email = '';

  void initState() {
    super.initState();
    getUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    //final String image = images[0];
    return ClipPath(
      clipper: OvalRightBorderClipper(),
      child: Drawer(
        child: Container(
          padding: const EdgeInsets.only(left: 5.0, right: 40),
          decoration: BoxDecoration(
              color: secondary, boxShadow: [BoxShadow(color: primary)]),
          width: 300,
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      icon: Icon(
                        Icons.power_settings_new,
                        color: primary,
                      ),
                      onPressed: () {
                        SharedService.logout(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      },
                    ),
                  ),
                  Container(
                    height: 90,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(colors: [
                          Color.fromARGB(255, 20, 19, 17),
                          Color.fromARGB(255, 83, 58, 141)
                        ])),
                    child: CircleAvatar(
                      radius: 40,
                      // backgroundImage: NetworkImage(image),
                    ),
                  ),
                  SizedBox(height: 5.0),
                  Text(
                    username,
                    style: TextStyle(
                        color: primary,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600),
                  ),
                  Text(
                    email,
                    style: TextStyle(color: primary, fontSize: 16.0),
                  ),
                  SizedBox(height: 30.0),
                  createDrawerBodyItem(
                    icon: Icons.home,
                    text: 'Home',
                    onTap: () => Navigator.pushReplacementNamed(
                        context, pageRoutes.home),
                  ),
                  _buildDivider(),
                  createDrawerBodyItem(
                    icon: Icons.person_pin,
                    text: "My profile",
                    onTap: () => Navigator.pushReplacementNamed(
                        context, pageRoutes.profile),
                  ),
                  _buildDivider(),
                  createDrawerBodyItem(
                    icon: Icons.airplane_ticket,
                    text: "My Ticket",
                    onTap: () => Navigator.pushReplacementNamed(
                      context,
                      pageRoutes.myTicket,
                    ),
                  ),
                  _buildDivider(),
                  createDrawerBodyItem(
                    icon: Icons.notifications,
                    text: "Notifications",
                    onTap: () => Navigator.pushReplacementNamed(
                      context,
                      pageRoutes.notification,
                    ),
                  ),
                  _buildDivider(),
                  createDrawerBodyItem(
                    icon: Icons.settings,
                    text: "Settings",
                    onTap: () => Navigator.pushReplacementNamed(
                      context,
                      pageRoutes.setting,
                    ),
                  ),
                  _buildDivider(),
                  createDrawerBodyItem(
                    icon: Icons.email,
                    text: "About",
                    onTap: () => Navigator.pushReplacementNamed(
                      context,
                      pageRoutes.about,
                    ),
                  ),
                  _buildDivider(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Divider _buildDivider() {
    return Divider(
      color: divider,
    );
  }

  Future<void> getUserProfile() async {
    try {
      var loginDetails = await SharedService.loginDetails();
      if (this.mounted) {
        setState(() {
          username = loginDetails!.username;
          email = loginDetails.email;
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
