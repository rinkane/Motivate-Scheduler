import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:scheduler/notifier/user.dart';

class LoginStateSelector extends HookConsumerWidget {
  final Widget loggedInWidget;
  final Widget loggedOutWidget;
  const LoginStateSelector(
      {Key? key, required this.loggedInWidget, required this.loggedOutWidget})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userProvider);
    if (userState.user == null) {
      return loggedOutWidget;
    } else {
      return loggedInWidget;
    }
  }
}
