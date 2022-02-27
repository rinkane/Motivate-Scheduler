import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';

import 'firebase_options.dart';
import '_view/scheduleListView.dart';
import '_viewModel/scheduleListViewModel.dart';

const String appName = "Motivate Scheduler";

void main() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.web);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ScheduleListViewModel(),
      child: MaterialApp(
        title: appName,
        theme: ThemeData(
          primarySwatch: Colors.purple,
        ),
        home: const ScheduleListView(),
      ),
    );
  }
}
