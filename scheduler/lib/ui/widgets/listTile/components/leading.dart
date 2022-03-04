import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../model/schedule.dart';
import 'components/leading_motivation.dart';

class ListTileLeading extends HookConsumerWidget {
  final Schedule schedule;

  const ListTileLeading({Key? key, required this.schedule}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        ListTileLeadingMotivation(schedule: schedule),
      ],
    );
  }
}
