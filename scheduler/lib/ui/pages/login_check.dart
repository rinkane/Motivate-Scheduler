import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../notifier/complete_schedule.dart';
import '../../notifier/schedule.dart';

class LoginCheckPage extends StatefulHookConsumerWidget {
  const LoginCheckPage({Key? key}) : super(key: key);

  @override
  LoginCheckState createState() => LoginCheckState();
}

class LoginCheckState extends ConsumerState<LoginCheckPage> {
  final subscribe = FirebaseAuth.instance.authStateChanges();

  @override
  void initState() {
    super.initState();
    navigate();
  }

  Future<void> navigate() async {
    await subscribe.forEach((user) {
      if (user != null) {
        final scheduleListViewModel = ref.watch(scheduleListProvider.notifier);
        final completeScheduleListViewModel =
            ref.watch(completeScheduleListProvider.notifier);
        final scheduleState = ref.watch(scheduleListProvider);
        final completeScheduleState = ref.watch(completeScheduleListProvider);
        if (scheduleState.schedules.isEmpty) {
          scheduleListViewModel.fetchSchedule(user.email);
        }
        if (completeScheduleState.schedules.isEmpty) {
          completeScheduleListViewModel.fetchSchedule(user.email);
        }
        Navigator.of(context).pushReplacementNamed("/home");
      } else {
        Navigator.of(context).pushReplacementNamed("/login");
      }
      // HACK: ログインチェック画面を抜けた後もログイン状態が変わると購読されてしまうので無理矢理防いでいる
    }).whenComplete(() => subscribe.forEach((_) {}));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Loading..."),
      ),
    );
  }
}
