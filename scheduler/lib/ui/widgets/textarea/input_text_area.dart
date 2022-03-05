import 'package:flutter/material.dart';

class TextInputField extends StatefulWidget {
  final String text;
  final String hintText;
  final double width;
  final double fontSize;

  const TextInputField(
      {Key? key,
      required this.text,
      this.hintText = "",
      this.width = 400,
      this.fontSize = 16})
      : super(key: key);

  @override
  TextInputFieldState createState() => TextInputFieldState();
}

class TextInputFieldState extends State<TextInputField> {
  late String text;
  late String hintText;
  late double width;
  late double fontSize;

  @override
  void initState() {
    super.initState();

    text = widget.text;
    hintText = widget.hintText;
    width = widget.width;
    fontSize = widget.fontSize;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: TextFormField(
        initialValue: text,
        style: TextStyle(fontSize: fontSize),
        decoration: InputDecoration(hintText: hintText),
        onChanged: (String s) {
          changeTextField(s);
        },
      ),
    );
  }

  void changeTextField(String value) {
    setState(() {
      text = value;
    });
  }
}
