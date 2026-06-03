import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'database_service.dart';

class UserStats {
  final int totalFocusSeconds;
  final int totalPoints;
  final int dailyStreak;
  final int level;
  final int completedTasks;
  final int completedSessions;

  UserStats({
    this.totalFocusSeconds = 0,
    this.totalPoints = 0,
    this.dailyStreak = 0,
    this.level = 1,
    this.completedTasks = 0,
    this.completedSessions = 0,
  });
}

class DailyStats {
  final String date;
  final int totalFocusSeconds;
  final int tasksCompleted;
  final int pomodorosCompleted;

  DailyStats({
    required this.date,
    this.totalFocusSeconds = 0,
    this.tasksCompleted = 0,
    this.pomodorosCompleted = 0,
  });

  factory DailyStats.fromMap(Map<String, dynamic> map) {
    return DailyStats(
      date: map['date'],
      totalFocusSeconds: map['total_focus_seconds'] ?? 0,
      tasksCompleted: map['tasks_completed'] ?? 0,
      pomodorosCompleted: map['pomodoros_completed'] ?? 0,
    );
  }
}

class StatsService {
  final DatabaseService _dbService = databaseService;

  Future<UserStats> getAggregateStats() async {
    final db = await _dbService.database;
    
    final List<Map<String, dynamic>> totalResult = await db.rawQuery('SELECT SUM(total_focus_seconds) as focus, SUM(tasks_completed) as tasks, SUM(pomodoros_completed) as sessions FROM stats');
    
    final int totalSeconds = totalResult.first['focus'] ?? 0;
    final int totalTasks = totalResult.first['tasks'] ?? 0;
    final int totalSessions = totalResult.first['sessions'] ?? 0;
    
    // Professional-grade leveling and points logic
    // Formula: (Minutes Focused * 2) + (Tasks Completed * 25) + (Sessions Completed * 5)
    final int totalPoints = (totalSeconds ~/ 30) + (totalTasks * 25) + (totalSessions * 5);
    final int level = (totalPoints ~/ 500) + 1;
    
    // Streak logic (simplified: check how many consecutive days have stats > 0)
    final List<Map<String, dynamic>> streakResults = await db.query('stats', orderBy: 'date DESC', columns: ['date', 'total_focus_seconds']);
    int streak = 0;
    DateTime checkDate = DateTime.now();
    
    for (var row in streakResults) {
      final date = DateTime.parse(row['date']);
      if (date.year == checkDate.year && date.month == checkDate.month && date.day == checkDate.day) {
        if ((row['total_focus_seconds'] ?? 0) > 0) {
          streak++;
          checkDate = checkDate.subtract(const Duration(days: 1));
        } else {
          break;
        }
      } else if (date.isBefore(checkDate)) {
        break;
      }
    }

    return UserStats(
      totalFocusSeconds: totalSeconds,
      totalPoints: totalPoints,
      dailyStreak: streak,
      level: level,
      completedTasks: totalTasks,
      completedSessions: totalSessions,
    );
  }

  Future<Map<int, double>> getIntensityMap() async {
    final db = await _dbService.database;
    final last28Days = DateTime.now().subtract(const Duration(days: 28)).toIso8601String().split('T')[0];
    
    final List<Map<String, dynamic>> results = await db.query(
      'stats',
      where: 'date >= ?',
      whereArgs: [last28Days],
      orderBy: 'date ASC',
    );
    
    final Map<int, double> intensity = {};
    final now = DateTime.now();
    
    for (var m in results) {
      final date = DateTime.parse(m['date']);
      final diff = now.difference(date).inDays;
      if (diff < 28) {
        final seconds = m['total_focus_seconds'] as int? ?? 0;
        // 2 hours = 1.0 intensity
        intensity[27 - diff] = (seconds / 7200).clamp(0.0, 1.0);
      }
    }
    return intensity;
  }

  Future<void> recordFocusSession(int durationSeconds) async {
    final db = await _dbService.database;
    final today = DateTime.now().toIso8601String().split('T')[0];
    
    await db.rawInsert('''
      INSERT INTO stats (date, total_focus_seconds, pomodoros_completed) 
      VALUES (?, ?, 1) 
      ON CONFLICT(date) DO UPDATE SET 
        total_focus_seconds = total_focus_seconds + ?,
        pomodoros_completed = pomodoros_completed + 1
    ''', [today, durationSeconds, durationSeconds]);
  }

  Future<int> getTotalFocusTime() async {
    final db = await _dbService.database;
    final List<Map<String, dynamic>> result = await db.rawQuery('SELECT SUM(total_focus_seconds) as total FROM stats');
    return result.first['total'] ?? 0;
  }
}

final statsServiceProvider = Provider((ref) => StatsService());

final aggregateStatsProvider = FutureProvider<UserStats>((ref) {
  return ref.watch(statsServiceProvider).getAggregateStats();
});

final intensityMapProvider = FutureProvider<Map<int, double>>((ref) {
  return ref.watch(statsServiceProvider).getIntensityMap();
});

final todayStatsProvider = FutureProvider<DailyStats>((ref) async {
  final db = await databaseService.database;
  final today = DateTime.now().toIso8601String().split('T')[0];
  final List<Map<String, dynamic>> results = await db.query(
    'stats',
    where: 'date = ?',
    whereArgs: [today],
  );
  if (results.isEmpty) {
    return DailyStats(date: today);
  }
  return DailyStats.fromMap(results.first);
});
