# Data Usage Policy — FocusForge

**Last Updated:** April 11, 2026

This Data Usage Policy explains in detail what data FocusForge collects, why we collect it, and how it is used — in compliance with **Google Play Store Data Safety requirements**.

---

## Data Collected and Usage Summary

### 🔐 Personal Information

| Data | Collected | Shared | Purpose |
|---|---|---|---|
| Email address | Yes | No (stored in Firebase only) | Account identification |
| Display name | Yes | No | UI personalization |
| Profile photo | Optional | No | Avatar display |
| Google account info | If Google login used | No | OAuth authentication |

### ⏱️ App Activity

| Data | Collected | Shared | Purpose |
|---|---|---|---|
| Focus session duration | Yes | No | Productivity statistics |
| Session start/end times | Yes | No | Streak calculation |
| Task titles | Yes | No | Task management |
| Tasks completed | Yes | No | Progress tracking |
| App usage frequency | Yes (anonymized) | Firebase Analytics | Feature improvement |
| Settings preferences | Yes | No | Preference restoration |

### 📱 Device Information

| Data | Collected | Shared | Purpose |
|---|---|---|---|
| Device model | Yes (crash reports only) | Firebase Crashlytics | Bug diagnosis |
| OS version | Yes (crash reports only) | Firebase Crashlytics | Compatibility |
| App version | Yes | Firebase | Update management |
| Crash logs | Yes | Firebase Crashlytics | Stability improvement |

---

## Data NOT Collected

FocusForge **does NOT collect**:

- ❌ Location data
- ❌ Contacts or phone book
- ❌ SMS or call logs
- ❌ Photos or media (unless uploaded as profile photo)
- ❌ Microphone or camera data
- ❌ Clipboard content
- ❌ Financial or payment information (handled by Google Play Billing)
- ❌ Biometric data
- ❌ Browsing history

---

## Data Storage Architecture

```
User Device (Local)
├── Preferences (SharedPreferences)
│   ├── Timer settings
│   ├── Notification preferences
│   └── Theme selection
└── Cache (temporary)
    └── Offline data sync queue

Firebase Cloud (Remote)
├── Cloud Firestore
│   ├── users/{userId}
│   ├── tasks/{taskId}
│   ├── sessions/{sessionId}
│   └── stats/{userId}
├── Firebase Auth
│   └── User credentials (hashed)
└── Firebase Analytics
    └── Anonymized event data
```

---

## Data Security Standards

| Standard | Implementation |
|---|---|
| Encryption in transit | TLS 1.3 |
| Encryption at rest | AES-256 (Firebase) |
| Authentication | Firebase JWT tokens |
| Authorization | Firestore security rules |
| Password storage | Bcrypt (Firebase handled) |
| HTTPS only | Enforced for all API calls |

---

## Firestore Security Rules Summary

Our Firestore database implements strict security rules:
- Users can only read and write their own data
- No cross-user data access is permitted
- Server-side validation for all writes
- Rate limiting on write operations

---

## Data Retention Schedule

| Data Type | Retention | Deletion Method |
|---|---|---|
| Account profile | Until account deleted | User request or in-app deletion |
| Session history | 2 years | Auto-purge after expiry |
| Task data | Until account deleted | User request or in-app deletion |
| Analytics events | 14 months | Firebase automatic rotation |
| Crash reports | 90 days | Firebase automatic deletion |
| Anonymous usage | 26 months | Firebase automatic rotation |

---

## Third-Party Data Processors

| Processor | Data Received | Purpose | Location |
|---|---|---|---|
| Google Firebase | All app data | Backend infrastructure | Global (Google Cloud) |
| Google Analytics | Anonymized events | Usage insights | Global (Google Cloud) |
| Firebase Crashlytics | Device info + crash logs | Crash diagnostics | Global (Google Cloud) |

All third-party processors are GDPR and CCPA compliant.

---

## User Data Controls

Users have full control over their data:

| Action | How to Do It |
|---|---|
| View your data | Profile → My Statistics |
| Export your data | Profile → Settings → Export Data |
| Delete session history | Stats → Clear History |
| Delete account + all data | Profile → Settings → Delete Account |
| Opt out of analytics | Profile → Settings → Privacy → Analytics |
| Contact for data request | support@focusforge.app |

---

## Compliance

This policy and our data practices comply with:

- ✅ **Google Play Store Data Safety** requirements
- ✅ **General Data Protection Regulation (GDPR)** — EU/EEA
- ✅ **California Consumer Privacy Act (CCPA)** — California
- ✅ **Children's Online Privacy Protection Act (COPPA)** — USA
- ✅ **Firebase Terms of Service**
- ✅ **Google API Services User Data Policy**

---

## Changes to This Policy

Updates to this policy will be communicated via in-app notification. Continued use of the app constitutes acceptance of updated policies.

---

## Contact

For data-related inquiries:

📧 **Email:** support@focusforge.app
🐙 **GitHub Issues:** https://github.com/nayrbryanGaming/focusforge-pomodoro/issues
