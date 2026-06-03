import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';
import 'database_service.dart';

class AchievementModel {
  final String id;
  final String title;
  final String description;
  final String icon;
  final bool isUnlocked;
  final double progress;
  final double targetValue;

  AchievementModel({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    this.isUnlocked = false,
    this.progress = 0.0,
    this.targetValue = 1.0,
  });

  factory AchievementModel.fromMap(Map<String, dynamic> data) {
    return AchievementModel(
      id: data['id'],
      title: data['title'] ?? 'Achievement',
      description: data['description'] ?? 'Work towards this milestone',
      icon: data['icon'] ?? '🏆',
      isUnlocked: (data['is_unlocked'] ?? 0) == 1,
      progress: (data['progress'] ?? 0.0).toDouble(),
      targetValue: (data['targetValue'] ?? 1.0).toDouble(),
    );
  }
}

class AchievementService {
  AchievementService();

  Future<List<AchievementModel>> getAchievements() async {
    final db = await databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query('achievements');
    return maps.map((map) => AchievementModel.fromMap(map)).toList();
  }

  Future<void> checkAchievements({
    required int totalFocusSessions,
    required int totalFocusMinutes,
    required int currentStreak,
    required int completedTasks,
    bool isNightOwlSession = false,
  }) async {
    final db = await databaseService.database;

    // 1. Focus Apprentice (1st Session)
    if (totalFocusSessions >= 1) {
      await _unlock(db, 'focus_apprentice', 'achievement_focus_apprentice_title', 'achievement_focus_apprentice_desc', '🔥');
    }

    // 2. Focused Novice (100 Minutes)
    if (totalFocusMinutes >= 100) {
      await _unlock(db, 'focused_novice', 'achievement_focused_novice_title', 'achievement_focused_novice_desc', '📜');
    }

    // 3. Deep Work Master (1000 Minutes)
    if (totalFocusMinutes >= 1000) {
      await _unlock(db, 'deep_work_master', 'achievement_deep_work_master_title', 'achievement_deep_work_master_desc', '💎');
    }

    // 4. Consistency King (7 Day Streak)
    if (currentStreak >= 7) {
      await _unlock(db, 'consistency_king', 'achievement_consistency_king_title', 'achievement_consistency_king_desc', '👑');
    }

    // 5. Task Crusher (50 Tasks)
    if (completedTasks >= 50) {
      await _unlock(db, 'task_crusher', 'achievement_task_crusher_title', 'achievement_task_crusher_desc', '🔨');
    }

    // 6. Night Owl Forger
    if (isNightOwlSession) {
      await _unlock(db, 'night_owl', 'achievement_night_owl_title', 'achievement_night_owl_desc', '🦉');
    }

    // 7. Efficiency Elite (5 tasks in one day)
    if (completedTasks >= 5) {
       await _unlock(db, 'efficiency_elite', 'achievement_efficiency_elite_title', 'achievement_efficiency_elite_desc', '⚡');
    }
  }

  Future<void> _unlock(dynamic db, String id, String title, String desc, String icon) async {
    await db.insert('achievements', {
      'id': id,
      'title': title,
      'description': desc,
      'icon': icon,
      'is_unlocked': 1,
      'progress': 1.0,
      'unlocked_at': DateTime.now().toIso8601String(),
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }
}

final achievementServiceProvider = Provider((ref) => AchievementService());

final achievementsFutureProvider = FutureProvider<List<AchievementModel>>((ref) async {
  return await ref.watch(achievementServiceProvider).getAchievements();
});
