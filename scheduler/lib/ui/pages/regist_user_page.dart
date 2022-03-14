import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/scheduler.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:scheduler/notifier/login.dart';
import 'package:scheduler/notifier/user.dart';
import 'package:scheduler/ui/widgets/toast/toast.dart';

import '../../utility/exception_message_creator.dart';
import '../widgets/button/elevated_text_button.dart';
import '../widgets/button/outlined_text_button.dart';

class RegistUserPage extends StatefulHookConsumerWidget {
  const RegistUserPage({Key? key}) : super(key: key);

  @override
  _RegistUserPageState createState() => _RegistUserPageState();
}

class _RegistUserPageState extends ConsumerState<RegistUserPage>
    with DisplayToast {
  String email = "";
  String password = "";

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance?.addPostFrameCallback((_) {
      final userState = ref.watch(userProvider);
      if (userState.user != null) {
        Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final userNotifier = ref.watch(userProvider);
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
                        loginPageViewModel.setEmail(email);
                        loginPageViewModel.setPassword(password);
                        DisplayToast.show("登録成功:${user.email}");
                        Navigator.of(context).pushNamed("/home");
                      } on FirebaseAuthException catch (e) {
                        DisplayToast.show(
                            "登録失敗:${ExceptionMessageCreator.createFromFirebaseAuthException(e)}");
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
