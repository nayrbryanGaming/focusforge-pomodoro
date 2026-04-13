export const metadata = {
  title: 'Delete Your Account | FocusForge',
  description:
    'Instructions to permanently delete your FocusForge account and all associated data.',
};

export default function DeleteAccountPage() {
  return (
    <div className="min-h-screen bg-[#0F172A] text-slate-200 font-sans selection:bg-[#FF6B35] selection:text-white pb-24">
      {/* Nav */}
      <nav className="border-b border-slate-800 py-6 bg-slate-900/50 backdrop-blur-md sticky top-0 z-50">
        <div className="container mx-auto px-6 flex justify-between items-center">
          <a href="/" className="flex items-center gap-2 group">
            <div className="w-8 h-8 rounded-lg bg-gradient-to-br from-[#FF6B35] to-[#FFD166] flex items-center justify-center font-bold text-white text-sm">
              FF
            </div>
            <span className="text-xl font-bold tracking-tight group-hover:text-white transition-colors">
              FocusForge
            </span>
          </a>
          <a
            href="/"
            className="text-slate-400 hover:text-white transition-colors font-medium"
          >
            ← Back to Home
          </a>
        </div>
      </nav>

      <main className="container mx-auto px-6 pt-20 max-w-3xl">
        {/* Header */}
        <div className="mb-16 text-center">
          <div className="inline-flex items-center justify-center w-20 h-20 bg-red-950/50 border border-red-900/60 rounded-full mb-8">
            <span className="text-4xl">🗑️</span>
          </div>
          <h1 className="text-4xl font-extrabold text-white mb-4">
            Delete Your FocusForge Account
          </h1>
          <p className="text-xl text-slate-400 leading-relaxed">
            We&apos;re sorry to see you go. This page explains how to permanently
            delete your account and all associated data.
          </p>
        </div>

        {/* Warning Box */}
        <div className="bg-red-950/30 border border-red-800/60 rounded-2xl p-6 mb-12">
          <h2 className="text-lg font-bold text-red-400 mb-3 flex items-center gap-2">
            ⚠️ Important: This Action is Irreversible
          </h2>
          <p className="text-slate-300 leading-relaxed">
            Once you delete your account, <strong className="text-white">all of the following
            data will be permanently removed</strong> from our servers and cannot be
            recovered:
          </p>
          <ul className="mt-4 space-y-2">
            {[
              'Your account credentials and profile information',
              'All focus session history and session logs',
              'All tasks, categories, and progress data',
              'All achievements, badges, and streak records',
              'All productivity statistics and analytics data',
            ].map((item) => (
              <li key={item} className="flex items-start gap-3 text-slate-400">
                <span className="text-red-500 mt-0.5">✕</span>
                <span>{item}</span>
              </li>
            ))}
          </ul>
        </div>

        {/* Method 1: In-App */}
        <div className="bg-slate-900/80 border border-slate-800 rounded-2xl p-8 mb-8">
          <h2 className="text-2xl font-bold text-white mb-2">
            Method 1: Delete from the App (Recommended)
          </h2>
          <p className="text-slate-400 mb-6 text-sm">
            The fastest way — takes less than 60 seconds.
          </p>

          <div className="space-y-4">
            {[
              {
                step: '1',
                title: 'Open the FocusForge app',
                desc: 'Launch FocusForge on your Android device.',
              },
              {
                step: '2',
                title: 'Navigate to Profile',
                desc: 'Tap the Profile icon in the bottom navigation bar.',
              },
              {
                step: '3',
                title: 'Scroll to the Account section',
                desc: 'Scroll down until you see the "ACCOUNT" section.',
              },
              {
                step: '4',
                title: 'Tap "Delete My Account"',
                desc: 'Tap the red "Delete My Account" option.',
              },
              {
                step: '5',
                title: 'Review and confirm',
                desc: 'Review the list of data that will be deleted, then re-enter your credentials to confirm.',
              },
              {
                step: '6',
                title: 'Done',
                desc: 'Your account and all associated data will be permanently deleted within seconds.',
              },
            ].map((item) => (
              <div key={item.step} className="flex gap-4">
                <div className="flex-shrink-0 w-8 h-8 rounded-full bg-[#FF6B35]/20 border border-[#FF6B35]/40 flex items-center justify-center text-[#FF6B35] font-bold text-sm">
                  {item.step}
                </div>
                <div>
                  <p className="font-semibold text-white">{item.title}</p>
                  <p className="text-slate-400 text-sm mt-1">{item.desc}</p>
                </div>
              </div>
            ))}
          </div>
        </div>

        {/* Method 2: Email */}
        <div className="bg-slate-900/80 border border-slate-800 rounded-2xl p-8 mb-12">
          <h2 className="text-2xl font-bold text-white mb-2">
            Method 2: Request via Email
          </h2>
          <p className="text-slate-400 mb-6 text-sm">
            If you no longer have access to the app, you can request deletion by email.
          </p>

          <div className="space-y-4 mb-6">
            <div>
              <p className="text-sm text-slate-400 mb-1">Send an email to:</p>
              <a
                href="mailto:support@focusforge.app?subject=Account Deletion Request&body=Please delete my FocusForge account.%0A%0ARegistered email: %0A%0AUser ID (if known): %0A%0AAdditional notes:"
                className="text-[#FF6B35] font-bold text-lg hover:text-[#FFD166] transition-colors"
              >
                support@focusforge.app
              </a>
            </div>
            <div>
              <p className="text-sm text-slate-400 mb-1">Subject line:</p>
              <code className="text-white bg-slate-800 px-3 py-1 rounded-lg text-sm">
                Account Deletion Request
              </code>
            </div>
            <div>
              <p className="text-sm text-slate-400 mb-1">Include in the email:</p>
              <ul className="text-slate-300 text-sm space-y-1 mt-2">
                <li>• The email address associated with your account</li>
                <li>• Your Firebase User ID (if known, found in app settings)</li>
                <li>• Confirmation that you understand data is permanently deleted</li>
              </ul>
            </div>
          </div>

          <a
            href="mailto:support@focusforge.app?subject=Account Deletion Request&body=Please delete my FocusForge account.%0A%0ARegistered email: %0A%0AUser ID (if known): %0A%0AAdditional notes:"
            className="inline-flex items-center gap-2 bg-[#FF6B35] hover:bg-[#FFA573] text-white px-6 py-3 rounded-xl font-bold transition-all"
          >
            📧 Open Email Client
          </a>

          <p className="text-slate-500 text-xs mt-4">
            We will process your deletion request within 7 business days and send a
            confirmation email when complete.
          </p>
        </div>

        {/* Data Processing Note */}
        <div className="bg-slate-900/50 border border-slate-700/50 rounded-xl p-6 mb-8">
          <h3 className="font-bold text-white mb-2">📋 Data Processing Timeline</h3>
          <div className="space-y-2 text-sm text-slate-400">
            <p><span className="text-white font-medium">Immediate:</span> Account credentials, tasks, sessions, and personal data</p>
            <p><span className="text-white font-medium">Within 30 days:</span> Anonymized analytics data and crash logs</p>
            <p><span className="text-white font-medium">Within 90 days:</span> Backup copies purged from Google Firebase servers</p>
          </div>
        </div>

        {/* Contact */}
        <div className="text-center">
          <p className="text-slate-500 text-sm">
            Questions? Contact us at{' '}
            <a
              href="mailto:support@focusforge.app"
              className="text-[#FF6B35] hover:text-[#FFD166] transition-colors"
            >
              support@focusforge.app
            </a>
          </p>
        </div>
      </main>

      <footer className="mt-24 border-t border-slate-800 py-12 text-center text-slate-600 text-sm">
        <p>© 2026 FocusForge. All rights reserved.</p>
      </footer>
    </div>
  );
}
