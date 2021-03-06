import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:scheduler/ui/widgets/login_state_selector.dart';

import '../../model/schedule.dart';
import '../../notifier/schedule.dart';
import '../widgets/listTile/schedule_list_tile.dart';
import '../widgets/button/schedule_add_button.dart';
import '../widgets/view_select_drawer.dart';
import 'login_page.dart';

const String dateTimeformat = "yyyy-MM-dd HH:mm";

class ScheduleListView extends HookConsumerWidget {
  const ScheduleListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LoginStateSelector(
      loggedInWidget: Scaffold(
        drawer: const ViewSelectDrawer(),
        body: CustomScrollView(
          slivers: <Widget>[
            const SliverAppBar(
              title: Text("motivate scheduler"),
            ),
            SliverList(
              delegate:
                  SliverChildBuilderDelegate((BuildContext context, int index) {
                return const ScheduleAddButton();
              }, childCount: 1),
            ),
            const ScheduleList(),
          ],
        ),
      ),
      loggedOutWidget: const LoginPage(),
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
          return ScheduleCard(schedule: schedules[index]);
        },
        childCount: schedules.length,
      ),
    );
  }
}

class ScheduleCard extends HookConsumerWidget {
  final Schedule schedule;

  const ScheduleCard({Key? key, required this.schedule}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: ScheduleListTile(
        schedule: schedule,
      ),
    );
  }
}
