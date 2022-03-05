import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:scheduler/ui/widgets/button/dialog_action_button.dart';

void main() {
  group("Dialog Action Button", () {
    testWidgets('has title', (WidgetTester tester) async {
      int num = 0;
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: DialogActionButton(
              title: "testTitle",
              onPressed: () {
                num++;
              },
            ),
          ),
        ),
      );

      expect(find.text("testTitle"), findsOneWidget);

      await tester.tap(find.byType(TextButton));
      await tester.pump();

      expect(num, 1);
    });

    testWidgets('onPressed is null', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: DialogActionButton(
              title: "testTitle",
              onPressed: null,
            ),
          ),
        ),
      );

      expect(find.text("testTitle"), findsOneWidget);
    });
  });
}
