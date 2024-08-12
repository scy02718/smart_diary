// test/screens/month_view_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/screens/month_view.dart';
import 'package:mobile/models/diary_entry.dart';

void main() {
  testWidgets('MonthView displays all weeks in the month', (WidgetTester tester) async {
    var monthEntries = [
      [DiaryEntry(date: DateTime(2024, 8, 12), content: 'Week 1')],
      [DiaryEntry(date: DateTime(2024, 8, 5), content: 'Week 2')],
      [DiaryEntry(date: DateTime(2024, 7, 29), content: 'Week 3')],
      [DiaryEntry(date: DateTime(2024, 7, 22), content: 'Week 4')],
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: MonthView(monthEntries: monthEntries),
      ),
    );

    expect(find.text('Week 1 Summary (To be implemented)'), findsOneWidget);
    expect(find.text('Week 2 Summary (To be implemented)'), findsOneWidget);
    expect(find.text('Week 3 Summary (To be implemented)'), findsOneWidget);
    expect(find.text('Week 4 Summary (To be implemented)'), findsOneWidget);
  });
}
