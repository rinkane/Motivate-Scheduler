import 'package:flutter/material.dart';

class ConfirmDeleteScheduleDialog extends StatelessWidget {
  final String title;

  const ConfirmDeleteScheduleDialog({Key? key, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      actions: <Widget>[
        SizedBox(
          width: 100,
          height: 60,
          child: TextButton(
            child: const Text("削除"),
            onPressed: () {
              Navigator.pop(context, true);
            },
          ),
        ),
        SizedBox(
          width: 100,
          height: 60,
          child: TextButton(
            child: const Text("キャンセル"),
            onPressed: () {
              Navigator.pop(context, false);
            },
          ),
        ),
      ],
    );
  }
}
