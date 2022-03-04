import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../model/schedule.dart';

class ListTileSubTitleWarningText extends HookConsumerWidget {
  final Schedule schedule;

  const ListTileSubTitleWarningText({Key? key, required this.schedule})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Visibility(
      visible: schedule.doubleBookedCount != 0,
      child: Container(
        margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: DefaultTextStyle(
          child: Text(schedule.getDoubleBookedWarningText()),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: TextStyle(
            color: Colors.yellow.shade600,
          ),
        ),
      ),
    );
  }
}
