import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum TaskCategory { work, study, personal, other }
enum TaskPriority { low, medium, high }

class TaskModel {
  final String id;
  final String title;
  final int estimatedPomodoros;
  final int completedPomodoros;
  final bool isCompleted;
  final DateTime createdAt;
  final TaskCategory category;
  final TaskPriority priority;

  TaskModel({
    String? id,
    required this.title,
    this.estimatedPomodoros = 1,
    this.completedPomodoros = 0,
    this.isCompleted = false,
    DateTime? createdAt,
    this.category = TaskCategory.work,
    this.priority = TaskPriority.medium,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now();

  TaskModel copyWith({
    String? id,
    String? title,
    int? estimatedPomodoros,
    int? completedPomodoros,
    bool? isCompleted,
    DateTime? createdAt,
    TaskCategory? category,
    TaskPriority? priority,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      estimatedPomodoros: estimatedPomodoros ?? this.estimatedPomodoros,
      completedPomodoros: completedPomodoros ?? this.completedPomodoros,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      category: category ?? this.category,
      priority: priority ?? this.priority,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'estimatedPomodoros': estimatedPomodoros,
      'completedPomodoros': completedPomodoros,
      'completed': isCompleted,
      'createdAt': Timestamp.fromDate(createdAt),
      'category': category.name,
      'priority': priority.name,
    };
  }

  factory TaskModel.fromFirestore(Map<String, dynamic> map, String id) {
    return TaskModel(
      id: id,
      title: map['title'] ?? '',
      estimatedPomodoros: map['estimatedPomodoros'] ?? 1,
      completedPomodoros: map['completedPomodoros'] ?? 0,
      isCompleted: map['completed'] ?? false,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      category: TaskCategory.values.firstWhere(
        (e) => e.name == map['category'],
        orElse: () => TaskCategory.work,
      ),
      priority: TaskPriority.values.firstWhere(
        (e) => e.name == map['priority'],
        orElse: () => TaskPriority.medium,
      ),
    );
  }
}
