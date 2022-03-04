import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../model/schedule.dart';
import '../../../../../notifier/complete_schedule.dart';
import '../../../../../notifier/schedule.dart';
import '../../../../dialogs/schedule_complete_dialog.dart';

class ListTileTrailingCompleteButton extends HookConsumerWidget {
  final Schedule schedule;

  const ListTileTrailingCompleteButton({Key? key, required this.schedule})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
      child: schedule.isCompleteAt(DateTime.now())
          ? ElevatedButton(
              child: const Text("complete"),
              onPressed: () async => completeSchedule(context, ref),
            )
          : OutlinedButton(
              child: const Text("complete",
                  style: TextStyle(
                    color: Colors.black87,
                  )),
              onPressed: () async => completeSchedule(context, ref),
            ),
    );
  }

  Future<void> completeSchedule(BuildContext context, WidgetRef ref) async {
    final scheduleListViewModel = ref.read(scheduleListProvider.notifier);
    final completeScheduleListViewModel =
        ref.read(completeScheduleListProvider.notifier);
    final schedules = ref.watch(scheduleListProvider).schedules;

    final completeSchedule = await showDialog<Schedule>(
      context: context,
      builder: (context) => ScheduleCompleteDialog(initialSchedule: schedule),
    );
    if (completeSchedule == null) {
      return;
    }
    completeScheduleListViewModel.addCompleteSchedule(completeSchedule);
    scheduleListViewModel.deleteSchedule(schedules.indexOf(schedule));
  }
}
