import 'package:flutter/material.dart';

class DialogActionButton extends StatelessWidget {
  final String title;
  final Function? onPressed;

  const DialogActionButton({Key? key, required this.title, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 60,
      child: TextButton(
        child: Text(title),
        onPressed: onPressed != null ? () => onPressed!() : null,
      ),
    );
  }
}
