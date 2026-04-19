import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_service.dart';
import 'achievement_service.dart';

class StatsModel {
  final int totalFocusTime;
  final int dailyStreak;
  final int longestStreak;
  final int totalPoints;
  final int level;
  final int completedTasks;
  final int completedSessions;

  StatsModel({
    required this.totalFocusTime,
    required this.dailyStreak,
    required this.longestStreak,
    required this.totalPoints,
    required this.level,
    this.completedTasks = 0,
    this.completedSessions = 0,
  });

  factory StatsModel.fromFirestore(Map<String, dynamic> data) {
    return StatsModel(
      totalFocusTime: data['totalFocusTime'] ?? 0,
      dailyStreak: data['dailyStreak'] ?? 0,
      longestStreak: data['longestStreak'] ?? 0,
      totalPoints: data['totalPoints'] ?? 0,
      level: data['level'] ?? 1,
      completedTasks: data['completedTasks'] ?? 0,
      completedSessions: data['completedSessions'] ?? 0,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'totalFocusTime': totalFocusTime,
      'dailyStreak': dailyStreak,
      'longestStreak': longestStreak,
      'totalPoints': totalPoints,
      'level': level,
      'completedTasks': completedTasks,
      'completedSessions': completedSessions,
    };
  }
}

class StatsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Ref _ref;

  StatsService(this._ref);

  String? get _userId => _ref.read(authServiceProvider).currentUser?.uid;

  DocumentReference get _statsDoc => _firestore.collection('stats').doc(_userId);

  Stream<StatsModel> getStats() {
    if (_userId == null) return Stream.value(StatsModel(totalFocusTime: 0, dailyStreak: 0, longestStreak: 0, totalPoints: 0, level: 1));
    
    return _statsDoc.snapshots().map((snapshot) {
      if (!snapshot.exists) return StatsModel(totalFocusTime: 0, dailyStreak: 0, longestStreak: 0, totalPoints: 0, level: 1);
      return StatsModel.fromFirestore(snapshot.data() as Map<String, dynamic>);
    });
  }

  Future<void> updateFocusTime(int additionalSeconds) async {
    if (_userId == null) return;
    
    // 1. Update overall stats
    await _statsDoc.set({
      'totalFocusTime': FieldValue.increment(additionalSeconds),
      'completedSessions': FieldValue.increment(1),
      'totalPoints': FieldValue.increment(additionalSeconds ~/ 60),
    }, SetOptions(merge: true));

    // 2. Trigger Achievement Audit
    final currentStatsSnapshot = await _statsDoc.get();
    if (currentStatsSnapshot.exists) {
      final data = currentStatsSnapshot.data() as Map<String, dynamic>;
      final stats = StatsModel.fromFirestore(data);
      
      await _ref.read(achievementServiceProvider).checkAchievements(
        totalFocusSessions: stats.completedSessions,
        totalFocusMinutes: stats.totalFocusTime ~/ 60,
        currentStreak: stats.dailyStreak,
        completedTasks: stats.completedTasks,
      );
    }

    // 3. Log this specific focus session for the heatmap
    final today = DateTime.now();
    final dateKey = '${today.year}-${today.month}-${today.day}';
    
    await _firestore
        .collection('users')
        .doc(_userId)
        .collection('daily_metrics')
        .doc(dateKey)
        .set({
      'seconds': FieldValue.increment(additionalSeconds),
      'timestamp': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Stream<Map<int, double>> getFocusIntensity() {
    if (_userId == null) return Stream.value({});
    
    return _firestore
        .collection('users')
        .doc(_userId)
        .collection('daily_metrics')
        .limit(30)
        .snapshots()
        .map((snapshot) {
      final Map<int, double> intensity = {};
      // Calculate day index based on timestamp vs now for the heatmap
      final now = DateTime.now();
      
      for (var doc in snapshot.docs) {
        final data = doc.data();
        final timestamp = (data['timestamp'] as Timestamp?)?.toDate();
        if (timestamp != null) {
          final diff = now.difference(timestamp).inDays;
          if (diff < 28) {
            final seconds = data['seconds'] as int? ?? 0;
            // Normalize: 2 hours of focus = 1.0 intensity
            intensity[27 - diff] = (seconds / 7200).clamp(0.0, 1.0);
          }
        }
      }
      return intensity;
    });
  }
}


final statsServiceProvider = Provider((ref) => StatsService(ref));

final statsStreamProvider = StreamProvider<StatsModel>((ref) {
  return ref.watch(statsServiceProvider).getStats();
});

final focusIntensityProvider = StreamProvider<Map<int, double>>((ref) {
  return ref.watch(statsServiceProvider).getFocusIntensity();
});

