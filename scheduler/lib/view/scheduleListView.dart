import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/schedule.dart';
import 'scheduleSettingDialog.dart';

const String dateTimeFormat = "yyyy-MM-dd HH:mm";

class ScheduleListView extends StatefulWidget {
  const ScheduleListView(
      {Key? key, required this.title, required this.schedules})
      : super(key: key);

  final String title;
  final List<Schedule> schedules;

  @override
  State<ScheduleListView> createState() => _ScheduleListViewState();
}

class _ScheduleListViewState extends State<ScheduleListView> {
  late List<Schedule> schedules = <Schedule>[];

  @override
  void initState() {
    super.initState();

    for (var _schedule in widget.schedules) {
      insertSchedule(_schedule);
      checkDoubleBooking(_schedule);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            title: Text(widget.title),
          ),
          SliverList(
            delegate:
                SliverChildBuilderDelegate((BuildContext context, int index) {
              return Container(
                height: 60,
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black12,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: TextButton(
                  child: const Icon(Icons.add),
                  onPressed: showAddScheduleDialog,
                ),
              );
            }, childCount: 1),
          ),
          SliverList(
            delegate:
                SliverChildBuilderDelegate((BuildContext context, int index) {
              return Card(
                child: ListTile(
                  leading: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        alignment: Alignment.center,
                        width: 30,
                        child: Text(schedules[index].motivation.toString()),
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: schedules[index].doubleBookingSchedule.isNotEmpty
                            ? Icon(
                                Icons.warning,
                                color: Colors.yellow.shade600,
                              )
                            : Container(),
                      ),
                    ],
                  ),
                  title: Text(schedules[index].name),
                  subtitle: getSubTitle(index),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      IconButton(
                        icon: const Icon(Icons.mode_edit),
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
          )
        ],
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
      checkDoubleBooking(schedule);
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
      checkDoubleBooking(schedule);
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

  void checkDoubleBooking(Schedule schedule) {
    for (int i = 0; i < schedules.length; i++) {
      if (schedules[i].isDuring(schedule) || schedule.isDuring(schedules[i])) {
        setState(() {
          schedule.addDoubleBookingSchedule(schedules[i]);
          schedules[i].addDoubleBookingSchedule(schedule);
        });
      } else {
        setState(() {
          schedule.doubleBookingSchedule.remove(schedules[i]);
          schedules[i].doubleBookingSchedule.remove(schedule);
        });
      }
    }
  }

  Widget getSubTitle(int scheduleIndex) {
    if (schedules[scheduleIndex].doubleBookingSchedule.isEmpty) {
      return Text(DateFormat(dateTimeFormat)
              .format(schedules[scheduleIndex].startDateTime) +
          " ~ " +
          DateFormat(dateTimeFormat)
              .format(schedules[scheduleIndex].endDateTime));
    } else {
      String warning = "It's double-booked with ";
      for (var doubleBooked in schedules[scheduleIndex].doubleBookingSchedule) {
        warning += '"' + doubleBooked.name + '"';
        warning += " , ";
      }
      warning = warning.replaceRange(warning.length - 3, null, '.');
      return Row(
        children: <Widget>[
          Text(DateFormat(dateTimeFormat)
                  .format(schedules[scheduleIndex].startDateTime) +
              " ~ " +
              DateFormat(dateTimeFormat)
                  .format(schedules[scheduleIndex].endDateTime)),
          Container(
            margin: const EdgeInsets.fromLTRB(10, 0, 0, 2),
            child:
                Text(warning, style: TextStyle(color: Colors.yellow.shade600)),
          ),
        ],
      );
    }
  }
}
