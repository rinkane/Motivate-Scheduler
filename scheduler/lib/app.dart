import 'package:flutter/material.dart';
import 'package:scheduler/ui/dialogs/schedule_setting_dialog.dart';
import 'package:scheduler/ui/widgets/slider/labeled_slider.dart';

import 'ui/pages/login_page.dart';

const String appName = "Motivate Scheduler";

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appName,
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      //home: const LoginPage(),
      home: ScheduleSettingDialog(initialMethod: ScheduleSettingMethod.add),
    );
  }
}
