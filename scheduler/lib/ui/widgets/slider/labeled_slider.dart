import 'package:flutter/material.dart';

class LabeledSlider extends StatefulWidget {
  final int value;
  final String label;

  const LabeledSlider({Key? key, required this.value, required this.label})
      : super(key: key);

  @override
  LabeledSliderState createState() => LabeledSliderState();
}

class LabeledSliderState extends State<LabeledSlider> {
  late int value;
  late String label;

  @override
  void initState() {
    super.initState();

    value = widget.value;
    label = widget.label;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(0, 28, 0, 0),
          alignment: Alignment.centerLeft,
          child: Text(label),
        ),
        Container(
          width: 450,
          margin: const EdgeInsets.fromLTRB(0, 30, 50, 0),
          alignment: Alignment.center,
          child: Slider(
            value: value.toDouble(),
            max: 100,
            min: -100,
            onChanged: changeSlider,
          ),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(0, 30, 20, 0),
          alignment: Alignment.centerRight,
          child: Text(value.toString()),
        ),
      ],
      /*
        Stack(
          children: <Widget>[
            Container(
              height: 60,
              margin: const EdgeInsets.fromLTRB(0, 28, 0, 0),
              alignment: Alignment.centerLeft,
              child: Text(label),
            ),
            Container(
              height: 60,
              margin: const EdgeInsets.fromLTRB(0, 30, 50, 0),
              alignment: Alignment.center,
              child: Slider(
                value: value.toDouble(),
                max: 100,
                min: -100,
                onChanged: changeSlider,
              ),
            ),
            Container(
              height: 60,
              margin: const EdgeInsets.fromLTRB(0, 30, 20, 0),
              alignment: Alignment.centerRight,
              child: Text(value.toString()),
            ),
          ],
        ),
        */
    );
  }

  void changeSlider(double value) {
    setState(() {
      this.value = value.toInt();
    });
  }
}
