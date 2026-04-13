import Head from 'next/head';

export default function Home() {
  return (
    <div className="min-h-screen bg-slate-900 text-slate-50 font-sans selection:bg-[#FF6B35] selection:text-white">
      <Head>
        <title>FocusForge | Forge Deep Focus</title>
        <meta name="description" content="Build unstoppable productivity with FocusForge." />
      </Head>

      {/* Navigation */}
      <nav className="container mx-auto px-6 py-6 flex justify-between items-center z-50 relative">
        <div className="flex items-center gap-3">
          <div className="w-10 h-10 rounded-xl bg-gradient-to-br from-[#FF6B35] to-[#FFD166] flex items-center justify-center font-bold text-white text-lg shadow-lg shadow-[#FF6B35]/20">
            FF
          </div>
          <span className="text-2xl font-black tracking-tight">FocusForge</span>
        </div>
        <div className="hidden md:flex gap-10 text-slate-300 font-medium">
          <a href="#features" className="hover:text-[#FFD166] transition-colors duration-300">Features</a>
          <a href="#how-it-works" className="hover:text-[#FFD166] transition-colors duration-300">How it Works</a>
          <a href="#pricing" className="hover:text-[#FFD166] transition-colors duration-300">Pricing</a>
        </div>
        <button className="bg-[#FF6B35] hover:bg-[#FFA573] text-white px-8 py-3 rounded-full font-bold transition-all shadow-lg shadow-[#FF6B35]/20 hover:shadow-[#FF6B35]/40 transform hover:-translate-y-0.5">
          Get Early Access
        </button>
      </nav>

      {/* Hero Section */}
      <header className="container mx-auto px-6 py-24 md:py-32 text-center relative overflow-hidden">
        {/* Background glow effects */}
        <div className="absolute top-0 left-1/2 -translate-x-1/2 w-[800px] h-[500px] bg-[#FF6B35]/15 blur-[120px] rounded-full point-events-none -z-10"></div>
        <div className="absolute top-40 right-0 w-[400px] h-[400px] bg-[#0F172A] blur-[100px] rounded-full point-events-none -z-10"></div>
        
        <h1 className="text-5xl md:text-8xl font-extrabold tracking-tight mb-8 leading-tight animate-fade-in-up">
          Forge Deep Focus. <br />
          <span className="bg-gradient-to-r from-[#FF6B35] via-[#FF8A5B] to-[#FFD166] bg-clip-text text-transparent">
            Build Unstoppable Habits.
          </span>
        </h1>
        
        <p className="text-xl md:text-2xl text-slate-400 max-w-3xl mx-auto mb-14 leading-relaxed animate-fade-in-up animation-delay-100">
          FocusForge is the ultimate Pomodoro system designed for the next generation of knowledge workers. 
          Scientific focus intervals, intelligent task planning, and a sleek, distraction-free environment.
        </p>

        <div className="flex flex-col sm:flex-row gap-6 justify-center items-center animate-fade-in-up animation-delay-200">
          <button className="bg-[#FF6B35] hover:bg-[#FFA573] text-white px-10 py-5 rounded-2xl font-bold text-xl w-full sm:w-auto transition-all hover:scale-105 shadow-2xl shadow-[#FF6B35]/30">
            Download for Mobile
          </button>
          <button className="bg-slate-800/80 backdrop-blur-md hover:bg-slate-700 text-white px-10 py-5 rounded-2xl font-bold text-xl w-full sm:w-auto border border-slate-700 transition-all hover:border-[#FF6B35]/50">
            Learn the Science
          </button>
        </div>
      </header>

      {/* Features Grid */}
      <section id="features" className="bg-slate-950/50 py-32 border-y border-slate-800/50 relative">
        <div className="absolute inset-0 bg-[url('https://grainy-gradients.vercel.app/noise.svg')] opacity-20 mix-blend-overlay pointer-events-none"></div>
        <div className="container mx-auto px-6 relative z-10">
          <div className="text-center mb-20">
            <h2 className="text-4xl md:text-5xl font-bold mb-6">Not Just Another Timer</h2>
            <p className="text-xl text-slate-400 max-w-2xl mx-auto">A complete productivity feedback loop built for professionals who need to ship work, not just track time.</p>
          </div>
          
          <div className="grid md:grid-cols-3 gap-8">
            <div className="bg-slate-900/80 backdrop-blur-sm p-10 rounded-3xl border border-slate-800 hover:border-[#FF6B35]/30 transition-all duration-300 group">
              <div className="w-16 h-16 bg-[#FF6B35]/10 group-hover:bg-[#FF6B35]/20 transition-all rounded-2xl flex items-center justify-center mb-8 text-[#FF6B35] text-3xl">⏳</div>
              <h3 className="text-2xl font-bold mb-4">Custom Pomodoros</h3>
              <p className="text-slate-400 leading-relaxed text-lg">Set personalized focus and break durations. Let the psychological color-shifting UI seamlessly guide you through deep work intervals.</p>
            </div>
            
            <div className="bg-slate-900/80 backdrop-blur-sm p-10 rounded-3xl border border-slate-800 hover:border-[#10B981]/30 transition-all duration-300 group">
              <div className="w-16 h-16 bg-[#10B981]/10 group-hover:bg-[#10B981]/20 transition-all rounded-2xl flex items-center justify-center mb-8 text-[#10B981] text-3xl">✅</div>
              <h3 className="text-2xl font-bold mb-4">Smart Task Sync</h3>
              <p className="text-slate-400 leading-relaxed text-lg">Estimate pomodoros required for tasks, categorize priorities, and sync everything flawlessly to the Cloud in real-time.</p>
            </div>
            
            <div className="bg-slate-900/80 backdrop-blur-sm p-10 rounded-3xl border border-slate-800 hover:border-[#FFD166]/30 transition-all duration-300 group">
              <div className="w-16 h-16 bg-[#FFD166]/10 group-hover:bg-[#FFD166]/20 transition-all rounded-2xl flex items-center justify-center mb-8 text-[#FFD166] text-3xl">🏆</div>
              <h3 className="text-2xl font-bold mb-4">Gamified Progression</h3>
              <p className="text-slate-400 leading-relaxed text-lg">Earn productivity points, level up, and unlock beautiful confetti celebrations by maintaining consistent focus streaks.</p>
            </div>
          </div>
        </div>
      </section>

      {/* Community Proof */}
      <section className="py-24 bg-slate-900">
        <div className="container mx-auto px-6 text-center">
          <div className="inline-flex items-center gap-3 bg-slate-800/80 border border-slate-700 px-6 py-3 rounded-full mb-8">
            <div className="w-3 h-3 bg-green-500 rounded-full animate-pulse"></div>
            <span className="font-semibold text-slate-300">Live: Over 1,200 Forgers active right now</span>
          </div>
          <h2 className="text-3xl md:text-5xl font-bold mb-16 max-w-4xl mx-auto leading-tight">Join a global community of developers, founders, and creators doing the best work of their lives.</h2>
        </div>
      </section>

      {/* Minimalist CTA */}
      <section className="py-32 relative overflow-hidden">
        <div className="absolute inset-0 bg-gradient-to-tr from-[#FF6B35]/20 via-slate-900 to-[#0F172A]"></div>
        <div className="absolute -bottom-1/2 left-1/2 -translate-x-1/2 w-[800px] h-[800px] bg-[#FF6B35]/15 blur-[150px] rounded-full point-events-none -z-10"></div>
        <div className="container mx-auto px-6 text-center relative z-10">
          <h2 className="text-5xl md:text-6xl font-black mb-10 tracking-tight">Ready to reclaim your time?</h2>
          <button className="bg-white text-slate-900 px-12 py-6 rounded-full font-bold text-xl hover:bg-slate-200 hover:scale-105 transition-all shadow-xl shadow-white/10">
            Start Your First Session Now
          </button>
        </div>
      </section>

      {/* Footer */}
      <footer className="border-t border-slate-800 py-16 bg-slate-950">
        <div className="container mx-auto px-6">
          <div className="flex flex-col md:flex-row justify-between items-center gap-8 mb-12">
            <div className="flex items-center gap-3">
               <div className="w-10 h-10 rounded-xl bg-gradient-to-br from-[#FF6B35] to-[#FFD166] flex items-center justify-center font-black text-white text-xl">F</div>
               <span className="text-2xl font-bold tracking-tight">FocusForge</span>
            </div>
            <div className="flex flex-wrap justify-center items-center gap-8 text-slate-400 font-medium">
              <a href="/legal/privacy-policy" className="hover:text-white transition-colors">Privacy Policy</a>
              <a href="/legal/terms-of-service" className="hover:text-white transition-colors">Terms of Service</a>
              <a href="/legal/disclaimer" className="hover:text-white transition-colors">Disclaimer</a>
              <a href="/legal/data-usage" className="hover:text-white transition-colors">Data Usage</a>
              <a href="/legal/delete-account" className="text-[#EF4444] hover:text-red-400 transition-colors font-bold uppercase tracking-wider text-xs border border-red-900/50 bg-red-950/20 px-4 py-2 rounded-lg">Data Deletion Request</a>
            </div>
          </div>
          <div className="text-center text-slate-600 text-sm flex flex-col md:flex-row justify-between items-center">
            <p>© 2026 FocusForge. All rights reserved.</p>
            <p className="mt-4 md:mt-0">Built with ⚡ for unstoppable productivity.</p>
          </div>
        </div>
      </footer>
    </div>
  );
}
