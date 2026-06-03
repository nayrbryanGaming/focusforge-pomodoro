import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'database_service.dart';
import '../../models/task_model.dart';
import 'package:sqflite/sqflite.dart';

class TaskService {
  final DatabaseService _dbService = databaseService;

  Future<List<TaskModel>> getTasks() async {
    final db = await _dbService.database;
    final List<Map<String, dynamic>> maps = await db.query('tasks', orderBy: 'created_at DESC');
    return List.generate(maps.length, (i) => TaskModel.fromMap(maps[i]));
  }

  Future<void> addTask(TaskModel task) async {
    final db = await _dbService.database;
    await db.insert(
      'tasks',
      task.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateTask(TaskModel task) async {
    final db = await _dbService.database;
    await db.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<void> deleteTask(String taskId) async {
    final db = await _dbService.database;
    await db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [taskId],
    );
  }

  Future<void> toggleTaskCompletion(String taskId, bool isCompleted) async {
    final db = await _dbService.database;
    await db.update(
      'tasks',
      {'is_completed': isCompleted ? 1 : 0},
      where: 'id = ?',
      whereArgs: [taskId],
    );
    
    // Update daily stats locally
    final today = DateTime.now().toIso8601String().split('T')[0];
    await db.rawUpdate('''
      INSERT INTO stats (date, tasks_completed) 
      VALUES (?, ?) 
      ON CONFLICT(date) DO UPDATE SET tasks_completed = tasks_completed + ?
    ''', [today, isCompleted ? 1 : 0, isCompleted ? 1 : -1]);
  }
}

final taskServiceProvider = Provider((ref) => TaskService());

final tasksProvider = FutureProvider<List<TaskModel>>((ref) {
  return ref.watch(taskServiceProvider).getTasks();
});
