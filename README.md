# FocusForge: The Deep Work Infrastructure

[![FocusForge v1.3.1](https://img.shields.io/badge/FocusForge-v1.3.1--Hardened-orange?style=for-the-badge)](https://focusforge.app)
[![Submission 18](https://img.shields.io/badge/Google%20Play-18th%20Submission-blue?style=for-the-badge)](https://play.google.com/store/apps/details?id=com.focusforge.pomodoro)

> **Forge Deep Focus. Build Unstoppable Productivity.**

FocusForge is a clinical-grade Pomodoro productivity application engineered for builders, founders, and absolute focus athletes. Built with Flutter and Firebase, it transmutes distractibility into a structured system of deep work, habit formation, and high-performance analytics.

---

## 🛠 Problem: The Cognitive Fragmentation
Modern workers face a dual crisis:
1.  **Digital Hyper-Distraction**: Constant pings erode the ability to enter "Flow State."
2.  **Unstructured Entropy**: Without a system, work expands to fill available time (Parkinson’s Law), leading to burnout.

Existing tools are either too simplistic (basic timers) or visually outdated, failing to leverage Pavlovian triggers and neurological reward cycles.

## ⚔️ Solution: The Forge Protocol
FocusForge is not just a timer; it is a **productivity operating system**. It combines:
*   **Structured Focus Intervals**: Optimized 25/5 cycles with haptic and visual cues.
*   **Task Weighting**: Prioritize tasks by "Forge Effort" rather than simple lists.
*   **Insight Dynamics**: Clinical visualization of focus consistency via heatmaps.
*   **Gamified Retention**: Streak tracking and "Forger Levels" to maintain momentum.

---

## 🚀 Feature Set

### 1. The Forge Timer
*   **Material 3 Dynamic UI**: Adapts color based on focus/break state.
*   **Concentration Mode**: Strips away all UI noise, leaving only the countdown.
*   **Custom Protcols**: Tailor work/rest durations to your personal peak energy.

### 2. Strategic Task Management
*   **Session Estimation**: Assign "Forge Sessions" to tasks to visualize required effort.
*   **Priority Heatmapping**: High-priority tasks glow with intensity.
*   **Category Sorting**: Separate Work, Study, and Personal growth streams.

### 3. Productivity Analytics
*   **Focus Heatmap**: 28-day consistency grid (GitHub-style).
*   **Intensity Charts**: Weekly focus hour distribution visualization.
*   **Progression System**: Earn Forge Points and level up your productivity rank.

### 4. Enterprise-Grade Core
*   **Cloud Sync**: Secure Firebase authentication and real-time Firestore sync.
*   **Offline First**: Works perfectly in high-focus environments without internet.
*   **Policy Compliant**: Fully audited for Google Play Safety and Privacy standards.

---

## 🏗 Architecture & Tech Stack

### Frontend
*   **Flutter (Stable)**: High-performance cross-platform rendering.
*   **Riverpod**: Compile-time safe state management.
*   **Animate-Do**: Premium micro-animations for UX delight.
*   **Material 3**: Modern, clean design language.

### Backend
*   **Firebase Auth**: Secure anonymous and email-based identity.
*   **Cloud Firestore**: Real-time NoSQL data persistence.
*   **Firebase Analytics**: User behavior tracking for product optimization.
*   **Crashlytics**: Production-grade stability monitoring.

### Structure
Built using **Clean Architecture** (Presentation/Domain/Data) and the **MVVM + Repository** pattern for maximum maintainability.

---

## 📦 Development Setup

### Prerequisites
*   Flutter SDK `^3.19.0`
*   Dart `^3.3.0`
*   Firebase CLI (for backend modifications)

### Installation
1.  Clone the repository:
    ```bash
    git clone https://github.com/nayrbryanGaming/focusforge-pomodoro.git
    ```
2.  Install dependencies:
    ```bash
    flutter pub get
    ```
3.  Configure Firebase:
    *   Place `google-services.json` in `app/android/app/`.
    *   Place `GoogleService-Info.plist` in `app/ios/Runner/`.
4.  Run the application:
    ```bash
    flutter run --release
    ```

---

## 🗺 Roadmap
*   **Q3 2026**: "Forge Pass" — Premium custom themes and soundscapes.
*   **Q4 2026**: "Forge Groups" — Real-time collaborative focus rooms.
*   **Q1 2027**: WearOS & Apple Watch standalone clients.

## 💰 Monetization Strategy
*   **Freemium Model**: Core timer and basic tasks remain free forever.
*   **Forge Pro ($4.99/mo)**: Advanced analytics, unlimited tasks, and cross-device cloud sync.

## 📜 License
Copyright © 2026 FocusForge Protocol. All rights reserved.
Developed for the 18th Google Play Submission Hardening.
