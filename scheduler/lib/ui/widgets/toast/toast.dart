import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AppToast extends StatelessWidget {
  final String text;
  final IconData? icon;
  const AppToast({
    Key? key,
    required this.text,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 18, 12, 18),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4), color: Colors.black87),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(
            icon,
            color: Colors.white,
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}

mixin DisplayToast {
  static Future<bool?> show(String msg) {
    return Fluttertoast.showToast(
      msg: msg,
      gravity: ToastGravity.BOTTOM_RIGHT,
      webBgColor: "#222222",
      textColor: Colors.white,
    );
  }
}
