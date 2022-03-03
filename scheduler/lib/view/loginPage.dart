import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:scheduler/viewModel/loginPageViewModel.dart';

import '../viewModel/completeScheduleListViewModel.dart';
import 'registUserPage.dart';
import 'scheduleListView.dart';
import '../viewModel/scheduleListViewModel.dart';

const String appName = "Motivate Scheduler";

class LoginPage extends HookConsumerWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheduleListViewModel = ref.watch(scheduleListProvider);
    final completeScheduleListViewModel =
        ref.watch(completeScheduleListProvider);
    final loginPageViewModel = ref.watch(loginPageProvider);
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
                    final User user = result.user!;
                    final isFetch = await scheduleListViewModel
                            .fetchScheduleFromFirestore(user.email) &&
                        await completeScheduleListViewModel
                            .fetchScheduleFromFirestore(user.email);
                    if (isFetch) {
                      loginPageViewModel.infoText = "ログイン成功:${user.email}";
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ScheduleListView(),
                        ),
                      );
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
                onPressed: () async {
                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RegistUserPage(),
                      ));
                },
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
