import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import '../model/schedule.dart';
import '../model/schedulesArguments.dart';
import '../viewModel/scheduleListViewModel.dart';
import 'scheduleSettingDialog.dart';
import 'viewSelectDrawer.dart';
import 'confirmDeleteScheduleDialog.dart';

const String dateTimeFormat = "yyyy-MM-dd HH:mm";

class ScheduleListView extends StatefulWidget {
  const ScheduleListView({Key? key, required this.title, this.user})
      : super(key: key);

  final String title;
  final User? user;

  @override
  State<ScheduleListView> createState() => _ScheduleListViewState();
}

class _ScheduleListViewState extends State<ScheduleListView> {
  late User? user;

  @override
  void initState() {
    super.initState();
    user = widget.user;
  }

  @override
  Widget build(BuildContext context) {
    if (user != null) {
      Provider.of<ScheduleListViewModel>(context).fetchSchedules(user!);
    }
    return Scaffold(
      drawer: ViewSelectDrawer(
          schedules: Provider.of<ScheduleListViewModel>(context).schedules),
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
                      onPressed: showAddScheduleDialog,
                    ),
                  ),
                ),
              );
            }, childCount: 1),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
              return Container(
                margin: const EdgeInsets.fromLTRB(4, 0, 4, 0),
                child: Card(
                  child: ListTile(
                    leading: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          alignment: Alignment.center,
                          width: 30,
                          child: Text(
                              Provider.of<ScheduleListViewModel>(context)
                                  .schedules[index]
                                  .motivation
                                  .toString()),
                        ),
                        Container(
                          margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: Provider.of<ScheduleListViewModel>(context)
                                  .schedules[index]
                                  .doubleBookingSchedule
                                  .isNotEmpty
                              ? Icon(
                                  Icons.warning,
                                  color: Colors.yellow.shade600,
                                )
                              : Container(),
                        ),
                      ],
                    ),
                    title: Text(Provider.of<ScheduleListViewModel>(context)
                        .schedules[index]
                        .name),
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
                          onPressed: () => deleteSchedule(index),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
                childCount: Provider.of<ScheduleListViewModel>(context)
                    .schedules
                    .length),
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
      Provider.of<ScheduleListViewModel>(context).insertSchedule(schedule);
      Provider.of<ScheduleListViewModel>(context).checkDoubleBooking(schedule);
    }
  }

  void showFixScheduleDialog(int scheduleIndex) async {
    final schedule = await showDialog<Schedule>(
      context: context,
      builder: (context) => ScheduleSettingDialog(
          initialMethod: ScheduleSettingMethod.fix,
          initialSchedule: Provider.of<ScheduleListViewModel>(context)
              .schedules[scheduleIndex]),
    );
    if (schedule != null) {
      Provider.of<ScheduleListViewModel>(context)
          .schedules
          .removeAt(scheduleIndex);
      Provider.of<ScheduleListViewModel>(context).insertSchedule(schedule);
      Provider.of<ScheduleListViewModel>(context).checkDoubleBooking(schedule);
    }
  }

  void deleteSchedule(int scheduleIndex) async {
    final isDelete = await showDialog<bool>(
      context: context,
      builder: (context) => ConfirmDeleteScheduleDialog(
          title: Provider.of<ScheduleListViewModel>(context)
                  .schedules[scheduleIndex]
                  .name +
              "を削除しますか?"),
    );

    if (isDelete == true) {
      Provider.of<ScheduleListViewModel>(context)
          .schedules
          .removeAt(scheduleIndex);
    }
  }

  Widget getSubTitle(int scheduleIndex) {
    if (Provider.of<ScheduleListViewModel>(context)
        .schedules[scheduleIndex]
        .doubleBookingSchedule
        .isEmpty) {
      return Text(DateFormat(dateTimeFormat).format(
              Provider.of<ScheduleListViewModel>(context)
                  .schedules[scheduleIndex]
                  .startDateTime) +
          " ~ " +
          DateFormat(dateTimeFormat).format(
              Provider.of<ScheduleListViewModel>(context)
                  .schedules[scheduleIndex]
                  .endDateTime));
    } else {
      String warning = "It's double-booked with ";
      for (var doubleBooked in Provider.of<ScheduleListViewModel>(context)
          .schedules[scheduleIndex]
          .doubleBookingSchedule) {
        warning += '"' + doubleBooked.name + '"';
        warning += " , ";
      }
      warning = warning.replaceRange(warning.length - 3, null, '.');
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.fromLTRB(0, 4, 0, 0),
            child: Text(DateFormat(dateTimeFormat).format(
                    Provider.of<ScheduleListViewModel>(context)
                        .schedules[scheduleIndex]
                        .startDateTime) +
                " ~ " +
                DateFormat(dateTimeFormat).format(
                    Provider.of<ScheduleListViewModel>(context)
                        .schedules[scheduleIndex]
                        .endDateTime)),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: DefaultTextStyle(
              style: TextStyle(color: Colors.yellow.shade600),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              child: Text(warning),
            ),
          ),
        ],
      );
    }
  }
}
