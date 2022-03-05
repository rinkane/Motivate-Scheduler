import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final userProvider = ChangeNotifierProvider((_) => UserNotifier());

class UserNotifier extends ChangeNotifier {
  User? user;
  bool isLoadState = false;

  UserNotifier() {
    final unsubscribe = FirebaseAuth.instance.authStateChanges();
    unsubscribe.forEach((user) {
      this.user = user;
      print(user?.email);
      isLoadState = true;
      notifyListeners();
    });
  }
}
