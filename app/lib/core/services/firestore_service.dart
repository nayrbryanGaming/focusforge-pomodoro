import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> purgeUserData(String userId) async {
    // 1. Delete user & stats documents
    await _firestore.collection('users').doc(userId).delete();
    await _firestore.collection('stats').doc(userId).delete();

    // 2. Delete tasks and sessions safely in chunks to avoid 500 limit
    await _deleteCollectionSafely('tasks', userId);
    await _deleteCollectionSafely('sessions', userId);
  }

  Future<void> _deleteCollectionSafely(String collection, String userId) async {
    var snapshot = await _firestore.collection(collection).where('userId', isEqualTo: userId).get();
    var batches = <WriteBatch>[];
    
    var currentBatch = _firestore.batch();
    var operationCount = 0;

    for (var doc in snapshot.docs) {
      currentBatch.delete(doc.reference);
      operationCount++;
      
      if (operationCount >= 400) {
        batches.add(currentBatch);
        currentBatch = _firestore.batch();
        operationCount = 0;
      }
    }
    
    if (operationCount > 0) {
      batches.add(currentBatch);
    }

    for (var batch in batches) {
      await batch.commit();
    }
  }
}


final firestoreService = FirestoreService();
