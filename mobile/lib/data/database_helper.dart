import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/diary_entry.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    try {
      String path = join(await getDatabasesPath(), 'smart_diary.db');
      return await openDatabase(
        path,
        version: 1,
        onCreate: _onCreate,
      );
    } catch (e) {
      print("Error initializing database: $e");
      rethrow;  // Re-throw the error after logging it
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE diary_entries(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT,
        content TEXT,
        summary TEXT,
        sentiment TEXT,
        future_events TEXT,
        tags TEXT
      )
    ''');
  }

  Future<int> insertDiaryEntry(DiaryEntry entry) async {
    final db = await database;
    return await db.insert('diary_entries', entry.toMap());
  }

  Future<List<DiaryEntry>> getDiaryEntries() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('diary_entries');
    return List.generate(maps.length, (i) {
      return DiaryEntry.fromMap(maps[i]);
    });
  }

  Future<int> updateDiaryEntry(DiaryEntry entry) async {
    final db = await database;
    return await db.update(
      'diary_entries',
      entry.toMap(),
      where: 'id = ?',
      whereArgs: [entry.id],
    );
  }

  Future<void> deleteDiaryEntry(int id) async {
    final db = await database;
    await db.delete(
      'diary_entries',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
