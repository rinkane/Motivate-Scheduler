import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../notifier/complete_schedule.dart';
import 'components/leading.dart';
import 'components/subtitle.dart';
import 'components/trailing_completed.dart';
import 'components/title.dart';

class ScheduleCompletedListTile extends HookConsumerWidget {
  final int index;

  const ScheduleCompletedListTile({Key? key, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final schedule = ref.watch(completeScheduleListProvider).schedules[index];
    return ListTile(
      title: ListTileTitle(schedule: schedule),
      leading: ListTileLeading(schedule: schedule),
      subtitle: ListTileSubTitle(schedule: schedule),
      trailing: ListTileTrailingCompleted(schedule: schedule),
    );
  }
}
