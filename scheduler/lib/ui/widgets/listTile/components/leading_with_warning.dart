import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../model/schedule.dart';
import 'components/leading_warning_icon.dart';
import 'components/leading_motivation.dart';

class ListTileLeadingWithWarning extends HookConsumerWidget {
  final Schedule schedule;

  const ListTileLeadingWithWarning({Key? key, required this.schedule})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        ListTileLeadingMotivation(schedule: schedule),
        ListTileLeadingWarningIcon(schedule: schedule),
      ],
    );
  }
}
