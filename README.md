# FocusForge
> Forge Deep Focus. Build Unstoppable Productivity.

[Live Demo](https://focusforge.example.com)

## Problem
Many people struggle with digital distractions, procrastination, lack of time management systems, and burnout due to unstructured work. Existing Pomodoro apps are often overly simple, visually outdated, missing analytics and habit tracking, or lacking gamification.

## Solution
FocusForge combines a Pomodoro timer, task management, productivity analytics, and gamification into a modern mobile experience that helps users build consistent deep work habits. It acts as a comprehensive focus habit system.

## Why
FocusForge is not just a timer. It creates a powerful productivity loop by integrating Pomodoro sessions with task management, stats analytics, and a gamified progress/focus streak tracking system.

## Architecture
- **Frontend Stack**: Flutter (stable), Dart, Riverpod state management, Material 3 UI.
- **Backend Stack**: 100% Offline (SQLite / Local Storage) per legal agreement.
- **Architecture Pattern**: Clean Architecture (Presentation, Domain, Data).
- **Design Pattern**: MVVM + Repository pattern.

## What's Built
- **Pomodoro Timer**: Customizable durations (default 25m focus / 5m break).
- **Task Management**: Create tasks, assign sessions, mark complete.
- **Productivity Analytics**: Daily focus time, weekly graph, session history.
- **Gamification**: Focus streaks, productivity points, achievement badges.
- **User Profiles**: Productivity statistics, focus history.

## Team
- Developed by nayrbryanGaming.

## Quick Start
```bash
git clone https://github.com/nayrbryanGaming/focusforge-pomodoro.git
cd focusforge-pomodoro/app
flutter pub get
flutter run
```
