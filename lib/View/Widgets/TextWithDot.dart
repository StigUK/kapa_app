import 'package:flutter/material.dart';
import 'package:kapa_app/Resources/colors.dart';

Widget textWithDot(String text)
{
  return Padding(
    padding: const EdgeInsets.all(10),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      //mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(
          Icons.brightness_1,
          color: appThemeBlueMainColor,
          size: 10.0,
        ),
        SizedBox(width: 10.0),
        Text(
          text,
          style: TextStyle(fontSize: 18),
        ),
      ],
    ),
  );
}
