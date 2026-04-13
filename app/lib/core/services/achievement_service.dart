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

  Future<void> checkAchievements(int totalFocusTime, int streak) async {
    if (_userId == null) return;

    // Logic to unlock achievements based on stats
    // Example: "Focus Novice" - 1 hour of focus
    if (totalFocusTime >= 3600) {
      await _unlockAchievement('focus_novice');
    }
    // "Streak Starter" - 3 days streak
    if (streak >= 3) {
      await _unlockAchievement('streak_starter');
    }
  }

  Future<void> _unlockAchievement(String achievementId) async {
    await _achievementsCollection.doc(achievementId).set({
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
