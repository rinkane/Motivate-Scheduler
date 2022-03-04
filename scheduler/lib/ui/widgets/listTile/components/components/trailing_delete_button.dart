import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ListTileTrailingDeleteButton extends HookConsumerWidget {
  final Function deleteSchedule;

  const ListTileTrailingDeleteButton({Key? key, required this.deleteSchedule})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      icon: const Icon(Icons.delete),
      onPressed: () => deleteSchedule(),
    );
  }
}
