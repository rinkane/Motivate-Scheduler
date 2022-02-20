import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
  String testText = "test";
  void showAddScheduleDialog() async {
    final schedule = await showDialog<String>(
        context: context,
        builder: (context) =>
            AddScheduleDialog(initialMotivation: 0.0, initialScheduleName: ""));
    if (schedule != null) {
      setState(() {
        testText = schedule;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(slivers: [
        SliverAppBar(title: Text("Motivate-Scheduler")),
        SliverList(delegate: SliverChildListDelegate([Text(testText)]))
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: showAddScheduleDialog,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class AddScheduleDialog extends StatefulWidget {
  final String initialScheduleName;
  final double initialMotivation;

  const AddScheduleDialog(
      {Key? key,
      required this.initialScheduleName,
      required this.initialMotivation})
      : super(key: key);

  @override
  AddScheduleDialogState createState() => AddScheduleDialogState();
}

class AddScheduleDialogState extends State<AddScheduleDialog> {
  late String scheduleName;
  late double motivation;

  @override
  void initState() {
    super.initState();
    scheduleName = widget.initialScheduleName;
    motivation = widget.initialMotivation;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: Text("スケジュールの追加"),
        content: Column(children: <Widget>[
          TextField(
              decoration: InputDecoration(hintText: "追加したい予定"),
              onChanged: changeTextField),
          Slider(
            value: motivation,
            max: 100,
            min: -100,
            onChanged: changeSlider,
          )
        ]),
        actions: <Widget>[
          ElevatedButton(
              child: Text("追加"),
              onPressed: () {
                Navigator.pop(context, scheduleName);
              }),
          ElevatedButton(
              child: Text("キャンセル"),
              onPressed: () {
                Navigator.pop(context);
              })
        ]);
  }

  void changeSlider(double value) {
    setState(() {
      motivation = value.roundToDouble();
    });
  }

  void changeTextField(String value) {
    setState(() {
      scheduleName = value;
    });
  }
}
