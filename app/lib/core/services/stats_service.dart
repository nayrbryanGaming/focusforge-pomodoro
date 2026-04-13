import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_service.dart';

class StatsModel {
  final int totalFocusTime;
  final int dailyStreak;
  final int longestStreak;
  final int totalPoints;
  final int level;

  StatsModel({
    required this.totalFocusTime,
    required this.dailyStreak,
    required this.longestStreak,
    required this.totalPoints,
    required this.level,
  });

  factory StatsModel.fromFirestore(Map<String, dynamic> data) {
    return StatsModel(
      totalFocusTime: data['totalFocusTime'] ?? 0,
      dailyStreak: data['dailyStreak'] ?? 0,
      longestStreak: data['longestStreak'] ?? 0,
      totalPoints: data['totalPoints'] ?? 0,
      level: data['level'] ?? 1,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'totalFocusTime': totalFocusTime,
      'dailyStreak': dailyStreak,
      'longestStreak': longestStreak,
      'totalPoints': totalPoints,
      'level': level,
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
    await _statsDoc.set({
      'totalFocusTime': FieldValue.increment(additionalSeconds),
      'totalPoints': FieldValue.increment(additionalSeconds ~/ 60), // 1 point per minute
    }, SetOptions(merge: true));
  }
}

final statsServiceProvider = Provider((ref) => StatsService(ref));

final statsStreamProvider = StreamProvider<StatsModel>((ref) {
  return ref.watch(statsServiceProvider).getStats();
});
