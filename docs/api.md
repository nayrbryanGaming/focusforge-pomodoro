# FocusForge API & Services

## Overview
FocusForge uses the Firebase SDK as its primary backend. This document outlines the core service methods and data schemas.

## Services

### AuthService
- `signInAnonymously()`: Standard entry for guests.
- `signIn(email, password)`: Link anonymous account to email.
- `signOut()`: Terminates session.
- `deleteAccount()`: Purges user data and deletes auth record.

### TaskService
- `getTasks()`: Stream of `List<TaskModel>`.
- `addTask(TaskModel)`: Adds a new task to Firestore.
- `updateTask(TaskModel)`: Modifies existing task.
- `deleteTask(id)`: Removes task record.

### StatsService
- `getStats()`: Stream of `StatsModel`.
- `updateFocusTime(seconds)`: Increments focus time and triggers level updates.
- `getFocusIntensity()`: Fetches 28-day activity heatmap data.

## Firestore Schemas

### /tasks/{id}
```json
{
  "userId": "string",
  "title": "string",
  "estimatedPomodoros": "int",
  "completedPomodoros": "int",
  "category": "string",
  "priority": "string",
  "isCompleted": "bool",
  "createdAt": "timestamp"
}
```

### /stats/{userId}
```json
{
  "totalFocusTime": "int",
  "totalPoints": "int",
  "level": "int",
  "dailyStreak": "int",
  "completedSessions": "int"
}
```

## Security
- All read/write operations are protected by Firestore Security Rules.
- Field-level validation ensures data integrity.
- Firebase Crashlytics monitors API failures in production.
