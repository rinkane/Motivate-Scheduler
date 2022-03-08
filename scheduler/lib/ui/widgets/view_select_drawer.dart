import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:scheduler/notifier/complete_schedule.dart';
import 'package:scheduler/notifier/schedule.dart';
import 'package:scheduler/notifier/user.dart';
import 'package:scheduler/repository/schedule_repository_impl.dart';

class ViewSelectDrawer extends HookConsumerWidget {
  const ViewSelectDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userNotifier = ref.watch(userProvider);
    var scheduleState = ref.watch(scheduleListProvider.notifier);
    var completeScheduleState =
        ref.watch(completeScheduleListProvider.notifier);
    var scheduleRepository = ref.watch(scheduleRepositoryProvider);
    return Drawer(
      child: ListView(
        children: <Widget>[
          const SizedBox(
            height: 100,
            child: DrawerHeader(
              child: Text(
                "Menu",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.purple,
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
                scheduleState.clearSchedule();
                completeScheduleState.clearSchedule();
                scheduleRepository.signOutRepository();
                Navigator.of(context).pushNamed("/login");
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
}
