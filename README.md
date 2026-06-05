# FocusForge

> **Forge Deep Focus. Build Unstoppable Productivity.** — A 100% offline Pomodoro timer with task tracking, analytics, and gamification. [Download APK](https://github.com/nayrbryanGaming/focusforge-pomodoro/releases)

## Problem

Most people struggle with digital distractions, procrastination, and burnout caused by unstructured work sessions. Existing Pomodoro apps are overly simple, visually outdated, and missing habit-forming analytics or gamification.

## Solution

FocusForge is a modern focus habit system that combines Pomodoro sessions, task management, productivity analytics, and gamification into a single premium mobile experience — all working 100% offline with zero cloud dependency.

## Why

- **No login. No account. No data sent anywhere.** All data lives locally on your device.
- Structured sessions build real deep-work habits.
- Gamified rewards keep users motivated long-term.
- Clean, modern dark UI reduces cognitive load during focus.

## Architecture

- **Frontend**: Flutter (stable) + Dart + Riverpod state management + Material 3
- **Storage**: 100% Offline — SQLite via sqflite (no Firebase, no internet required)
- **Pattern**: Clean Architecture — Presentation / Domain / Data layers + MVVM + Repository
- **Notifications**: Local notifications only (flutter_local_notifications)
- **State**: Riverpod Notifier + StateNotifier providers

## What's Built

| Feature | Status |
|---|---|
| Pomodoro Timer (focus / short break / long break) | ✅ Complete |
| Concentration Mode (fullscreen, distraction-free) | ✅ Complete |
| Task Management (create, edit, delete, filter by category) | ✅ Complete |
| Pomodoro-to-Task Assignment | ✅ Complete |
| Productivity Analytics (heatmap, weekly bar chart, metrics) | ✅ Complete |
| Gamification (XP points, forge level, streak tracking) | ✅ Complete |
| Achievements System | ✅ Complete |
| Settings (timer durations, audio, haptic, power saving) | ✅ Complete |
| Bilingual UI (English / Bahasa Indonesia) | ✅ Complete |
| Onboarding Flow + Permission Priming | ✅ Complete |
| Privacy Policy, Terms of Service, Data Usage Policy | ✅ Complete |
| Dark Theme with dynamic color per timer mode | ✅ Complete |

## Team

Built by the **nayrbryanGaming / Forge Team** — believers in deep work, extreme focus, and digital wellness.

## Quick Start

```bash
git clone https://github.com/nayrbryanGaming/focusforge-pomodoro.git
cd focusforge-pomodoro/app
flutter pub get
flutter run
```

> **Note**: No Firebase setup required. The app is fully offline. Test on a physical Android device for best results.
