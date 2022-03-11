import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:scheduler/notifier/user.dart';

import '../widgets/button/elevated_text_button.dart';
import '../widgets/button/outlined_text_button.dart';
import '../widgets/toast/toast.dart';

class RegistUserPage extends StatefulHookConsumerWidget {
  const RegistUserPage({Key? key}) : super(key: key);

  @override
  _RegistUserPageState createState() => _RegistUserPageState();
}

class _RegistUserPageState extends ConsumerState<RegistUserPage> {
  late FToast toast;

  String email = "";
  String password = "";

  @override
  void initState() {
    super.initState();
    toast = FToast();
    toast.init(context);
  }

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
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedTextButton(
                    text: "登録",
                    onPressed: () async {
                      try {
                        final result = await userNotifier
                            .registerUserWithEmailAndPassword(email, password);
                        final User user = result.user!;
                        toast.showToast(
                          child: AppToast(
                            text: "登録成功:${user.email}",
                            icon: Icons.check_circle,
                          ),
                          gravity: ToastGravity.BOTTOM_RIGHT,
                          toastDuration: const Duration(seconds: 2),
                        );
                        Navigator.of(context).pushNamed("/login");
                      } catch (e) {
                        toast.showToast(
                          child: AppToast(
                            text: "登録失敗:${e.toString()}",
                            icon: Icons.cancel,
                          ),
                          gravity: ToastGravity.BOTTOM_RIGHT,
                          toastDuration: const Duration(seconds: 2),
                        );
                      }
                    },
                  ),
                  const SizedBox(width: 16),
                  OutlinedTextButton(
                    text: "戻る",
                    onPressed: () => Navigator.of(context).pop(),
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
