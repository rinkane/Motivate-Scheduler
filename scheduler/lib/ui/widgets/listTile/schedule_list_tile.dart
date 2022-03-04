import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../model/schedule.dart';
import 'components/title.dart';
import 'components/leading_with_warning.dart';
import 'components/subtitle_with_warning.dart';
import 'components/trailing.dart';

class ScheduleListTile extends HookConsumerWidget {
  final Schedule schedule;

  const ScheduleListTile({Key? key, required this.schedule}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      title: ListTileTitle(schedule: schedule),
      leading: ListTileLeadingWithWarning(schedule: schedule),
      subtitle: ListTileSubTitleWithWarning(schedule: schedule),
      trailing: ListTileTrailing(schedule: schedule),
    );
  }
}
