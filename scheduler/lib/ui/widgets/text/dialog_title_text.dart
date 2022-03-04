import 'package:flutter/material.dart';

import 'one_line_text.dart';

class DialogTitleText extends StatelessWidget {
  final String ellipsisText;
  final String text;

  const DialogTitleText(
      {Key? key, required this.ellipsisText, required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: OneLineText(
            text: ellipsisText,
            fontSize: 20,
          ),
        ),
        OneLineText(
          text: text,
          fontSize: 20,
        ),
      ],
    );
  }
}
