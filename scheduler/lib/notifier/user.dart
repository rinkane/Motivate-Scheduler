import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final userProvider = ChangeNotifierProvider((_) => UserNotifier());

class UserNotifier extends ChangeNotifier {
  User? user;
  bool isLoadState = false;

  UserNotifier() {
    final subscribe = FirebaseAuth.instance.authStateChanges();
    subscribe.forEach((user) {
      this.user = user;
      print(user?.email);
      isLoadState = true;
      notifyListeners();
    });
  }

  Future<UserCredential> signInWithEmailAndPassword(
      String email, String password) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    return await auth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  Future<UserCredential> registerUserWithEmailAndPassword(
      String email, String password) async {
    final id = FirebaseFirestore.instance.collection('users').doc().id;
    final FirebaseAuth auth = FirebaseAuth.instance;
    final result = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    if (result.user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(id)
          .set({'mail': email});
    }
    return result;
  }
}
