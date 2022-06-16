import 'package:flutter/material.dart';
import 'package:queue/pages/aboutPage.dart';
import 'package:queue/pages/eventPage.dart';
import 'package:queue/pages/homePage.dart';
import 'package:queue/pages/notificationPage.dart';
import 'package:queue/pages/profilePage.dart';
import 'package:queue/routes/pageRoute.dart';
import 'package:queue/pages/myTicketPage.dart';
import 'package:queue/pages/register_page.dart';
import 'package:queue/pages/login_page.dart';
import 'package:queue/services/shared_service.dart';

Widget _defaultHome = const LoginPage();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Get result of the login function.
  bool _result = await SharedService.isLoggedIn();
  if (_result) {
    _defaultHome = const homePage();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Queue Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        //  home: LoginPage(),
        routes: {
          '/': ((context) => _defaultHome),
          pageRoutes.home: (context) => homePage(),
          pageRoutes.about: (context) => SchoolList(),
          pageRoutes.event: (context) => eventPage(),
          pageRoutes.profile: (context) => profilePage(),
          pageRoutes.notification: (context) => notificationPage(),
          pageRoutes.myTicket: (context) => MyTicketPage(),
          pageRoutes.register: (context) => RegisterPage(),
          pageRoutes.login: (context) => LoginPage(),
        });
  }
}
