export default function Home() {
    return (
        <div className="min-h-screen bg-[#0F172A] text-white font-sans selection:bg-[#FF6B35]/30">
            {/* Navigation */}
            <nav className="container mx-auto px-6 py-8 flex justify-between items-center z-50 relative">
                <div className="flex items-center gap-3 group cursor-pointer">
                    <div className="w-12 h-12 rounded-2xl bg-gradient-to-br from-[#FF6B35] to-[#FFD166] flex items-center justify-center font-black text-white text-xl shadow-xl shadow-[#FF6B35]/20 group-hover:shadow-[#FF6B35]/40 transition-all duration-500 transform group-hover:rotate-6">
                        FF
                    </div>
                    <span className="text-2xl font-black tracking-tight bg-gradient-to-r from-white to-slate-400 bg-clip-text text-transparent">FocusForge</span>
                </div>
                <div className="hidden md:flex gap-12 text-slate-400 font-semibold tracking-wide uppercase text-xs">
                    <a href="#features" className="hover:text-[#FF6B35] transition-all duration-300">Features</a>
                    <a href="#science" className="hover:text-[#FFD166] transition-all duration-300">The Science</a>
                    <a href="#support" className="hover:text-[#FF6B35] transition-all duration-300">Support</a>
                </div>
                <button className="bg-[#FF6B35] hover:bg-[#FFA573] text-white px-8 py-3 rounded-2xl font-black text-sm uppercase tracking-widest transition-all shadow-xl shadow-[#FF6B35]/20 hover:shadow-[#FF6B35]/40 transform hover:-translate-y-1 active:scale-95">
                    Get Mobile App
                </button>
            </nav>

            {/* Hero Section */}
            <header className="container mx-auto px-6 pt-24 pb-32 md:pt-40 md:pb-48 text-center relative">
                {/* Background glow effects */}
                <div className="absolute top-0 left-1/2 -translate-x-1/2 w-[1000px] h-[600px] bg-[#FF6B35]/10 blur-[140px] rounded-full pointer-events-none -z-10"></div>
                <div className="absolute -top-40 -left-40 w-[500px] h-[500px] bg-blue-500/5 blur-[120px] rounded-full pointer-events-none -z-10 animate-pulse"></div>

                <div className="inline-flex items-center gap-2 bg-white/5 border border-white/10 px-4 py-2 rounded-full mb-10 backdrop-blur-md animate-in fade-in slide-in-from-top-4 duration-1000">
                    <span className="w-2 h-2 bg-[#FF6B35] rounded-full animate-ping"></span>
                    <span className="text-[10px] font-black uppercase tracking-[0.2em] text-slate-300">Phase 18 Hardening Live</span>
                </div>

                <h1 className="text-6xl md:text-9xl font-black tracking-tighter mb-10 leading-[0.9] animate-in fade-in slide-in-from-bottom-12 duration-1000">
                    Forge Deep <br />
                    <span className="bg-gradient-to-r from-[#FF6B35] via-[#FF8A5B] to-[#FFD166] bg-clip-text text-transparent italic">
                        Focus.
                    </span>
                </h1>

                <p className="text-xl md:text-2xl text-slate-400 max-w-2xl mx-auto mb-16 leading-relaxed font-medium animate-in fade-in slide-in-from-bottom-12 duration-1000 delay-200">
                    The clinical-grade Pomodoro system built for builders, founders, and absolute focus athletes. Transmute distractibility into unstoppable productivity.
                </p>

                <div className="flex flex-col sm:flex-row gap-6 justify-center items-center animate-in fade-in slide-in-from-bottom-12 duration-1000 delay-400">
                    <button className="group bg-white text-[#0F172A] px-12 py-6 rounded-2xl font-black text-xl w-full sm:w-auto transition-all hover:bg-[#FF6B35] hover:text-white shadow-2xl shadow-white/10 hover:shadow-[#FF6B35]/30">
                        Download Now
                        <span className="inline-block transition-transform group-hover:translate-x-1 ml-2">→</span>
                    </button>
                    <button className="bg-slate-800/40 backdrop-blur-xl hover:bg-slate-800 text-white px-12 py-6 rounded-2xl font-black text-xl w-full sm:w-auto border border-white/10 transition-all">
                        The Protocol
                    </button>
                </div>
            </header>

            {/* Features Grid */}
            <section id="features" className="py-40 relative border-t border-white/5 bg-[#080c14]">
                <div className="container mx-auto px-6">
                    <div className="grid md:grid-cols-3 gap-12">
                        {[
                            { title: "Deep Focus Forge", text: "Mathematically optimized work-rest cycles tailored to your cognitive energy levels.", icon: "⚔️" },
                            { title: "Task Ledger", text: "Strategic task planning with priority weighting and session estimation.", icon: "📜" },
                            { title: "Insight Dynamics", text: "Clinical visualization of your focus consistency and streak performance.", icon: "🧬" }
                        ].map((f, i) => (
                            <div key={i} className="group p-12 rounded-[40px] bg-white/[0.02] border border-white/5 hover:bg-white/[0.04] hover:border-[#FF6B35]/20 transition-all duration-500">
                                <div className="text-4xl mb-8 group-hover:scale-125 transition-transform duration-500 origin-left">{f.icon}</div>
                                <h3 className="text-2xl font-black mb-6 tracking-tight">{f.title}</h3>
                                <p className="text-slate-400 leading-relaxed font-medium">{f.text}</p>
                            </div>
                        ))}
                    </div>
                </div>
            </section>

            {/* Science Section */}
            <section id="science" className="py-40 bg-gradient-to-b from-[#080c14] to-[#0F172A]">
                <div className="container mx-auto px-6">
                    <div className="max-w-4xl mx-auto rounded-[60px] p-16 md:p-24 bg-gradient-to-br from-[#FF6B35] to-[#FF8A5B] relative overflow-hidden shadow-2xl shadow-[#FF6B35]/20">
                        <div className="absolute top-0 right-0 p-12 text-[200px] leading-none text-white/10 font-black pointer-events-none">80/20</div>
                        <h2 className="text-4xl md:text-6xl font-black text-white mb-8 tracking-tighter">The Science of The Forge</h2>
                        <p className="text-xl md:text-2xl text-white/90 leading-relaxed font-medium">
                            FocusForge utilizes a refined version of the Pareto Principle combined with Pavlovian stimulus-response conditioning.
                            By associating specific chromatic shifts in the UI with distinct neurological states (Focus vs. Recovery),
                            we shrink the "flow state" entry time by up to 40%.
                        </p>
                    </div>
                </div>
            </section>

            {/* Footer */}
            <footer className="border-t border-white/5 pt-32 pb-16 bg-[#080c14]">
                <div className="container mx-auto px-6">
                    <div className="flex flex-col md:flex-row justify-between items-start gap-16 mb-24">
                        <div className="max-w-sm">
                            <div className="flex items-center gap-3 mb-8">
                                <div className="w-10 h-10 rounded-xl bg-[#FF6B35] flex items-center justify-center font-black text-white text-xl">F</div>
                                <span className="text-2xl font-black tracking-tight">FocusForge</span>
                            </div>
                            <p className="text-slate-500 font-medium">The standard in deep work infrastructure for the elite knowledge worker.</p>
                        </div>
                        <div className="flex flex-wrap gap-20">
                            <div className="flex flex-col gap-6">
                                <span className="text-white font-black text-xs uppercase tracking-widest mb-2">Legal</span>
                                <a href="/privacy" className="text-slate-400 hover:text-white transition-colors">Privacy Policy</a>
                                <a href="/terms" className="text-slate-400 hover:text-white transition-colors">Terms of Service</a>
                                <a href="/deletion" className="text-red-500 hover:text-red-400 transition-colors bg-red-500/5 px-4 py-2 rounded-lg border border-red-500/10">Data Deletion</a>
                            </div>
                            <div className="flex flex-col gap-6">
                                <span className="text-white font-black text-xs uppercase tracking-widest mb-2">Support</span>
                                <a href="mailto:support@focusforge.app" className="text-slate-400 hover:text-white transition-colors">Contact Us</a>
                                <a href="/help" className="text-slate-400 hover:text-white transition-colors">Help Center</a>
                            </div>
                        </div>
                    </div>
                    <div className="flex flex-col md:flex-row justify-between items-center pt-16 border-t border-white/5 text-slate-600 text-xs font-black uppercase tracking-widest">
                        <p>© 2026 FOCUSFORGE PROTOCOL. ALL RIGHTS RESERVED.</p>
                        <p className="mt-4 md:mt-0">TRANSMUTE PROCRASTINATION INTO POWER.</p>
                    </div>
                </div>
            </footer>
        </div>
    );
}
