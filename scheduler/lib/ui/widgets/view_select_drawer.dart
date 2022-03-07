import 'package:flutter/material.dart';

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
        ],
      ),
    );
  }
}
