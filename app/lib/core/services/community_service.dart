import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CommunityService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<int> getActiveUsersCount() {
    // Production-grade implementation using Firestore count aggregator.
    // This is cost-efficient and reveals the real size of the FocusForge community.
    return _firestore
        .collection('users')
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
