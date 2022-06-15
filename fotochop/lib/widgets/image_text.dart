import 'package:flutter/material.dart';
import 'package:fotochop/models/text_info.dart';
import 'package:google_fonts/google_fonts.dart';

class ImageText extends StatelessWidget {
  final TextInfo textInfo;
  const ImageText({Key? key, required this.textInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      textInfo.text,
      textAlign: textInfo.textAlign,
      style: TextStyle(
        color: textInfo.color,
        fontWeight: textInfo.fontWeight,
        fontStyle: textInfo.fontStyle,
        fontSize: textInfo.fontSize,
        fontFamily: GoogleFonts.getFont(textInfo.fontFamily).fontFamily,
      ),
    );
  }
}
