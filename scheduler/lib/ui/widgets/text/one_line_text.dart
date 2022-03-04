import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class OneLineText extends HookConsumerWidget {
  final String ellipsisText;

  const OneLineText({Key? key, required this.ellipsisText}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Wrap(
      children: <Widget>[
        DefaultTextStyle(
          child: Text(ellipsisText),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
