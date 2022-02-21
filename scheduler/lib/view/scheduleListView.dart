import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/schedule.dart';
import 'scheduleSettingDialog.dart';

const String dateTimeFormat = "yyyy-MM-dd HH:mm";

class ScheduleListView extends StatefulWidget {
  const ScheduleListView({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<ScheduleListView> createState() => _ScheduleListViewState();
}

class _ScheduleListViewState extends State<ScheduleListView> {
  var schedules = <Schedule>[Schedule()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(title: Text(widget.title)),
          SliverList(
            delegate:
                SliverChildBuilderDelegate((BuildContext context, int index) {
              return Card(
                child: ListTile(
                  leading: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(schedules[index].motivation.toString())
                    ],
                  ),
                  title: Text(schedules[index].name),
                  subtitle: Text(DateFormat(dateTimeFormat)
                          .format(schedules[index].startDateTime) +
                      " ~ " +
                      DateFormat(dateTimeFormat)
                          .format(schedules[index].endDateTime)),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      IconButton(
                        icon: const Icon(Icons.change_circle),
                        onPressed: () {
                          showFixScheduleDialog(index);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            schedules.removeAt(index);
                          });
                        },
                      ),
                    ],
                  ),
                ),
              );
            }, childCount: schedules.length),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showAddScheduleDialog,
        tooltip: 'Add Schedule',
        child: const Icon(Icons.add),
      ),
    );
  }

  void showAddScheduleDialog() async {
    final schedule = await showDialog<Schedule>(
        context: context,
        builder: (context) => const ScheduleSettingDialog(
            initialMethod: ScheduleSettingMethod.add));
    if (schedule != null) {
      insertSchedule(schedule);
    }
  }

  void showFixScheduleDialog(int scheduleIndex) async {
    final schedule = await showDialog<Schedule>(
      context: context,
      builder: (context) => ScheduleSettingDialog(
          initialMethod: ScheduleSettingMethod.fix,
          initialSchedule: schedules[scheduleIndex]),
    );
    if (schedule != null) {
      setState(() {
        schedules.removeAt(scheduleIndex);
      });
      insertSchedule(schedule);
    }
  }

  void insertSchedule(Schedule schedule) {
    for (int i = 0; i < schedules.length; i++) {
      if (schedules[i].startDateTime.isAfter(schedule.startDateTime)) {
        setState(() {
          schedules.insert(i, schedule);
        });
        return;
      }
    }
    setState(() {
      schedules.add(schedule);
    });
  }
}
