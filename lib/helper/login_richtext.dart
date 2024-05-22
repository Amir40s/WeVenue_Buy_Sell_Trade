import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../constant.dart';
class LoginRichText extends StatelessWidget {
  final VoidCallback press;
  final firstText,secondText;
  const LoginRichText({super.key, required this.press, required this.firstText,required this.secondText});

  @override
  Widget build(BuildContext context) {
    return RichText(
        text: TextSpan(
      text: firstText,
      style:  TextStyle(color: Colors.black,),
      children: <InlineSpan>[
        const WidgetSpan(
            alignment: PlaceholderAlignment.baseline,
            baseline: TextBaseline.alphabetic,
            child: SizedBox(width: 5.0)),
        TextSpan(
          text: secondText,
          style: const TextStyle(color: lightBlue),
          recognizer: TapGestureRecognizer()
            ..onTap = press,
        ),
        TextSpan(
            text: "and ",
            style: const TextStyle(color: Colors.black),
            recognizer: TapGestureRecognizer()
        ),
        TextSpan(
          text: "Community Guidelines ",
          style: const TextStyle(color: lightBlue),
          recognizer: TapGestureRecognizer()
        ),
        TextSpan(
          text: "and Have read ",
          style: const TextStyle(color: Colors.black),
          recognizer: TapGestureRecognizer()
        ),
        TextSpan(
            text: "Privacy Policy ",
            style: const TextStyle(color: lightBlue),
            recognizer: TapGestureRecognizer()
        ),
      ],
    )
    );
  }
}
