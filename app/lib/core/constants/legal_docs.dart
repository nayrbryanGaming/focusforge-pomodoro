class LegalDocs {
  static const String privacyPolicy = '''
# Privacy Policy for FocusForge
**Version: 1.3.1 - Stable Production Version**
**Last Updated: April 24, 2026**

FocusForge ("we," "us," or "our") operates as a 100% Offline-First productivity application. This Privacy Policy informs you that we do NOT collect, transmit, or store any of your personal data on any external servers.

## 1. Zero-Data Transmission Architecture
FocusForge is engineered to operate in complete isolation from the internet. All application logic, data persistence, and state management occur strictly within the boundaries of your local device.

## 2. Local Data Sovereignty
### Types of Data Stored Locally
The following data is stored exclusively on your device's local SQLite database:
- **Productivity Metrics**: Focus session durations, timestamps, and frequencies.
- **Task Management**: User-defined task titles, categories, and completion status.
- **Achievements**: Local progress milestones and unlocked badges.

### No Cloud Dependencies
- **No Firebase**: All cloud-based analytics, crash reporting, and authentication have been purged.
- **No External Sync**: There is no mechanism within the app to transmit data to the cloud.
- **No Third-Party Tracking**: We do not use cookies or any tracking SDKs.

## 3. Data Security
Because your data never leaves your device, it is protected by your device's native security features (disk encryption, biometrics, etc.). We do not have access to your data.

## 4. Your Rights: Absolute Control
You have absolute control over your data. You can view, modify, or permanently delete all application data at any time via the "Wipe Local Data" feature in the Profile settings. This action is instantaneous and irreversible.

## 5. Contact Us
For legal inquiries or technical verification of our offline architecture, please contact:
**legal@focusforge.app**
''';

  static const String termsOfService = '''
# Terms of Service
**Version: 1.3.1 - Stable Production Version**
**Last Updated: April 24, 2026**

Please read these Terms of Service carefully before using the FocusForge mobile application.

## 1. Acceptance of Terms
By using FocusForge, you agree to these terms. This is a local-only productivity tool provided "AS IS."

## 2. Local-Only Usage
You acknowledge that FocusForge is an offline application. It is your responsibility to manage your local data. We do not provide cloud backups or data recovery services.

## 3. Intellectual Property
FocusForge and its original content (excluding your local tasks) are the exclusive property of FocusForge.

## 4. Limitation of Liability
FocusForge is a tool for personal productivity. We are not liable for any data loss resulting from device failure, OS updates, or manual data purging by the user.

## 5. Governing Law
These Terms shall be governed by the laws of the jurisdiction in which the user resides, as the application operates entirely within the user's local environment.

## 6. Contact
legal@focusforge.app
''';

  static const String dataUsagePolicy = '''
# Data Usage Policy
**Version: 1.3.1 - Stable Production Version**

## 1. Local Persistence Only
All data generated within FocusForge (Tasks, Focus Sessions, Stats) is stored in a local SQLite database file on your device.

## 2. No Data Monetization
We do not sell, rent, or share any data because we never receive it. Your productivity data is yours alone.

## 3. Storage Transparency
Users can audit the local storage via the device's application management settings. The app size reflects only the code and your local database.

## 4. Instant Purge
The "Wipe Local Data" feature performs a `DROP TABLE` command on the local SQLite database, ensuring all history is physically removed from the device storage.
''';

  static const String disclaimer = '''
# Disclaimer
**Version: 1.3.1 - Stable Production Version**

## 1. General Information
FocusForge is a productivity tool based on the Pomodoro Technique. It is not a substitute for professional medical or psychological advice.

## 2. Reliance at Your Own Risk
The "Forge" level and "Points" are gamified metrics for motivational purposes only. They have no real-world value.
''';
}
