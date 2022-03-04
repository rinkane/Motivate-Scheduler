import 'package:flutter/material.dart';
import 'package:scheduler/ui/widgets/button/dialog_action_button.dart';

import '../widgets/text/dialog_title_text.dart';

class ConfirmDeleteScheduleDialog extends StatelessWidget {
  final String title;

  const ConfirmDeleteScheduleDialog({Key? key, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: DialogTitleText(
        ellipsisText: title,
        text: "を削除しますか？",
      ),
      actions: <Widget>[
        DialogActionButton(
          title: "削除",
          onPressed: () => Navigator.pop(context, true),
        ),
        DialogActionButton(
          title: "キャンセル",
          onPressed: () => Navigator.pop(context, false),
        ),
      ],
    );
  }
}
