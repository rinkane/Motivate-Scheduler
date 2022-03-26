import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:scheduler/notifier/user.dart';
import 'package:scheduler/ui/widgets/toast/toast.dart';

import '../../notifier/login.dart';
import '../../notifier/complete_schedule.dart';
import '../../notifier/schedule.dart';
import '../../utility/exception_message_creator.dart';
import '../widgets/button/elevated_text_button.dart';
import '../widgets/button/outlined_text_button.dart';

const String appName = "Motivate Scheduler";

class LoginPage extends StatefulHookConsumerWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends ConsumerState<LoginPage> with DisplayToast {
  @override
  void initState() {
    super.initState();
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
                initialValue: loginPageViewModel.email,
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
                initialValue: loginPageViewModel.password,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedTextButton(
                    text: "ログイン",
                    onPressed: () async {
                      try {
                        final UserCredential result =
                            await userNotifier.signInWithEmailAndPassword(
                                loginPageViewModel.email,
                                loginPageViewModel.password);
                        if (result.user == null) {
                          DisplayToast.show("ユーザを取得できませんでした");
                          return;
                        }
                        final isFetch = await scheduleListViewModel
                                .fetchSchedule(result.user) &&
                            await completeScheduleListViewModel
                                .fetchSchedule(result.user);
                        if (isFetch) {
                          DisplayToast.show("ログイン成功");
                        } else {
                          DisplayToast.show("スケジュールデータを取得できませんでした。");
                        }
                      } on FirebaseAuthException catch (e) {
                        String msg =
                            "ログイン失敗:${ExceptionMessageCreator.createFromFirebaseAuthException(e)}";
                        DisplayToast.show(msg);
                        return;
                      }
                    },
                  ),
                  const SizedBox(width: 16),
                  OutlinedTextButton(
                    text: "ユーザ登録",
                    onPressed: () =>
                        Navigator.of(context).pushNamed("/register"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
