# FocusForge

### Forge Deep Focus. Build Unstoppable Productivity.

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Firebase](https://img.shields.io/badge/Firebase-039BE5?style=for-the-badge&logo=Firebase&logoColor=white)](https://firebase.google.com)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](https://opensource.org/licenses/MIT)

FocusForge is a clinical-grade Pomodoro productivity application designed for builders, founders, and absolute focus athletes. It transmutes distractibility into unstoppable power through a refined focus habit system.

---

## ⚔️ The Problem
In the modern digital landscape, the "Deep Work" state is under constant siege by:
- **Fractured Attention**: Digital distractions and notification floods.
- **Cognitive Drift**: Procrastination cycles and lack of time management.
- **Burnout**: Unstructured work blocks that deplete neurological resources.

## ⚡ The Solution
FocusForge isn't just a timer; it's a **Focus Infrastructure**. By combining mathematically optimized work-rest cycles with strategic task management and clinical analytics, we create a powerful productivity loop.

---

## 🛠️ Features

### 1. The Forge (Pomodoro Timer)
- **Deep Focus (25m)**: Optimized duration for cognitive entry into flow state.
- **Short Break (5m)**: Rapid neurological recovery.
- **Long Break (15m)**: Deep reset after 4 successful sessions.
- **Concentration Mode**: Zero-distraction fullscreen interface.

### 2. Task Ledger
- Strategic task planning.
- Priority weighting and session estimation.
- Direct integration with focus sessions.

### 3. Insight Dynamics (Analytics)
- Weekly focus velocity graphs.
- Session consistency tracking.
- Productivity streak visualization.

### 4. Forge Gamification
- **Focus Streaks**: Maintain momentum to build habits.
- **Productivity Points**: Quantify your output.
- **Achievement Badges**: Milestone-based rewards for elite performance.

---

## 🏗️ Architecture & Tech Stack

### Frontend
- **Framework**: Flutter (Stable)
- **Language**: Dart
- **State Management**: Riverpod (Reactive Architecture)
- **Design**: Material 3 (Production-Grade Modern UI)

### Backend
- **Platform**: Firebase
- **Auth**: Firebase Authentication (Secure JWT)
- **Database**: Cloud Firestore (Real-time NoSQL)
- **Monitoring**: Firebase Analytics & Crashlytics

### Architecture Pattern
- **Clean Architecture**: Separated into Presentation, Domain, and Data layers.
- **Design Pattern**: MVVM + Repository pattern for maximum testability and maintainability.

---

## 🚀 Installation & Setup

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/nayrbryanGaming/focusforge-pomodoro.git
   ```

2. **Setup Firebase**:
   - Create a project on the [Firebase Console](https://console.firebase.google.com/).
   - Add an Android app with package name `com.focusforge.app`.
   - Download `google-services.json` and place it in `app/android/app/`.

3. **Install Dependencies**:
   ```bash
   cd app
   flutter pub get
   ```

4. **Run Application**:
   ```bash
   flutter run
   ```

---

## 🗺️ Roadmap
- [x] Phase 1: Core Timer Engine
- [x] Phase 2: Task Ledger Implementation
- [x] Phase 3: Firebase Integration
- [x] Phase 4: Production Hardening (Google Play Compliance)
- [ ] Phase 5: Multi-Device Sync (Web & Desktop)
- [ ] Phase 6: Team Focus Groups

## ⚖️ Legal & Compliance
FocusForge is fully compliant with Google Play Store Developer Policies.
- [Privacy Policy](legal/privacy_policy.md)
- [Terms of Service](legal/terms_of_service.md)
- [Data Usage Policy](legal/data_usage_policy.md)

---

## 📜 License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---
**FocusForge Protocol** | *Transmute Procrastination into Power.*
