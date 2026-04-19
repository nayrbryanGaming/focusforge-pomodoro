import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_service.dart';
import '../../models/task_model.dart';

class TaskService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Ref _ref;

  TaskService(this._ref);

  String? get _userId => _ref.read(authServiceProvider).currentUser?.uid;

  CollectionReference get _tasksCollection => _firestore.collection('tasks');

  Stream<List<TaskModel>> getTasks() {
    if (_userId == null) return Stream.value([]);
    
    return _tasksCollection
        .where('userId', isEqualTo: _userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => TaskModel.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
            .toList());
  }

  Future<void> addTask(TaskModel task) async {
    if (_userId == null) return;
    await _tasksCollection.add(task.toFirestore()..['userId'] = _userId);
  }

  Future<void> updateTask(TaskModel task) async {
    await _tasksCollection.doc(task.id).update(task.toFirestore());
  }

  Future<void> deleteTask(String taskId) async {
    await _tasksCollection.doc(taskId).delete();
  }

  Future<void> toggleTaskCompletion(String taskId, bool isCompleted) async {
    await _tasksCollection.doc(taskId).update({'completed': isCompleted});
    
    // Update stats count
    if (_userId != null) {
      await _firestore.collection('stats').doc(_userId).set({
        'completedTasks': FieldValue.increment(isCompleted ? 1 : -1),
      }, SetOptions(merge: true));
    }
  }
}

final taskServiceProvider = Provider((ref) => TaskService(ref));

final tasksStreamProvider = StreamProvider<List<TaskModel>>((ref) {
  return ref.watch(taskServiceProvider).getTasks();
});
