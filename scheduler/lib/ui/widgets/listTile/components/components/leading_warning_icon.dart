import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../model/schedule.dart';

class ListTileLeadingWarningIcon extends HookConsumerWidget {
  final Schedule schedule;

  const ListTileLeadingWarningIcon({Key? key, required this.schedule})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Visibility(
      visible: schedule.doubleBookedCount != 0,
      child: Container(
        alignment: Alignment.center,
        width: 50,
        child: Icon(
          Icons.warning,
          color: Colors.yellow.shade600,
        ),
      ),
    );
  }
}
