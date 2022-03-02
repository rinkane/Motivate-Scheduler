import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dotted_border/dotted_border.dart';

import '../model/completeSchedule.dart';
import '../model/schedule.dart';
import '../viewModel/completeScheduleListViewModel.dart';
import '../viewModel/scheduleListViewModel.dart';
import 'scheduleCompleteDialog.dart';
import 'scheduleSettingDialog.dart';
import 'viewSelectDrawer.dart';
import 'confirmDeleteScheduleDialog.dart';

const String dateTimeformat = "yyyy-MM-dd HH:mm";

class ScheduleListView extends StatelessWidget {
  const ScheduleListView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final scheduleListViewModel = Provider.of<ScheduleListViewModel>(context);
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

class ScheduleList extends StatelessWidget {
  const ScheduleList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scheduleListViewModel = Provider.of<ScheduleListViewModel>(context);
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return ScheduleCard(index: index);
        },
        childCount: scheduleListViewModel.schedules.length,
      ),
    );
  }
}

class ScheduleCard extends StatelessWidget {
  final int index;

  const ScheduleCard({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scheduleListViewModel = Provider.of<ScheduleListViewModel>(context);
    final completeScheduleListViewModel =
        Provider.of<CompleteScheduleListViewModel>(context);
    final schedule = scheduleListViewModel.schedules[index];
    return Card(
      child: ListTile(
        title: DefaultTextStyle(
          child: Text(schedule.name),
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
                schedule.motivation.toString(),
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            Visibility(
              visible: schedule.doubleBookedCount != 0,
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
                schedule.getDurationText(),
              ),
            ),
            Visibility(
              visible: schedule.doubleBookedCount != 0,
              child: Container(
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: DefaultTextStyle(
                  child: Text(schedule.getDoubleBookedWarningText()),
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
              child: schedule.isCompleteAt(DateTime.now())
                  ? ElevatedButton(
                      child: const Text("complete"),
                      onPressed: () async {
                        final completeSchedule =
                            await showDialog<CompleteSchedule>(
                          context: context,
                          builder: (context) =>
                              ScheduleCompleteDialog(initialSchedule: schedule),
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
                        final completeSchedule =
                            await showDialog<CompleteSchedule>(
                          context: context,
                          builder: (context) =>
                              ScheduleCompleteDialog(initialSchedule: schedule),
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
                      initialSchedule: schedule),
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
                      ConfirmDeleteScheduleDialog(title: schedule.name),
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
