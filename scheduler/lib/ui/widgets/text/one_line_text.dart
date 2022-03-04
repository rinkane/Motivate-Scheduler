import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class OneLineText extends HookConsumerWidget {
  final String text;

  const OneLineText({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTextStyle(
      child: Text(text),
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
      style: const TextStyle(),
    );
  }
}
