# Google Play Console: Data Safety Form Guide

This guide provides the exact answers you should use when filling out the **Data Safety** section in the Google Play Console for FocusForge v4.0. Matches our current app implementation.

## 1. Data Collection and Security

| Question | Answer | Reason |
|---|---|---|
| Does your app collect or share any of the required user data types? | **Yes** | We collect Email (Auth), User IDs, and Analytics. |
| Is all of the user data collected by your app encrypted in transit? | **Yes** | Firebase uses TLS 1.3 for all data transmission. |
| Do you provide a way for users to request that their data be deleted? | **Yes** | Implemented via `Profile → Delete Account`. |

## 2. Data Types Collected

Select the following data types:

### Personal Information
- [x] **Email address** (Purpose: App functionality, Account management)
- [x] **User IDs** (Purpose: App functionality, Analytics)

### App Information and Performance
- [x] **Crash logs** (Purpose: Analytics)
- [x] **Diagnostics** (Purpose: Analytics)

### App Activity
- [x] **App interactions** (Purpose: Analytics - logged via Firebase Analytics)

## 3. Data Usage and Sharing

For each of the data types above, use these settings:

- **Sharing:** This data is NOT shared with third parties.
- **Collection:**
    - Is this data processed ephemerally? **No** (It is stored in Firestore/Analytics).
    - Is this data required for your app, or can users choose whether it's collected? **Required** (For Email/UID) / **Optional** (For Analytics - though currently we don't have a toggle, we disclose it).

## 4. Privacy Policy URL

Use the URL hosted on your FocusForge website:
`https://focusforge.app/legal/privacy-policy`

(Replace `focusforge.app` with your actual domain).

---

## 5. Why this matters for your 8th Attempt
Google reviewers cross-reference this form against the **Privacy Policy** document and the **actual app behavior**. Because we have implemented a functional **Data Export (JSON)** and **Account Deletion** flow, your answers here are now backed by verifiable proof in the app code.

> [!IMPORTANT]
> Ensure that the "Data Deletion" link in the Play Console points to your website's data deletion request section if you are required to provide a web-based deletion URL.
