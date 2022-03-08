import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:scheduler/notifier/user.dart';

class RegistUserPage extends StatefulHookConsumerWidget {
  const RegistUserPage({Key? key}) : super(key: key);

  @override
  _RegistUserPageState createState() => _RegistUserPageState();
}

class _RegistUserPageState extends ConsumerState<RegistUserPage> {
  String email = "";
  String password = "";
  String infoText = "";

  @override
  Widget build(BuildContext context) {
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
                  setState(() {
                    email = input;
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
              const SizedBox(height: 8),
              ElevatedButton(
                child: const Text("登録"),
                onPressed: () async {
                  try {
                    final result = await userNotifier
                        .registerUserWithEmailAndPassword(email, password);
                    final User user = result.user!;
                    setState(() {
                      infoText = "登録成功:${user.email}";
                    });
                    Navigator.of(context).pushNamed("/login");
                  } catch (e) {
                    setState(() {
                      infoText = "登録失敗:${e.toString()}";
                    });
                  }
                },
              ),
              const SizedBox(height: 8),
              Text(infoText),
            ],
          ),
        ),
      ),
    );
  }
}
