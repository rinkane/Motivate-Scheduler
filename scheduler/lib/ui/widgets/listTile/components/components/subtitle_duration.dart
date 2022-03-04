import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../model/schedule.dart';

class ListTileSubTitleDuration extends HookConsumerWidget {
  final Schedule schedule;

  const ListTileSubTitleDuration({Key? key, required this.schedule})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Text(
      schedule.getDurationText(),
    );
  }
}
