import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'focusforge.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Tasks Table
    await db.execute('''
      CREATE TABLE tasks (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        estimated_pomodoros INTEGER DEFAULT 1,
        completed_pomodoros INTEGER DEFAULT 0,
        is_completed INTEGER DEFAULT 0,
        category TEXT DEFAULT 'work',
        priority TEXT DEFAULT 'medium',
        created_at TEXT NOT NULL
      )
    ''');

    // Sessions Table
    await db.execute('''
      CREATE TABLE sessions (
        id TEXT PRIMARY KEY,
        task_id TEXT,
        duration_seconds INTEGER NOT NULL,
        type TEXT NOT NULL,
        is_completed INTEGER DEFAULT 0,
        timestamp TEXT NOT NULL,
        FOREIGN KEY (task_id) REFERENCES tasks (id) ON DELETE SET NULL
      )
    ''');

    // Stats Table (Daily aggregation)
    await db.execute('''
      CREATE TABLE stats (
        date TEXT PRIMARY KEY,
        total_focus_seconds INTEGER DEFAULT 0,
        tasks_completed INTEGER DEFAULT 0,
        pomodoros_completed INTEGER DEFAULT 0
      )
    ''');

    // Achievements Table
    await db.execute('''
      CREATE TABLE achievements (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        unlocked_at TEXT
      )
    ''');
  }

  Future<void> clearAllData() async {
    final db = await database;
    await db.transaction((txn) async {
      await txn.execute('DROP TABLE IF EXISTS tasks');
      await txn.execute('DROP TABLE IF EXISTS sessions');
      await txn.execute('DROP TABLE IF EXISTS stats');
      await txn.execute('DROP TABLE IF EXISTS achievements');
      await _onCreate(db, 1);
    });
  }

  Future<void> close() async {
    final db = await database;
    db.close();
  }
}

final databaseService = DatabaseService();
