import 'package:flutter/material.dart';

class AppTextStyle {
  static TextStyle mediumBold({Color color = Colors.white}) =>
      TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: color);

  static TextStyle hintTextStyle({Color color = Colors.white}) => TextStyle(
      fontSize: 20,
      fontStyle: FontStyle.italic,
      color: color,
      fontFamily: 'Roboto');

  static TextStyle smallBold({Color color = Colors.white}) => TextStyle(
        color: color,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      );
  static TextStyle mediumNormal({Color color = Colors.white}) => TextStyle(
        color: color,
        fontStyle: FontStyle.normal,
        fontSize: 25,
      );
}
