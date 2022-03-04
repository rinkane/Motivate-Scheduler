import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class OneLineText extends HookConsumerWidget {
  final String text;
  final double fontSize;

  const OneLineText({Key? key, required this.text, this.fontSize = 16})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Wrap(
      children: <Widget>[
        DefaultTextStyle(
          child: Text(text),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: TextStyle(fontSize: fontSize),
        ),
      ],
    );
  }
}
