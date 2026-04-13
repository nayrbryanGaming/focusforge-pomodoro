import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> purgeUserData(String userId) async {
    final batch = _firestore.batch();

    // 1. Delete user document
    batch.delete(_firestore.collection('users').doc(userId));

    // 2. Delete stats document
    batch.delete(_firestore.collection('stats').doc(userId));

    // 3. Delete tasks (Simple way: query and delete, but limited by batch size)
    // For a production app with many tasks, we'd use a Cloud Function or Extension.
    // Here we'll do a basic cleanup for standard usage.
    final tasks = await _firestore
        .collection('tasks')
        .where('userId', isEqualTo: userId)
        .get();
    for (var doc in tasks.docs) {
      batch.delete(doc.reference);
    }

    // 4. Delete sessions
    final sessions = await _firestore
        .collection('sessions')
        .where('userId', isEqualTo: userId)
        .get();
    for (var doc in sessions.docs) {
      batch.delete(doc.reference);
    }

    await batch.commit();
  }
}

final firestoreService = FirestoreService();
