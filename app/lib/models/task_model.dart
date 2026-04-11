import 'package:uuid/uuid.dart';

class Task {
  final String id;
  final String title;
  final int estimatedPomodoros;
  final int completedPomodoros;
  final bool isCompleted;
  final DateTime createdAt;

  Task({
    String? id,
    required this.title,
    this.estimatedPomodoros = 1,
    this.completedPomodoros = 0,
    this.isCompleted = false,
    DateTime? createdAt,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now();

  Task copyWith({
    String? id,
    String? title,
    int? estimatedPomodoros,
    int? completedPomodoros,
    bool? isCompleted,
    DateTime? createdAt,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      estimatedPomodoros: estimatedPomodoros ?? this.estimatedPomodoros,
      completedPomodoros: completedPomodoros ?? this.completedPomodoros,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // Simplified to Map for Local/Firebase usage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'estimatedPomodoros': estimatedPomodoros,
      'completedPomodoros': completedPomodoros,
      'isCompleted': isCompleted,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      estimatedPomodoros: map['estimatedPomodoros'],
      completedPomodoros: map['completedPomodoros'],
      isCompleted: map['isCompleted'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}
