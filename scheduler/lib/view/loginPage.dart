import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'registUserPage.dart';
import 'scheduleListView.dart';
import '../viewModel/scheduleListViewModel.dart';

const String appName = "Motivate Scheduler";

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String mailAddress = "";
  String password = "";
  String infoText = "";

  @override
  Widget build(BuildContext context) {
    final scheduleListViewModel = Provider.of<ScheduleListViewModel>(context);
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
                  setState(() {
                    mailAddress = input;
                  });
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Password",
                ),
                obscureText: true,
                onChanged: (String input) {
                  setState(() {
                    password = input;
                  });
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
                            email: mailAddress, password: password);
                    final User user = result.user!;
                    final isFetch = await scheduleListViewModel
                        .fetchScheduleFromFirestore(user.email);
                    if (isFetch) {
                      setState(() {
                        infoText = "ログイン成功:${user.email}";
                      });
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
                    setState(() {
                      infoText = "ログイン失敗:${e.toString()}";
                    });
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
              Text(infoText),
            ],
          ),
        ),
      ),
    );
  }
}
