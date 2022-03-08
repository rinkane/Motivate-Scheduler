import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:scheduler/ui/widgets/button/schedule_add_button.dart';

void main() {
  group("Schedule Add Button", () {
    testWidgets("add icon", (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: ScheduleAddButton(),
          ),
        ),
      );

      expect(find.byIcon(Icons.add), findsOneWidget);
    });
  });
}
