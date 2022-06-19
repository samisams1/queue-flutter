/**
 * Author samisams
 * */
import 'package:flutter/material.dart';

Widget createDrawerBodyItem(
    {required IconData icon,
    required String text,
    required GestureTapCallback onTap}) {
  return ListTile(
    title: Row(
      children: <Widget>[
        Icon(
          icon,
          color: Color.fromARGB(255, 91, 94, 173),
        ),
        Padding(
          padding: EdgeInsets.only(left: 0.0),
          child: Text(text,
              style: TextStyle(
                  color: Color.fromARGB(255, 91, 94, 173),
                  fontSize: 16.0,
                  fontWeight: FontWeight.w700)),
        )
      ],
    ),
    onTap: onTap,
  );
}
