import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final loginPageProvider = ChangeNotifierProvider((_) => LoginPageViewModel());

class LoginPageViewModel extends ChangeNotifier {
  String _email = "";
  String get email => _email;

  String _password = "";
  String get password => _password;

  String infoText = "";

  void setEmail(String email) {
    _email = email;
    notifyListeners();
  }

  void setPassword(String password) {
    _password = password;
    notifyListeners();
  }
}
