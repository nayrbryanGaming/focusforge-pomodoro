# FocusForge Firebase API Definitions

## Collections

### 1. `users`
**Path**: `/users/{user_id}`
*   `email` (string)
*   `display_name` (string)
*   `created_at` (timestamp)
*   `premium_status` (boolean)
*   `total_points` (number)

### 2. `tasks`
**Path**: `/tasks/{task_id}`
*   `user_id` (string)
*   `title` (string)
*   `estimated_pomodoros` (number)
*   `completed_pomodoros` (number)
*   `completed` (boolean)
*   `created_at` (timestamp)

### 3. `sessions`
**Path**: `/sessions/{session_id}`
*   `user_id` (string)
*   `task_id` (string, optional)
*   `duration` (number, seconds)
*   `type` (string: "focus", "short_break", "long_break")
*   `completed` (boolean)
*   `timestamp` (timestamp)

### 4. `stats`
**Path**: `/stats/{user_id}`
*   `total_focus_time` (number, seconds)
*   `daily_streak` (number)
*   `longest_streak` (number)
*   `weekly_focus_hours` (map<string, number> - e.g., "YYYY-MM-DD" : hours)
*   `level` (number)

## Service Interfaces (Dart)

```dart
abstract class TaskRepository {
  Future<List<Task>> getTasks(String userId);
  Future<void> addTask(Task task);
  Future<void> updateTask(Task task);
  Future<void> deleteTask(String taskId);
}

abstract class SessionRepository {
  Future<void> saveSession(Session session);
  Future<List<Session>> getRecentSessions(String userId);
}
```
