import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:scheduler/notifier/complete_schedule.dart';
import 'package:scheduler/notifier/schedule.dart';
import 'package:scheduler/notifier/user.dart';
import 'package:scheduler/repository/schedule_repository_impl.dart';

import '../../model/schedule.dart';

class ViewSelectDrawer extends HookConsumerWidget {
  const ViewSelectDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userNotifier = ref.watch(userProvider);
    var scheduleNotifier = ref.watch(scheduleListProvider.notifier);
    var completeScheduleNotifier =
        ref.watch(completeScheduleListProvider.notifier);
    var scheduleState = ref.watch(scheduleListProvider);
    var completeScheduleState = ref.watch(completeScheduleListProvider);
    var scheduleRepository = ref.watch(scheduleRepositoryProvider);
    final List<Schedule> allSchedules = [];
    allSchedules.addAll(scheduleState.schedules);
    allSchedules.addAll(completeScheduleState.schedules);
    allSchedules.sort(((a, b) => a.endDateTime.compareTo(b.endDateTime)));
    final motivation = calcNowMotivation(allSchedules);
    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountEmail: Text(
              userNotifier.user?.email ?? "",
            ),
            decoration: const BoxDecoration(
              color: Colors.purple,
            ),
            accountName: null,
            currentAccountPicture: CircleAvatar(
              child: Text(
                motivation.toString(),
                style: const TextStyle(fontSize: 24),
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pushNamed("/home"),
            child: const ListTile(
              leading: Icon(Icons.schedule),
              title: Text("Schedules"),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pushNamed("/motivation"),
            child: const ListTile(
              leading: Icon(Icons.auto_graph),
              title: Text("Motivation"),
            ),
          ),
          const Divider(
              thickness: 1, indent: 10, endIndent: 10, color: Colors.black38),
          TextButton(
            onPressed: () => Navigator.of(context).pushNamed("/complete"),
            child: const ListTile(
              leading: Icon(Icons.check_circle_outline),
              title: Text("Complete Schedules"),
            ),
          ),
          const Divider(
              thickness: 1, indent: 10, endIndent: 10, color: Colors.black38),
          TextButton(
            onPressed: () async {
              userNotifier
                  .signOut()
                  .onError((error, stackTrace) => null)
                  .whenComplete(() {
                scheduleNotifier.clearSchedule();
                completeScheduleNotifier.clearSchedule();
                scheduleRepository.signOutRepository();
                Navigator.of(context).pushNamed("/home");
              });
            },
            child: const ListTile(
              leading: Icon(Icons.logout),
              title: Text("Logout"),
            ),
          ),
        ],
      ),
    );
  }

  int calcNowMotivation(List<Schedule> schedules) {
    int motivation = schedules
        .where((schedule) => schedule.endDateTime.isBefore(DateTime.now()))
        .fold(0, (sum, schedule) => sum += schedule.motivation);

    return motivation;
  }
}
