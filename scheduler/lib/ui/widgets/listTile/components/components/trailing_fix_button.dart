import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../model/schedule.dart';
import '../../../../../notifier/schedule.dart';
import '../../../../dialogs/schedule_setting_dialog.dart';

class ListTileTrailingFixButton extends HookConsumerWidget {
  final Schedule schedule;

  const ListTileTrailingFixButton({Key? key, required this.schedule})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheduleListViewModel = ref.watch(scheduleListProvider.notifier);
    final schedules = ref.watch(scheduleListProvider).schedules;
    return IconButton(
      icon: const Icon(Icons.mode_edit),
      onPressed: () async {
        final _schedule = await showDialog<Schedule>(
          context: context,
          builder: (context) => ScheduleSettingDialog(
              initialMethod: ScheduleSettingMethod.fix,
              initialSchedule: schedule),
        );
        if (_schedule != null) {
          scheduleListViewModel.updateSchedule(
              _schedule, schedules.indexOf(schedule));
        }
      },
    );
  }
}
