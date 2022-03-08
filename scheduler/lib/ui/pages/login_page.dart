import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:scheduler/notifier/user.dart';

import '../../notifier/login.dart';
import '../../notifier/complete_schedule.dart';
import '../../notifier/schedule.dart';

const String appName = "Motivate Scheduler";

class LoginPage extends HookConsumerWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheduleListViewModel = ref.read(scheduleListProvider.notifier);
    final completeScheduleListViewModel =
        ref.read(completeScheduleListProvider.notifier);
    final loginPageViewModel = ref.watch(loginPageProvider);
    final userState = ref.watch(userProvider);
    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(32),
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "MailAddress",
                ),
                onChanged: (String input) {
                  loginPageViewModel.setEmail(input);
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Password",
                ),
                obscureText: true,
                onChanged: (String input) {
                  loginPageViewModel.setPassword(input);
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                child: const Text("ログイン"),
                onPressed: () async {
                  try {
                    final FirebaseAuth auth = FirebaseAuth.instance;
                    final UserCredential result =
                        await auth.signInWithEmailAndPassword(
                            email: loginPageViewModel.email,
                            password: loginPageViewModel.password);

                    final isFetch = await scheduleListViewModel
                            .fetchSchedule(loginPageViewModel.email) &&
                        await completeScheduleListViewModel
                            .fetchSchedule(loginPageViewModel.email);

                    if (result.user != null) {
                      loginPageViewModel.infoText =
                          "ログイン成功:${loginPageViewModel.email}";
                      Navigator.of(context).pushNamed("/home");
                    } else {
                      throw Exception("スケジュールデータを取得できませんでした。");
                    }
                  } catch (e) {
                    loginPageViewModel.infoText = "ログイン失敗:${e.toString()}";
                  }
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                child: const Text("ユーザ登録"),
                onPressed: () => Navigator.of(context).pushNamed("/register"),
              ),
              const SizedBox(height: 16),
              Text(loginPageViewModel.infoText),
            ],
          ),
        ),
      ),
    );
  }
}
