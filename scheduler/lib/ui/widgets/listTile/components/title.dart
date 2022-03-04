import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../model/schedule.dart';
import 'components/title_name.dart';

class ListTileTitle extends HookConsumerWidget {
  final Schedule schedule;

  const ListTileTitle({Key? key, required this.schedule}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTileTitleName(
      schedule: schedule,
    );
  }
}
