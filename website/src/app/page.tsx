import Head from 'next/head';

export default function Home() {
  return (
    <div className="min-h-screen bg-slate-900 text-slate-50 font-sans">
      <Head>
        <title>FocusForge | Forge Deep Focus</title>
        <meta name="description" content="Build unstoppable productivity with FocusForge." />
      </Head>

      {/* Navigation */}
      <nav className="container mx-auto px-6 py-4 flex justify-between items-center">
        <div className="flex items-center gap-2">
          <div className="w-8 h-8 rounded bg-[#FF6B35] flex items-center justify-center font-bold text-white">FF</div>
          <span className="text-xl font-bold tracking-tight">FocusForge</span>
        </div>
        <div className="hidden md:flex gap-8 text-slate-300 font-medium">
          <a href="#features" className="hover:text-[#FFD166] transition-colors">Features</a>
          <a href="#how-it-works" className="hover:text-[#FFD166] transition-colors">How it Works</a>
          <a href="#pricing" className="hover:text-[#FFD166] transition-colors">Pricing</a>
        </div>
        <button className="bg-[#FF6B35] hover:bg-[#FFA573] text-white px-6 py-2 rounded-full font-semibold transition-all">
          Get Early Access
        </button>
      </nav>

      {/* Hero Section */}
      <header className="container mx-auto px-6 py-24 text-center">
        <h1 className="text-5xl md:text-7xl font-extrabold tracking-tight mb-6 leading-tight">
          Forge Deep Focus. <br />
          <span className="text-[#FF6B35]">Build Unstoppable Productivity.</span>
        </h1>
        <p className="text-xl md:text-2xl text-slate-400 max-w-3xl mx-auto mb-10 leading-relaxed">
          FocusForge is the modern Pomodoro system that combines structured focus sessions, intelligent task tracking, and gamified progress to beat burnout and destroy digital distraction.
        </p>
        <div className="flex flex-col sm:flex-row gap-4 justify-center items-center">
          <button className="bg-[#FF6B35] hover:bg-[#FFA573] text-white px-8 py-4 rounded-full font-bold text-lg w-full sm:w-auto transition-transform hover:scale-105 shadow-lg shadow-[#FF6B35]/20">
            Download for iOS & Android
          </button>
          <button className="bg-slate-800 hover:bg-slate-700 text-white px-8 py-4 rounded-full font-bold text-lg w-full sm:w-auto border border-slate-700 transition-colors">
            View Source Code
          </button>
        </div>
      </header>

      {/* Features Grid */}
      <section id="features" className="bg-slate-950 py-24">
        <div className="container mx-auto px-6">
          <div className="text-center mb-16">
            <h2 className="text-4xl font-bold mb-4">Not Just Another Timer</h2>
            <p className="text-xl text-slate-400">A complete productivity feedback loop built for knowledge workers.</p>
          </div>
          
          <div className="grid md:grid-cols-3 gap-8">
            <div className="bg-slate-900 p-8 rounded-2xl border border-slate-800">
              <div className="w-14 h-14 bg-[#FF6B35]/20 rounded-xl flex items-center justify-center mb-6 text-[#FF6B35] text-2xl">⏳</div>
              <h3 className="text-2xl font-bold mb-3">Custom Pomodoros</h3>
              <p className="text-slate-400 leading-relaxed">Set personalized focus and break durations. Let the app seamlessly guide you through your deep work intervals.</p>
            </div>
            
            <div className="bg-slate-900 p-8 rounded-2xl border border-slate-800">
              <div className="w-14 h-14 bg-[#10B981]/20 rounded-xl flex items-center justify-center mb-6 text-[#10B981] text-2xl">✅</div>
              <h3 className="text-2xl font-bold mb-3">Smart Task Sync</h3>
              <p className="text-slate-400 leading-relaxed">Estimate pomodoros required for tasks, track actuals, and sync everything directly to Firebase Cloud.</p>
            </div>
            
            <div className="bg-slate-900 p-8 rounded-2xl border border-slate-800">
              <div className="w-14 h-14 bg-[#FFD166]/20 rounded-xl flex items-center justify-center mb-6 text-[#FFD166] text-2xl">🏆</div>
              <h3 className="text-2xl font-bold mb-3">Gamified Streaks</h3>
              <p className="text-slate-400 leading-relaxed">Earn productivity points, level up, and unlock achievement badges by maintaining consistent focus streaks.</p>
            </div>
          </div>
        </div>
      </section>

      {/* Minimalist CTA */}
      <section className="py-24 relative overflow-hidden">
        <div className="absolute inset-0 bg-gradient-to-r from-[#FF6B35]/20 to-transparent"></div>
        <div className="container mx-auto px-6 text-center relative z-10">
          <h2 className="text-4xl md:text-5xl font-bold mb-8">Ready to reclaim your time?</h2>
          <button className="bg-white text-slate-900 px-8 py-4 rounded-full font-bold text-lg hover:bg-slate-200 transition-colors">
            Start Your First Session Now
          </button>
        </div>
      </section>

      {/* Footer */}
      <footer className="border-t border-slate-800 py-12">
        <div className="container mx-auto px-6 flex flex-col md:flex-row justify-between items-center gap-6 text-slate-500">
          <p>© 2026 FocusForge. Built by nayrbryanGaming.</p>
          <div className="flex gap-6">
            <a href="#" className="hover:text-white transition-colors">Privacy Policy</a>
            <a href="#" className="hover:text-white transition-colors">Terms of Service</a>
            <a href="#" className="hover:text-white transition-colors">GitHub</a>
          </div>
        </div>
      </footer>
    </div>
  );
}
