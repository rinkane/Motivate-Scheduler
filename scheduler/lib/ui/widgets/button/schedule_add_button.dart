import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../model/schedule.dart';
import '../../../notifier/schedule.dart';
import '../../dialogs/schedule_setting_dialog.dart';

class ScheduleAddButton extends HookConsumerWidget {
  const ScheduleAddButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheduleListViewModel = ref.read(scheduleListProvider.notifier);
    return SliverList(
      delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
        return Container(
          height: 60,
          margin: const EdgeInsets.fromLTRB(8, 8, 8, 4),
          child: DottedBorder(
            color: Colors.black26,
            strokeWidth: 1,
            dashPattern: const [10, 10],
            radius: const Radius.circular(4),
            child: ConstrainedBox(
              constraints: const BoxConstraints.expand(),
              child: TextButton(
                child: const Icon(Icons.add),
                onPressed: () async {
                  final schedule = await showDialog<Schedule>(
                    context: context,
                    builder: (context) => const ScheduleSettingDialog(
                      initialMethod: ScheduleSettingMethod.add,
                    ),
                  );
                  if (schedule != null) {
                    scheduleListViewModel.addSchedule(schedule);
                  }
                },
              ),
            ),
          ),
        );
      }, childCount: 1),
    );
  }
}
