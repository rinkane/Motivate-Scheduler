import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../model/schedule.dart';
import 'components/subtitle_duration.dart';
import 'components/subtitle_warning_text.dart';

class ListTileSubTitleWithWarning extends HookConsumerWidget {
  final Schedule schedule;

  const ListTileSubTitleWithWarning({Key? key, required this.schedule})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ListTileSubTitleDuration(schedule: schedule),
        ListTileSubTitleWarningText(schedule: schedule),
      ],
    );
  }
}
