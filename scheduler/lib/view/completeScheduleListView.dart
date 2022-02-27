import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewModel/completeScheduleListViewModel.dart';
import 'viewSelectDrawer.dart';

class CompleteScheduleListView extends StatelessWidget {
  const CompleteScheduleListView({Key? key}) : super(key: key);
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

class CompleteScheduleList extends StatelessWidget {
  const CompleteScheduleList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scheduleListViewModel =
        Provider.of<CompleteScheduleListViewModel>(context);
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

class CompleteScheduleCard extends StatelessWidget {
  final int index;

  const CompleteScheduleCard({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scheduleListViewModel =
        Provider.of<CompleteScheduleListViewModel>(context);
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
            Container(
              child: Text(
                schedule.getDurationText(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
