import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../model/schedule.dart';
import '../../../../notifier/schedule.dart';
import '../../../dialogs/confirm_delete_schedule_dialog.dart';
import 'components/trailing_complete_button.dart';
import 'components/trailing_fix_button.dart';
import 'components/trailing_delete_button.dart';

class ListTileTrailing extends HookConsumerWidget {
  final Schedule schedule;

  const ListTileTrailing({Key? key, required this.schedule}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheduleListViewModel = ref.read(scheduleListProvider.notifier);
    final schedules = ref.watch(scheduleListProvider).schedules;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ListTileTrailingCompleteButton(schedule: schedule),
        ListTileTrailingFixButton(schedule: schedule),
        ListTileTrailingDeleteButton(
          deleteSchedule: () async {
            final isDelete = await showDialog<bool>(
              context: context,
              builder: (context) =>
                  ConfirmDeleteScheduleDialog(title: schedule.name),
            );
            if (isDelete == true) {
              scheduleListViewModel.deleteSchedule(schedules.indexOf(schedule));
            }
          },
        ),
      ],
    );
  }
}
