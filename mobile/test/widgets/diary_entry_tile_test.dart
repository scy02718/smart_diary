// test/widgets/diary_entry_tile_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/widgets/diary_entry_tile.dart';
import 'package:mobile/models/diary_entry.dart';

void main() {
  testWidgets('DiaryEntryTile displays date and content', (WidgetTester tester) async {
    var entry = DiaryEntry(date: DateTime(2024, 8, 12), content: 'Test content');

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DiaryEntryTile(
            entry: entry,
            onTap: () {},
          ),
        ),
      ),
    );

    expect(find.text('12-8-2024'), findsOneWidget);
    expect(find.text('Test content'), findsOneWidget);
  });

  testWidgets('DiaryEntryTile triggers onTap callback when tapped', (WidgetTester tester) async {
    bool tapped = false;
    var entry = DiaryEntry(date: DateTime(2024, 8, 12), content: 'Test content');

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DiaryEntryTile(
            entry: entry,
            onTap: () {
              tapped = true;
            },
          ),
        ),
      ),
    );

    await tester.tap(find.byType(DiaryEntryTile));
    expect(tapped, true);
  });
}
