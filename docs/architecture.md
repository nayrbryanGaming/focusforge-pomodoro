# FocusForge Technical Architecture

FocusForge is built with a **Feature-First Clean Architecture** approach, ensuring separation of concerns, high testability, and a premium reactive user experience.

## 1. Core Architecture Principles

FocusForge follows the **Domain-Driven Design (DDD)** principles within a **Clean Architecture** shell:

- **Persistence**: `shared_preferences` for non-sensitive local settings (durations, theme, haptics).
- **Security**: Custom Firebase Security Rules protecting user-specific data paths using UID-scoping.
- **Analytics**: `firebase_analytics` for tracking critical user journey milestones (Onboarding, Session success).
- **Hardening**: `firebase_crashlytics` integration for real-time error reporting.

## 2. User Journey & Feature Milestones

### v1.0 — Launch (Completed)
- [x] Pomodoro timer with customization
- [x] Task management with CRUD
- [x] Firebase sync (Auth/Firestore)
- [x] Achievement badges system

### v2.0 — Ultimate Polish (Completed)
- [x] Immersive Concentration Mode
- [x] Custom Timer Heartbeat Pulse
- [x] Task session history & details screen

### v3.0 — Elite UX (Completed)
- [x] Dynamic animated theme transitions linked to timer state.
- [x] "Live Forge" active user counts simulating global presence.
- [x] High-performance confetti celebrations.

### v4.0 — Production Hardening
- [x] **Permission Priming**: Beautiful UI sequence for notification and alarm permissions to improve user opt-in rates.
- [x] **Data Transparency**: In-app "Export Data" (JSON) to comply with global privacy standards (GDPR/CCPA).
- [x] **Advanced Achievements**: Glassmorphic milestone gallery with progress tracking.
- [x] **Haptic Engineering**: Adjustable feedback intensity for tactile focus pulses.

## 3. Tech Stack Summary

| Layer | Component | Implementation |
|---|---|---|
| **Frontend** | Framework | Flutter 3.x (Stable) |
| **State Management** | Provider | Riverpod 2.x |
| **Backend** | Auth/Database | Google Firebase (Auth + Firestore) |
| **Local Storage** | Cache | SharedPreferences |
| **Charts** | Analytics | `fl_chart`, `firebase_analytics`, `firebase_crashlytics` |
| **Animations** | Motion | `animate_do`, `flutter_animate`, `confetti` |

## 4. Data Flow (Reactive Pattern)

1.  **User Trigger**: User taps "Start Timer" in `TimerScreen`.
2.  **Notifier Action**: `TimerNotifier` (Riverpod) updates the `TimerState`.
3.  **Analytics**: `AnalyticsService` logs the session start event.
4.  **Service Interaction**: When the timer completes, `TimerNotifier` calls `StatsService.updateFocusTime()`.
5.  **Sensory Feedback**: `ConfettiService` triggers celebration graphics and `HapticService` provides tactile feedback.
6.  **Firebase Sync**: `StatsService` pushes the update to **Cloud Firestore**.

## 5. Directory Structure (Feature-First)

```
lib/
├── core/
│   ├── constants/      # AppColors, AppConstants
│   ├── theme/          # Material 3 dynamic themes
│   ├── services/       # Firebase & Global Services (Auth, Stats, Tasks, Notification, Alarm, Analytics, Achievement, Confetti, Community)
│   └── utils/          # Helper utilities
├── features/
│   ├── auth/           # Login, Register, Guest flow
│   ├── onboarding/     # Intro value propositions + Permission Priming
│   ├── timer/          # Pomodoro Engine + Custom Painter
│   ├── tasks/          # Advanced Task Management
│   ├── stats/          # Analytics & fl_chart integration
│   ├── achievements/   # Glassmorphic Badge Gallery
│   └── profile/        # User Settings, Data Export & Legal
├── models/             # Domain Entities
└── providers/          # Global Riverpod Notifiers
```

## 6. Security & Compliance

- **Firestore Rules**: Strict server-side rules ensure users only access their own UID-prefixed data.
- **Account Deletion Flow**: Complete app adherence to GDPR/CCPA standards with rigorous "Right to be Forgotten" cascading deletes and re-authentication.
- **Data Export**: Full JSON export feature provides transparency and satisfies "Right to Access" requirements.

---

*This architecture is designed for Google Play Store elite production standards (2026).*
