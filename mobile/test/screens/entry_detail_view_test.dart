// test/screens/entry_detail_view_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/screens/entry_detail_view.dart';
import 'package:mobile/models/diary_entry.dart';

void main() {
  testWidgets('EntryDetailView displays and updates content', (WidgetTester tester) async {
    var entry = DiaryEntry(date: DateTime(2024, 8, 12), content: 'Original content');

    await tester.pumpWidget(
      MaterialApp(
        home: EntryDetailView(entry: entry),
      ),
    );

    expect(find.text('Original content'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'Updated content');
    await tester.tap(find.byIcon(Icons.save));
    await tester.pumpAndSettle();

    expect(entry.content, 'Updated content');
  });
}
