import '../../models/diary_entry.dart';
import '../database_helper.dart';

class DiaryRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<int> addDiaryEntry(DiaryEntry entry) {
    return _dbHelper.insertDiaryEntry(entry);
  }

  Future<List<DiaryEntry>> getAllEntries() {
    return _dbHelper.getDiaryEntries();
  }

  Future<int> updateDiaryEntry(DiaryEntry entry) {
    return _dbHelper.updateDiaryEntry(entry);
  }

  Future<void> deleteDiaryEntry(int id) {
    return _dbHelper.deleteDiaryEntry(id);
  }
}
