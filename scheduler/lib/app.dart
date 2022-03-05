import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:scheduler/notifier/complete_schedule.dart';
import 'package:scheduler/notifier/schedule.dart';
import 'package:scheduler/notifier/user.dart';
import 'package:scheduler/ui/pages/complete_schedule_page.dart';
import 'package:scheduler/ui/pages/login_check.dart';
import 'package:scheduler/ui/pages/regist_user_page.dart';
import 'package:scheduler/ui/widgets/motivation_graph.dart';
import 'ui/pages/login_page.dart';
import 'ui/pages/schedule_list_page.dart';

const String appName = "Motivate Scheduler";

class MyApp extends HookConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
        title: appName,
        theme: ThemeData(
          primarySwatch: Colors.purple,
        ),
        home: const LoginCheckPage(),
        initialRoute: '/',
        routes: <String, WidgetBuilder>{
          '/login': (context) => const LoginPage(),
          '/register': (context) => const RegistUserPage(),
          '/home': (context) => const ScheduleListView(),
          '/motivation': (context) => const MotivationGraphView(),
          '/complete': (context) => const CompleteScheduleView(),
        });
  }
}
