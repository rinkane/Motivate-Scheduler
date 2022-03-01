// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:scheduler/main.dart';
import 'package:scheduler/view/scheduleListView.dart';
import 'package:scheduler/viewModel/scheduleListViewModel.dart';

Widget createScheduleListView() =>
    ChangeNotifierProvider<ScheduleListViewModel>(
        create: (context) => ScheduleListViewModel(),
        child: MaterialApp(
          home: ScheduleListView(),
        ));

void main() {
  group("Schedule List View Tests", () {
    testWidgets('Testing if SliverList shows up', (WidgetTester tester) async {
      await tester.pumpWidget(createScheduleListView());
      expect(find.byType(SliverList), findsOneWidget);
    });
  });
}
