import 'package:flutter/material.dart';

import 'scheduleListView.dart';

class ViewSelectDrawer extends StatelessWidget {
  const ViewSelectDrawer({Key? key}) : super(key: key);

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
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ScheduleListView(),
                  ));
            },
            child: const ListTile(
              leading: Icon(Icons.schedule),
              title: Text("Schedules"),
            ),
          ),
        ],
      ),
    );
  }
}
