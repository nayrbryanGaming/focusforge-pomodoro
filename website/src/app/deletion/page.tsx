import React from 'react';

export default function DeletionPage() {
  return (
    <div className="min-h-screen bg-[#0F172A] text-white font-sans flex flex-col">
      {/* Navigation */}
      <nav className="container mx-auto px-6 py-6 flex justify-between items-center relative z-10">
        <a href="/" className="flex items-center gap-3 group">
          <div className="w-10 h-10 rounded-xl bg-gradient-to-br from-[#FF6B35] to-[#FFD166] flex items-center justify-center font-bold text-white text-lg shadow-lg group-hover:scale-110 transition-transform">
            FF
          </div>
          <span className="text-2xl font-black tracking-tight group-hover:text-[#FF6B35] transition-colors">FocusForge</span>
        </a>
      </nav>

      {/* Main Content */}
      <main className="flex-grow container mx-auto px-6 py-20 max-w-2xl">
        <div className="bg-slate-900/50 backdrop-blur-xl border border-slate-800 p-12 rounded-[40px] shadow-2xl relative overflow-hidden">
          <div className="absolute top-0 right-0 w-32 h-32 bg-red-500/10 blur-3xl rounded-full"></div>
          
          <h1 className="text-4xl font-extrabold mb-6 bg-gradient-to-r from-red-400 to-orange-400 bg-clip-text text-transparent">
            Account & Data Purge
          </h1>
          
          <p className="text-slate-400 text-lg mb-10 leading-relaxed">
            At FocusForge, we respect your right to privacy and data autonomy. If you wish to permanently remove your account and all associated focus session data, please follow the steps below.
          </p>

          <div className="space-y-8">
            <section>
              <h2 className="text-xl font-bold mb-4 flex items-center gap-3">
                <span className="w-8 h-8 rounded-full bg-red-500/20 text-red-400 flex items-center justify-center text-sm">1</span>
                In-App Deletion (Recommended)
              </h2>
              <p className="text-slate-400 mb-4 ml-11">
                The fastest way to purge your data is directly within the FocusForge mobile application. This process is instant and automated.
              </p>
              <ul className="list-disc list-inside text-slate-500 ml-11 space-y-2 text-sm italic">
                <li>Open FocusForge ➔ Profile Tab</li>
                <li>Tap ➔ Settings Icon (Top Right)</li>
                <li>Select ➔ Delete Account</li>
                <li>Confirm by typing "DELETE"</li>
              </ul>
            </section>

            <div className="h-px bg-slate-800"></div>

            <section>
              <h2 className="text-xl font-bold mb-4 flex items-center gap-3">
                <span className="w-8 h-8 rounded-full bg-orange-500/20 text-orange-400 flex items-center justify-center text-sm">2</span>
                Manual Deletion Request
              </h2>
              <p className="text-slate-400 mb-6 ml-11">
                If you no longer have access to the app, you may request manual deletion. Please email our data protection officer:
              </p>
              
              <div className="ml-11">
                <a 
                  href="mailto:support@focusforge.app?subject=Data Deletion Request" 
                  className="inline-block bg-slate-800 hover:bg-slate-700 border border-slate-700 px-6 py-4 rounded-2xl font-bold transition-all hover:scale-105 active:scale-95"
                >
                  📧 support@focusforge.app
                </a>
                <p className="text-xs text-slate-500 mt-4 italic">
                  *Please include your registered email address. Manual requests are processed within 14 business days.
                </p>
              </div>
            </section>
          </div>

          <div className="mt-12 p-6 rounded-2xl bg-red-950/20 border border-red-900/30">
            <p className="text-red-400 text-sm font-bold flex items-center gap-2">
              ⚠️ Warning: Irreversible Action
            </p>
            <p className="text-red-900/80 text-xs mt-2 leading-relaxed">
              Purging your data will permanently delete your focus streaks, productivity points, task history, and premium status. This data cannot be recovered once the purge is complete.
            </p>
          </div>
        </div>
      </main>

      {/* Footer */}
      <footer className="py-10 text-center text-slate-600 text-sm border-t border-slate-900 mt-20">
        <p>© 2026 FocusForge. All rights reserved.</p>
        <div className="flex justify-center gap-6 mt-4">
          <a href="/privacy" className="hover:text-slate-400">Privacy</a>
          <a href="/terms" className="hover:text-slate-400">Terms</a>
          <a href="/" className="hover:text-slate-400">Home</a>
        </div>
      </footer>
    </div>
  );
}
