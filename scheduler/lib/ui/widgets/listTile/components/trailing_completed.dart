import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../model/schedule.dart';
import '../../../../notifier/complete_schedule.dart';
import '../../../dialogs/confirm_delete_schedule_dialog.dart';
import 'components/trailing_delete_button.dart';

class ListTileTrailingCompleted extends HookConsumerWidget {
  final Schedule schedule;

  const ListTileTrailingCompleted({Key? key, required this.schedule})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ListTileTrailingDeleteButton(
          deleteSchedule: () => deleteCompleteSchedule(context, ref),
        ),
      ],
    );
  }

  Future<void> deleteCompleteSchedule(
      BuildContext context, WidgetRef ref) async {
    final scheduleListViewModel =
        ref.read(completeScheduleListProvider.notifier);
    final schedules = ref.watch(completeScheduleListProvider);
    final isDelete = await showDialog<bool>(
      context: context,
      builder: (context) => ConfirmDeleteScheduleDialog(title: schedule.name),
    );
    if (isDelete == true) {
      scheduleListViewModel.deleteCompleteSchedule(schedules.indexOf(schedule));
    }
  }
}
