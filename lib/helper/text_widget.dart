import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  final String text;
  Color color;
  final double? size;
  bool isBold;
  var fontFamily, textAlignment;
  bool italic;
  int maxLine;

  TextWidget(
      {super.key,
      required this.text,
      this.color = Colors.black,
      this.size,
      this.isBold = false,
      this.fontFamily = '',
      this.textAlignment = TextAlign.start,
      this.italic = false,
      this.maxLine = 100});

  @override
  Widget build(BuildContext context) {
    return AutoSizeText(
      text,
      softWrap: true,
      minFontSize: 11.0,
      maxFontSize: size ?? 16,
      maxLines: maxLine,
      // overflow: TextOverflow.ellipsis,
      style: TextStyle(
          color: color,
          fontSize: size,
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          fontStyle: italic ? FontStyle.italic : FontStyle.normal,
          fontFamily: fontFamily,
          decoration: TextDecoration.none),
      textAlign: textAlignment,
    );
  }
}
