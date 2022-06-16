import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:snippet_coder_utils/hex_color.dart';

Widget createDrawerBodyItem(
    {required IconData icon,
    required String text,
    required GestureTapCallback onTap}) {
  return ListTile(
    title: Row(
      children: <Widget>[
        Icon(icon),
        Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Text(text,
              style: TextStyle(
                  color: HexColor("080000"),
                  fontSize: 20.0,
                  fontWeight: FontWeight.w700)),
        )
      ],
    ),
    onTap: onTap,
  );
}
