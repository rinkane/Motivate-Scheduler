import 'package:flutter/material.dart';
import '../model/schedule.dart';
import '../model/schedulesArguments.dart';

class ViewSelectDrawer extends StatefulWidget {
  const ViewSelectDrawer({Key? key, required this.schedules}) : super(key: key);

  final List<Schedule> schedules;

  @override
  State<ViewSelectDrawer> createState() => _ViewSelectDrawerState();
}

class _ViewSelectDrawerState extends State<ViewSelectDrawer> {
  late List<Schedule> schedules = <Schedule>[];

  @override
  void initState() {
    super.initState();

    schedules = widget.schedules;
  }

  @override
  Widget build(BuildContext context) {
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
            child: const ListTile(
              leading: Icon(Icons.schedule),
              title: Text("Schedules"),
            ),
            onPressed: () => Navigator.of(context).pushNamed(
              "/home",
              arguments: SchedulesArguments(schedules),
            ),
          ),
          TextButton(
            child: const ListTile(
              leading: Icon(Icons.auto_graph),
              title: Text("Motivation"),
            ),
            onPressed: () => Navigator.of(context).pushNamed(
              "/motivation",
              arguments: SchedulesArguments(schedules),
            ),
          ),
        ],
      ),
    );
  }
}
