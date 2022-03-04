import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:dotted_border/dotted_border.dart';

import '../../model/schedule.dart';
import '../../state/complete_schedule.dart';
import '../../state/schedule.dart';
import '../dialogs/schedule_complete_dialog.dart';
import '../dialogs/schedule_setting_dialog.dart';
import '../widgets/view_select_drawer.dart';
import '../dialogs/confirm_delete_schedule_dialog.dart';

const String dateTimeformat = "yyyy-MM-dd HH:mm";

class ScheduleListView extends HookConsumerWidget {
  const ScheduleListView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheduleListViewModel = ref.read(scheduleListProvider.notifier);
    return Scaffold(
      drawer: const ViewSelectDrawer(),
      body: CustomScrollView(
        slivers: <Widget>[
          const SliverAppBar(
            title: Text("motivate scheduler"),
          ),
          SliverList(
            delegate:
                SliverChildBuilderDelegate((BuildContext context, int index) {
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
          ),
          const ScheduleList(),
        ],
      ),
    );
  }
}

class ScheduleList extends HookConsumerWidget {
  const ScheduleList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final schedules = ref.watch(scheduleListProvider).schedules;
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return ScheduleCard(index: index);
        },
        childCount: schedules.length,
      ),
    );
  }
}

class ScheduleCard extends HookConsumerWidget {
  final int index;

  const ScheduleCard({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheduleListViewModel = ref.read(scheduleListProvider.notifier);
    final completeScheduleListViewModel =
        ref.read(completeScheduleListProvider.notifier);
    final schedules = ref.watch(scheduleListProvider).schedules;
    return Card(
      child: ListTile(
        title: DefaultTextStyle(
          child: Text(schedules[index].name),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: const TextStyle(),
        ),
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              width: 30,
              child: Text(
                schedules[index].motivation.toString(),
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            Visibility(
              visible: schedules[index].doubleBookedCount != 0,
              child: Container(
                alignment: Alignment.center,
                width: 50,
                child: Icon(
                  Icons.warning,
                  color: Colors.yellow.shade600,
                ),
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Text(
                schedules[index].getDurationText(),
              ),
            ),
            Visibility(
              visible: schedules[index].doubleBookedCount != 0,
              child: Container(
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: DefaultTextStyle(
                  child: Text(schedules[index].getDoubleBookedWarningText()),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(
                    color: Colors.yellow.shade600,
                  ),
                ),
              ),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
              child: schedules[index].isCompleteAt(DateTime.now())
                  ? ElevatedButton(
                      child: const Text("complete"),
                      onPressed: () async {
                        final completeSchedule = await showDialog<Schedule>(
                          context: context,
                          builder: (context) => ScheduleCompleteDialog(
                              initialSchedule: schedules[index]),
                        );
                        if (completeSchedule == null) {
                          return;
                        }
                        completeScheduleListViewModel
                            .addCompleteSchedule(completeSchedule);
                        scheduleListViewModel.deleteSchedule(index);
                      },
                    )
                  : OutlinedButton(
                      child: const Text("complete",
                          style: TextStyle(
                            color: Colors.black87,
                          )),
                      onPressed: () async {
                        final completeSchedule = await showDialog<Schedule>(
                          context: context,
                          builder: (context) => ScheduleCompleteDialog(
                              initialSchedule: schedules[index]),
                        );
                        if (completeSchedule == null) {
                          return;
                        }
                        completeScheduleListViewModel
                            .addCompleteSchedule(completeSchedule);
                        scheduleListViewModel.deleteSchedule(index);
                      },
                    ),
            ),
            IconButton(
              icon: const Icon(Icons.mode_edit),
              onPressed: () async {
                final _schedule = await showDialog<Schedule>(
                  context: context,
                  builder: (context) => ScheduleSettingDialog(
                      initialMethod: ScheduleSettingMethod.fix,
                      initialSchedule: schedules[index]),
                );
                if (_schedule != null) {
                  scheduleListViewModel.updateSchedule(_schedule, index);
                }
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                final isDelete = await showDialog<bool>(
                  context: context,
                  builder: (context) =>
                      ConfirmDeleteScheduleDialog(title: schedules[index].name),
                );
                if (isDelete == true) {
                  scheduleListViewModel.deleteSchedule(index);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void completeSchedule(BuildContext context, Schedule schedule) async {}
}
