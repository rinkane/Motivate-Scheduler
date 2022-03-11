import 'package:flutter/material.dart';

class ElevatedTextButton extends StatelessWidget {
  final String text;
  final Function() onPressed;
  const ElevatedTextButton(
      {Key? key, required this.text, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: 150,
      child: ElevatedButton(
        child: Text(text),
        onPressed: onPressed,
      ),
    );
  }
}
