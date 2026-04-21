# FocusForge API & Database Structure

FocusForge uses the Firebase SDK for all backend interactions.

## Firestore Collections

### `users`
| Field | Type | Description |
|-------|------|-------------|
| `user_id` | String | Unique identifier (Firebase UID) |
| `email` | String | User's email |
| `created_at` | Timestamp | Account creation date |
| `premium_status` | Boolean | Subscription status |

### `tasks`
| Field | Type | Description |
|-------|------|-------------|
| `task_id` | String | Unique task ID |
| `user_id` | String | Owner ID |
| `title` | String | Task description |
| `completed` | Boolean | Completion status |
| `created_at` | Timestamp | Creation date |

### `sessions`
| Field | Type | Description |
|-------|------|-------------|
| `session_id` | String | Unique session ID |
| `user_id` | String | User ID |
| `task_id` | String? | Associated task (optional) |
| `duration` | Int | Seconds spent |
| `type` | String | 'focus' or 'break' |
| `completed` | Boolean | Finished vs. Interrupted |
| `timestamp` | Timestamp | Session start time |

### `stats`
| Field | Type | Description |
|-------|------|-------------|
| `user_id` | String | User ID |
| `total_focus_time` | Int | Total cumulative focus seconds |
| `daily_streak` | Int | Consecutive focus days |
| `weekly_focus_hours` | List<Double> | Focus duration for the last 7 days |

## Core Services (Dart)
- `AuthService`: Handles sign-in, sign-up, and anonymous sessions.
- `TaskService`: CRUD operations for tasks.
- `TimerService`: Core logic for countdown and state transitions.
- `StatsService`: Real-time analytics aggregation.
