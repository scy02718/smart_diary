// test/models/diary_entry_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/models/diary_entry.dart';

void main() {
  group('DiaryEntry', () {
    test('should initialize with provided date and empty content', () {
      final entry = DiaryEntry(date: DateTime(2024, 8, 12));

      expect(entry.date, DateTime(2024, 8, 12));
      expect(entry.content, '');
    });

    test('should update content', () {
      final entry = DiaryEntry(date: DateTime(2024, 8, 12));
      entry.content = 'New content';

      expect(entry.content, 'New content');
    });
  });
}
