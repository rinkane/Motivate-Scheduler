import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../viewModel/complete_schedule.dart';
import 'view_select_drawer.dart';

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
    final scheduleListViewModel = ref.watch(completeScheduleListProvider);
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return CompleteScheduleCard(index: index);
        },
        childCount: scheduleListViewModel.completeSchedules.length,
      ),
    );
  }
}

class CompleteScheduleCard extends HookConsumerWidget {
  final int index;

  const CompleteScheduleCard({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheduleListViewModel = ref.watch(completeScheduleListProvider);
    final schedule = scheduleListViewModel.completeSchedules[index];
    return Card(
      child: ListTile(
        title: Text(schedule.name),
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              width: 30,
              child: Text(schedule.motivation.toString()),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              schedule.getDurationText(),
            ),
          ],
        ),
      ),
    );
  }
}
