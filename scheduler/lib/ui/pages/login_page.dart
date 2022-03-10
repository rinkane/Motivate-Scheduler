import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:scheduler/notifier/user.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:scheduler/ui/pages/schedule_list_page.dart';

import '../../notifier/login.dart';
import '../../notifier/complete_schedule.dart';
import '../../notifier/schedule.dart';

const String appName = "Motivate Scheduler";

class LoginPage extends StatefulHookConsumerWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends ConsumerState<LoginPage> {
  late FToast toast;

  @override
  void initState() {
    super.initState();
    toast = FToast();
    toast.init(context);
  }

  @override
  Widget build(BuildContext context) {
    final scheduleListViewModel = ref.read(scheduleListProvider.notifier);
    final completeScheduleListViewModel =
        ref.read(completeScheduleListProvider.notifier);
    final loginPageViewModel = ref.watch(loginPageProvider);
    final userNotifier = ref.watch(userProvider);
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
                    final UserCredential result =
                        await userNotifier.signInWithEmailAndPassword(
                            loginPageViewModel.email,
                            loginPageViewModel.password);
                    final isFetch = await scheduleListViewModel
                            .fetchSchedule(loginPageViewModel.email) &&
                        await completeScheduleListViewModel
                            .fetchSchedule(loginPageViewModel.email);

                    if (result.user != null && isFetch) {
                      toast.showToast(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            children: const <Widget>[
                              Icon(Icons.check_circle),
                              Text("ログイン成功"),
                            ],
                          ),
                        ),
                        gravity: ToastGravity.BOTTOM_RIGHT,
                        toastDuration: const Duration(seconds: 2),
                      );
                      Navigator.of(context).pushNamed("/home");
                    } else {
                      throw Exception("スケジュールデータを取得できませんでした。");
                    }
                  } catch (e) {
                    String msg = "ログイン失敗:${e.toString()}";
                    toast.showToast(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          children: <Widget>[
                            const Icon(Icons.check_circle),
                            Text(msg),
                          ],
                        ),
                      ),
                      gravity: ToastGravity.BOTTOM_RIGHT,
                      toastDuration: const Duration(seconds: 2),
                    );
                  }
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                child: const Text("ユーザ登録"),
                onPressed: () => Navigator.of(context).pushNamed("/register"),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
