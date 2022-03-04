import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../model/schedule.dart';

class ListTileTitleName extends HookConsumerWidget {
  final Schedule schedule;

  const ListTileTitleName({Key? key, required this.schedule}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTextStyle(
      child: Text(schedule.name),
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
      style: const TextStyle(),
    );
  }
}
