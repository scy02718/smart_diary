// test/screens/week_view_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/screens/week_view.dart';
import 'package:mobile/models/diary_entry.dart';

void main() {
  testWidgets('WeekView displays all days in the week', (WidgetTester tester) async {
    var weekEntries = [
      DiaryEntry(date: DateTime(2024, 8, 12), content: 'Day 1'),
      DiaryEntry(date: DateTime(2024, 8, 11), content: 'Day 2'),
      DiaryEntry(date: DateTime(2024, 8, 10), content: 'Day 3'),
      DiaryEntry(date: DateTime(2024, 8, 9), content: 'Day 4'),
      DiaryEntry(date: DateTime(2024, 8, 8), content: 'Day 5'),
      DiaryEntry(date: DateTime(2024, 8, 7), content: 'Day 6'),
      DiaryEntry(date: DateTime(2024, 8, 6), content: 'Day 7'),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: WeekView(weekEntries: weekEntries),
      ),
    );

    for (var entry in weekEntries) {
      expect(find.text(entry.content), findsOneWidget);
    }
  });
}
