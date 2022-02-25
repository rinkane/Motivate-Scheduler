import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegistUserPage extends StatefulWidget {
  const RegistUserPage({Key? key}) : super(key: key);

  @override
  State<RegistUserPage> createState() => _RegistUserPageState();
}

class _RegistUserPageState extends State<RegistUserPage> {
  String mailAddress = "";
  String password = "";
  String infoText = "";

  @override
  Widget build(BuildContext context) {
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
              const SizedBox(height: 8),
              ElevatedButton(
                child: const Text("登録"),
                onPressed: () async {
                  try {
                    final FirebaseAuth auth = FirebaseAuth.instance;
                    final UserCredential result =
                        await auth.createUserWithEmailAndPassword(
                      email: mailAddress,
                      password: password,
                    );
                    final User user = result.user!;
                    setState(() {
                      infoText = "登録成功:${user.email}";
                    });
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc()
                        .set({'mail': mailAddress, 'password': password});
                    Navigator.pop(context);
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
