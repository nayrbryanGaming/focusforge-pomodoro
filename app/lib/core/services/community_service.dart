import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CommunityService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<int> getActiveUsersCount() {
    // Optimized for production: 
    // We only count users active in the last 15 minutes to represent "Active Now"
    // This reduces snapshot size and is more representative of real-time community.
    final fifteenMinutesAgo = DateTime.now().subtract(const Duration(minutes: 15));
    return _firestore
        .collection('users')
        .where('last_active_at', isGreaterThan: fifteenMinutesAgo)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }


  Future<void> updateHeartbeat(String userId) async {
    await _firestore.collection('users').doc(userId).set({
      'last_active_at': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
}

final communityServiceProvider = Provider<CommunityService>((ref) => CommunityService());

final activeUsersCountProvider = StreamProvider<int>((ref) {
  return ref.watch(communityServiceProvider).getActiveUsersCount();
});
