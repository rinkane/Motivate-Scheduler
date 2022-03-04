import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../model/schedule.dart';

class ListTileLeadingMotivation extends HookConsumerWidget {
  final Schedule schedule;

  const ListTileLeadingMotivation({Key? key, required this.schedule})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      alignment: Alignment.center,
      width: 30,
      child: Text(
        schedule.motivation.toString(),
        style: const TextStyle(
          fontSize: 16,
        ),
      ),
    );
  }
}
