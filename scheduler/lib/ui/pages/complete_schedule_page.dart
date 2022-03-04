import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../notifier/complete_schedule.dart';
import '../widgets/listTile/schedule_completed_list_tile.dart';
import '../widgets/view_select_drawer.dart';

class CompleteScheduleView extends StatelessWidget {
  const CompleteScheduleView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      drawer: ViewSelectDrawer(),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            title: Text("Motivate Scheduler"),
          ),
          CompleteScheduleList(),
        ],
      ),
    );
  }
}

class CompleteScheduleList extends HookConsumerWidget {
  const CompleteScheduleList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final completeSchedules = ref.watch(completeScheduleListProvider);
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return CompleteScheduleCard(index: index);
        },
        childCount: completeSchedules.length,
      ),
    );
  }
}

class CompleteScheduleCard extends HookConsumerWidget {
  final int index;

  const CompleteScheduleCard({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: ScheduleCompletedListTile(
        index: index,
      ),
    );
  }
}
