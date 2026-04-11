# 🔥 FocusForge — Pomodoro Productivity App

> **Forge Deep Focus. Build Unstoppable Productivity.**

[![Flutter](https://img.shields.io/badge/Flutter-3.x-blue?logo=flutter)](https://flutter.dev)
[![Firebase](https://img.shields.io/badge/Firebase-Enabled-orange?logo=firebase)](https://firebase.google.com)
[![License](https://img.shields.io/badge/License-MIT-green)](LICENSE)
[![Play Store](https://img.shields.io/badge/Google%20Play-Coming%20Soon-brightgreen?logo=google-play)](https://play.google.com)

---

## 📌 Overview

**FocusForge** is a modern Pomodoro productivity application that helps users build deep work habits through structured focus sessions, smart task management, and beautiful productivity analytics.

Unlike traditional Pomodoro apps that are either too simple or too cluttered, FocusForge combines:

- ⏱️ **Pomodoro Timer** — Customizable focus and break intervals
- ✅ **Task Management** — Assign sessions to specific tasks
- 📊 **Analytics Dashboard** — Visualize your daily and weekly productivity
- 🏆 **Gamification** — Streaks, badges, and productivity points
- 🔒 **Firebase Cloud Sync** — Seamless cross-device data persistence

---

## 🚨 The Problem

Modern knowledge workers face a productivity crisis:

| Problem | Impact |
|---|---|
| Digital distractions | Average focus span < 20 minutes |
| No structured work system | 40% of tasks never completed |
| Burnout | 77% of professionals experience burnout |
| Poor time tracking | Hours lost with no visibility |

Existing Pomodoro apps are **overly simple**, **visually outdated**, and **missing analytics**.

---

## ✅ The Solution

FocusForge creates a **productivity feedback loop**:

```
Focus Session → Task Completion → Stats Update → Gamification Reward → More Focus
```

Every session contributes to visible progress — making deep work addictive.

---

## ✨ Features

### 🎯 Core Features
- **Pomodoro Timer** — 25-min focus / 5-min break with custom intervals
- **Long Break Support** — Auto long break after 4 Pomodoros
- **Background Timer** — Runs even when app is minimized
- **Notification Alerts** — Push notifications for session start/end

### ✅ Task Management
- Create, edit, and delete tasks
- Assign estimated Pomodoro count per task
- Mark tasks as complete
- Archive completed tasks

### 📊 Analytics & Stats
- Daily focus time tracking
- Weekly bar chart visualization
- Session history log
- Productivity score calculation

### 🏆 Gamification
- **Focus Streaks** — Track consecutive productive days
- **Productivity Points** — Earn XP for completed sessions
- **Achievement Badges** — Unlock milestones (First Focus, Week Warrior, etc.)
- **Focus Levels** — Level up as you accumulate focus hours

### 👤 User Profiles
- Firebase Authentication (Email + Google Sign-In)
- Profile stats summary
- Offline mode with local data

---

## 🏗️ Architecture

FocusForge follows **Clean Architecture** principles with **MVVM** pattern:

```
┌─────────────────────────────────────────────────┐
│                 PRESENTATION LAYER               │
│         (Flutter Widgets + Riverpod State)       │
├─────────────────────────────────────────────────┤
│                  DOMAIN LAYER                    │
│       (Entities + Use Cases + Repo Interfaces)   │
├─────────────────────────────────────────────────┤
│                   DATA LAYER                     │
│      (Firebase/Local Implementations + Models)   │
└─────────────────────────────────────────────────┘
```

### Data Flow
```
UI Action → Riverpod Provider → Use Case → Repository → Firebase/Local → State Update → UI Rebuild
```

---

## 🧰 Tech Stack

| Layer | Technology |
|---|---|
| **Framework** | Flutter 3.x (Dart) |
| **State Management** | Riverpod 2.x |
| **UI System** | Material 3 |
| **Authentication** | Firebase Auth |
| **Database** | Cloud Firestore |
| **Analytics** | Firebase Analytics |
| **Crash Reporting** | Firebase Crashlytics |
| **Local Storage** | SharedPreferences + Hive |
| **Notifications** | flutter_local_notifications |
| **Charts** | fl_chart |

---

## 📁 Project Structure

```
focusforge-pomodoro/
├── app/                          # Flutter application
│   ├── lib/
│   │   ├── core/
│   │   │   ├── constants/        # App-wide constants
│   │   │   ├── theme/            # Material 3 theme
│   │   │   └── utils/            # Helper utilities
│   │   ├── features/
│   │   │   ├── auth/             # Login & registration
│   │   │   ├── timer/            # Pomodoro timer engine
│   │   │   ├── tasks/            # Task management
│   │   │   ├── stats/            # Analytics & charts
│   │   │   ├── achievements/     # Gamification
│   │   │   └── profile/          # User profile
│   │   ├── models/               # Domain entities
│   │   ├── providers/            # Riverpod providers
│   │   └── main.dart
│   └── assets/
│       ├── icons/
│       ├── sounds/
│       └── images/
├── backend/
│   └── firebase/
│       ├── firestore.rules
│       └── firestore.indexes.json
├── website/                      # Next.js landing page
├── docs/                         # Technical documentation
├── legal/                        # Play Store legal files
└── branding/                     # Brand guidelines
```

---

## 🚀 Getting Started

### Prerequisites
```bash
flutter --version   # Flutter 3.19+
dart --version      # Dart 3.x
node --version      # Node 18+ (for website)
```

### Flutter App Setup

```bash
# 1. Clone the repository
git clone https://github.com/nayrbryanGaming/focusforge-pomodoro.git
cd focusforge-pomodoro/app

# 2. Install dependencies
flutter pub get

# 3. Configure Firebase
# Add your google-services.json to android/app/
# Add your GoogleService-Info.plist to ios/Runner/

# 4. Run on physical device
flutter run --release
```

### Firebase Setup
1. Create a Firebase project at [console.firebase.google.com](https://console.firebase.google.com)
2. Enable **Authentication** (Email/Password + Google)
3. Enable **Cloud Firestore**
4. Enable **Analytics** and **Crashlytics**
5. Download config files and place in correct directories
6. Deploy Firestore rules: `firebase deploy --only firestore`

### Landing Page Setup

```bash
cd website
npm install
npm run dev         # Development
npm run build       # Production
```

---

## 📊 Database Schema

### Firestore Collections

```
users/{userId}
  - email: string
  - displayName: string
  - createdAt: timestamp
  - premiumStatus: boolean
  - totalPoints: number

tasks/{taskId}
  - userId: string
  - title: string
  - estimatedPomodoros: number
  - completedPomodoros: number
  - completed: boolean
  - createdAt: timestamp

sessions/{sessionId}
  - userId: string
  - taskId: string?
  - duration: number (seconds)
  - type: 'focus' | 'short_break' | 'long_break'
  - completed: boolean
  - timestamp: timestamp

stats/{userId}
  - totalFocusTime: number (seconds)
  - dailyStreak: number
  - longestStreak: number
  - weeklyFocusHours: map
  - totalPoints: number
  - level: number
```

---

## 🗺️ Roadmap

### v1.0 — Launch (Current)
- [x] Pomodoro timer with customization
- [x] Task management
- [x] Firebase sync
- [x] Basic stats dashboard
- [x] Streak tracking
- [x] Achievement badges

### v1.5 — Growth
- [ ] Widget support (Android home screen)
- [ ] Apple Watch / Wear OS companion
- [ ] CSV export for productivity data
- [ ] Team/shared focus rooms

### v2.0 — Premium
- [ ] AI-powered focus scheduling
- [ ] Spotify/YouTube Music integration
- [ ] Calendar sync (Google/Outlook)
- [ ] Advanced analytics with ML insights

---

## 💰 Monetization Strategy

| Tier | Price | Features |
|---|---|---|
| **Free** | $0 | 5 tasks, basic timer, 7-day history |
| **Pro** | $3.99/mo | Unlimited tasks, full analytics, cloud sync |
| **Premium** | $7.99/mo | All Pro features + AI scheduling + integrations |

### Revenue Projections (Year 1)
- Target: **50,000 installs**
- Conversion rate: **4%** → 2,000 paid users
- Average revenue per user: **$2.50/mo**
- **MRR target: $5,000**

---

## 📈 Growth Strategy

1. **Product Hunt Launch** — Target #1 Product of the Day
2. **Open Source** — GitHub exposure drives developer adoption
3. **Student Communities** — Partner with university productivity groups
4. **TikTok Content** — Productivity creators showcase app features
5. **SEO Landing Page** — Rank for "pomodoro timer app" keywords

---

## 🆚 Competitive Advantage

| Feature | FocusForge | Forest | Todoist | Be Focused |
|---|---|---|---|---|
| Pomodoro Timer | ✅ | ✅ | ❌ | ✅ |
| Task Integration | ✅ | ❌ | ✅ | ❌ |
| Analytics | ✅ | ❌ | ✅ | ✅ |
| Gamification | ✅ | ✅ | ❌ | ❌ |
| Material 3 UI | ✅ | ❌ | ❌ | ❌ |
| Free Tier | ✅ | ✅ | Limited | Limited |
| Open Source | ✅ | ❌ | ❌ | ❌ |

---

## 🤝 Contributing

Contributions are welcome! Please read our [Contributing Guide](CONTRIBUTING.md) first.

```bash
# Fork the repository
# Create your feature branch
git checkout -b feature/amazing-feature

# Commit your changes
git commit -m 'feat: add amazing feature'

# Push to the branch
git push origin feature/amazing-feature

# Open a Pull Request
```

### Commit Convention
We use [Conventional Commits](https://www.conventionalcommits.org/):
- `feat:` — New feature
- `fix:` — Bug fix
- `docs:` — Documentation
- `style:` — Formatting
- `refactor:` — Code restructuring
- `test:` — Tests

---

## 📄 Legal

- [Privacy Policy](legal/privacy_policy.md)
- [Terms of Service](legal/terms_of_service.md)
- [Data Usage Policy](legal/data_usage_policy.md)
- [Disclaimer](legal/disclaimer.md)

---

## 📬 Contact

- **Developer:** nayrbryanGaming
- **GitHub:** [@nayrbryanGaming](https://github.com/nayrbryanGaming)
- **Email:** support@focusforge.app

---

## 📝 License

This project is licensed under the MIT License — see the [LICENSE](LICENSE) file for details.

---

<div align="center">

**Built with 🔥 by FocusForge Team**

*Forge Deep Focus. Build Unstoppable Productivity.*

</div>
