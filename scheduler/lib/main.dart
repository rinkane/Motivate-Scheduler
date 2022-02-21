import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'model/schedule.dart';
import 'view/addScheduleDialog.dart';

const String appName = "Motivate Scheduler";

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appName,
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: const MyHomePage(title: appName),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var schedules = <Schedule>[Schedule()];

  void showAddScheduleDialog() async {
    final schedule = await showDialog<Schedule>(
        context: context, builder: (context) => const AddScheduleDialog());
    if (schedule != null) {
      setState(() {
        schedules.add(schedule);
      });
    }
  }

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
                  subtitle: Text(DateFormat("yyyy-MM-dd HH:mm")
                          .format(schedules[index].startDateTime) +
                      " ~ " +
                      DateFormat("yyyy-MM-dd HH:mm")
                          .format(schedules[index].endDateTime)),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        schedules.removeAt(index);
                      });
                    },
                  ),
                ),
              );
            }, childCount: schedules.length),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showAddScheduleDialog,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
