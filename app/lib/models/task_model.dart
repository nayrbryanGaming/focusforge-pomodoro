import 'package:uuid/uuid.dart';

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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'estimated_pomodoros': estimatedPomodoros,
      'completed_pomodoros': completedPomodoros,
      'is_completed': isCompleted ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
      'category': category.name,
      'priority': priority.name,
    };
  }

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'],
      title: map['title'] ?? '',
      estimatedPomodoros: map['estimated_pomodoros'] ?? 1,
      completedPomodoros: map['completed_pomodoros'] ?? 0,
      isCompleted: (map['is_completed'] ?? 0) == 1,
      createdAt: DateTime.parse(map['created_at']),
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
