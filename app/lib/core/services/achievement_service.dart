import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_service.dart';

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

  factory AchievementModel.fromFirestore(Map<String, dynamic> data, String id) {
    return AchievementModel(
      id: id,
      title: data['title'] ?? 'Achievement',
      description: data['description'] ?? 'Work towards this milestone',
      icon: data['icon'] ?? '🏆',
      isUnlocked: data['isUnlocked'] ?? false,
      progress: (data['progress'] ?? 0.0).toDouble(),
      targetValue: (data['targetValue'] ?? 1.0).toDouble(),
    );
  }
}

class AchievementService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Ref _ref;

  AchievementService(this._ref);

  String? get _userId => _ref.read(authServiceProvider).currentUser?.uid;

  CollectionReference get _achievementsCollection {
    if (_userId == null) throw Exception('User not logged in');
    return _firestore.collection('users').doc(_userId).collection('achievements');
  }

  Stream<List<AchievementModel>> getAchievements() {
    if (_userId == null) return Stream.value([]);
    
    return _achievementsCollection.snapshots().map((snapshot) => snapshot.docs
        .map((doc) => AchievementModel.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
        .toList());
  }

  Future<void> checkAchievements({
    required int totalFocusSessions,
    required int totalFocusMinutes,
    required int currentStreak,
    required int completedTasks,
    bool isNightOwlSession = false,
  }) async {
    if (_userId == null) return;

    final batch = _firestore.batch();
    bool hasChanges = false;

    // 1. Focus Apprentice (1st Session)
    if (totalFocusSessions >= 1) {
      _prepareUnlock(batch, 'focus_apprentice', 'Focus Apprentice', 'Complete your first focus session to ignite the productivity flame.', '🔥');
      hasChanges = true;
    }

    // 2. Focused Novice (100 Minutes)
    if (totalFocusMinutes >= 100) {
      _prepareUnlock(batch, 'focused_novice', 'Focused Novice', 'Successfully logged your first 100 minutes of deep focus.', '📜');
      hasChanges = true;
    }

    // 3. Deep Work Master (1000 Minutes)
    if (totalFocusMinutes >= 1000) {
      _prepareUnlock(batch, 'deep_work_master', 'Deep Work Master', 'Legendary! You have logged over 1000 minutes of deep focus.', '💎');
      hasChanges = true;
    }

    // 4. Consistency King (7 Day Streak)
    if (currentStreak >= 7) {
      _prepareUnlock(batch, 'consistency_king', 'Consistency King', 'Maintained a focus streak for 7 days. You are unstoppable.', '👑');
      hasChanges = true;
    }

    // 5. Task Crusher (50 Tasks)
    if (completedTasks >= 50) {
      _prepareUnlock(batch, 'task_crusher', 'Task Crusher', 'Successfully crushed 50 productivity tasks in the Forge.', '🔨');
      hasChanges = true;
    }

    // 6. Night Owl Forger
    if (isNightOwlSession) {
      _prepareUnlock(batch, 'night_owl', 'Night Owl Forger', 'Completed a focus session in the dead of night.', '🦉');
      hasChanges = true;
    }

    // 7. Efficiency Elite (5 tasks in one day)
    if (completedTasks >= 5) { // Needs better daily tracking logic but for now simple check
       _prepareUnlock(batch, 'efficiency_elite', 'Efficiency Elite', 'Maximum output achieved in a single day.', '⚡');
       hasChanges = true;
    }

    if (hasChanges) {
      await batch.commit();
    }
  }

  void _prepareUnlock(WriteBatch batch, String id, String title, String desc, String icon) {
    batch.set(_achievementsCollection.doc(id), {
      'title': title,
      'description': desc,
      'icon': icon,
      'isUnlocked': true,
      'progress': 1.0,
      'unlockedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
}

final achievementServiceProvider = Provider((ref) => AchievementService(ref));

final achievementsStreamProvider = StreamProvider<List<AchievementModel>>((ref) {
  return ref.watch(achievementServiceProvider).getAchievements();
});
