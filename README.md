# FocusForge

### Forge Deep Focus. Build Unstoppable Productivity.
[Live Demo Landing Page](https://focusforge-pomodoro.vercel.app/) • [Download APK](https://github.com/nayrbryanGaming/focusforge-pomodoro/releases)

---

## 1. One-liner
FocusForge is a premium, 100% offline-first Pomodoro habit system engineered for high-stakes concentration and verifiable productivity.

## 2. Problem
Modern knowledge work is plagued by digital friction and "connected distractions." Most productivity apps require cloud sync, introducing latency, privacy risks, and the temptation to switch apps. Existing tools lack the depth of analytics and gamification required to build long-term neuroplastic focus habits.

## 3. Solution
FocusForge eliminates the noise by operating in total isolation. It combines a high-precision Pomodoro engine with a robust local task manager and deep-history analytics. By removing all cloud dependencies, FocusForge ensures zero-latency performance and absolute data sovereignty, allowing users to "forge" focus in a secure, local environment.

## 4. Why FocusForge?
- **Zero-Trust Privacy**: Your data never leaves your device. No cloud transmission, no tracking.
- **Scientific Intervals**: Precision-tuned sessions (25/5/15) based on the Pomodoro Technique.
- **Deep Analytics**: Visualize your productivity "heat" through locally generated charts and streak tracking.
- **Gamified Mastery**: Earn XP and badges as you master your time, transforming discipline into a rewarding game.

## 5. Architecture
FocusForge follows **Clean Architecture** patterns:
- **Presentation**: Flutter + Riverpod for reactive, stable state management.
- **Domain**: Pure business logic decoupled from any framework.
- **Data**: High-performance persistence using local SQLite (`sqflite`).
- **Safety**: Robust error boundaries and haptic-backed user feedback.

## 6. What's Built
- [x] **Precision Timer**: Customizable focus/break cycles with background persistence.
- [x] **Task Engine**: Integrated task management with Pomodoro estimation.
- [x] **Productivity Vault**: Advanced local statistics and session history.
- [x] **Hardened UI**: Premium dark-mode interface with high-contrast accessibility.
- [x] **Bilingual Core**: Full localization support for English and Bahasa Indonesia.

## 7. Team
Developed by the **FocusForge Engineering Group**.

## 8. Quick Start
```bash
# Clone the repository
git clone https://github.com/nayrbryanGaming/focusforge-pomodoro.git

# Move to app directory
cd app && flutter pub get

# Run the app
flutter run --release
```

---
© 2026 FocusForge Protocol. All Rights Reserved.
