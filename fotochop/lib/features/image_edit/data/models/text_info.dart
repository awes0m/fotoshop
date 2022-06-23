import 'dart:ui';

import 'package:flutter/material.dart';

///[TextInfo] is used to store all required text information under one object
///eg. text, fontSize, fontColor, fontFamily, left, top
class TextInfo {
  String text;
  double left;
  double top;
  Color color;
  FontWeight fontWeight;
  FontStyle fontStyle;
  double fontSize;
  TextAlign textAlign;
  String fontFamily;

  TextInfo({
    required this.text,
    required this.left,
    required this.top,
    required this.color,
    required this.fontWeight,
    required this.fontStyle,
    required this.fontSize,
    required this.textAlign,
    required this.fontFamily,
  });
}
