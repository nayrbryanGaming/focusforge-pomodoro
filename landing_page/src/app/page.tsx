"use client";

import React from 'react';
import { motion } from 'framer-motion';
import { 
  Zap, 
  ShieldCheck, 
  WifiOff, 
  BarChart3, 
  Smartphone, 
  Globe, 
  Scale, 
  Code2,
  Download,
  ExternalLink,
  ChevronRight,
  Target
} from 'lucide-react';

export default function LandingPage() {
  const fadeIn = {
    initial: { opacity: 0, y: 20 },
    animate: { opacity: 1, y: 0 },
    transition: { duration: 0.6 }
  };

  return (
    <main className="min-h-screen bg-[#0f172a] text-white selection:bg-orange-500/30">
      <div className="bg-mesh" />

      {/* Navigation */}
      <nav className="fixed top-0 w-full z-50 border-b border-white/5 bg-[#0f172a]/50 backdrop-blur-xl">
        <div className="max-w-7xl mx-auto px-6 h-20 flex items-center justify-between">
          <div className="flex items-center gap-3">
            <div className="w-10 h-10 forge-gradient rounded-xl flex items-center justify-center shadow-lg shadow-orange-500/20">
              <Zap className="w-6 h-6 text-white" />
            </div>
            <span className="text-xl font-black tracking-tighter uppercase">FocusForge</span>
          </div>
          <div className="hidden md:flex items-center gap-8 text-sm font-bold text-slate-400">
            <a href="#features" className="hover:text-orange-500 transition-colors">FEATURES</a>
            <a href="#technical" className="hover:text-orange-500 transition-colors">TECHNICAL EVIDENCE</a>
            <a href="#compliance" className="hover:text-orange-500 transition-colors">COMPLIANCE</a>
          </div>
          <button className="px-6 py-2.5 rounded-full forge-gradient text-sm font-black shadow-lg shadow-orange-500/20 hover:scale-105 transition-transform">
            DOWNLOAD APK
          </button>
        </div>
      </nav>

      {/* Hero Section */}
      <section className="relative pt-40 pb-24 px-6">
        <div className="max-w-7xl mx-auto text-center">
          <motion.div 
            initial={{ opacity: 0, scale: 0.9 }}
            animate={{ opacity: 1, scale: 1 }}
            className="inline-flex items-center gap-2 px-4 py-2 rounded-full bg-orange-500/10 border border-orange-500/20 text-orange-500 text-xs font-black tracking-widest mb-8"
          >
            <ShieldCheck className="w-4 h-4" />
            v1.3.1 STABLE VERSION
          </motion.div>
          
          <motion.h1 
            {...fadeIn}
            className="text-6xl md:text-8xl font-black tracking-tighter mb-8 leading-[0.9]"
          >
            THE ULTIMATE <br />
            <span className="text-transparent bg-clip-text forge-gradient">FOCUS SYSTEM</span>
          </motion.h1>
          
          <motion.p 
            {...fadeIn}
            transition={{ delay: 0.2 }}
            className="max-w-2xl mx-auto text-lg text-slate-400 font-medium mb-12"
          >
            Experience a 100% Offline-First productivity environment. Zero tracking. 
            Zero cloud dependencies. Pure local data sovereignty for professional forgers.
          </motion.p>

          <motion.div 
            {...fadeIn}
            transition={{ delay: 0.3 }}
            className="flex flex-col sm:flex-row items-center justify-center gap-6"
          >
            <button className="group relative px-8 py-4 rounded-2xl forge-gradient text-lg font-black flex items-center gap-3 shadow-2xl shadow-orange-500/30 hover:scale-105 transition-all">
              <Download className="w-6 h-6" />
              GET LATEST APK
              <div className="absolute inset-0 rounded-2xl bg-white/20 opacity-0 group-hover:opacity-100 transition-opacity" />
            </button>
            <button className="px-8 py-4 rounded-2xl glass text-lg font-black flex items-center gap-3 hover:bg-white/5 transition-all">
              <Code2 className="w-6 h-6" />
              VIEW REPOSITORY
            </button>
          </motion.div>
        </div>
      </section>

      {/* Core Features */}
      <section id="features" className="py-24 px-6">
        <div className="max-w-7xl mx-auto">
          <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
            <FeatureCard 
              icon={<WifiOff className="w-8 h-8" />}
              title="100% Offline Engine"
              desc="Operating in complete isolation from the internet. Zero data transmission to any external server."
            />
            <FeatureCard 
              icon={<Smartphone className="w-8 h-8" />}
              title="Local Sovereignty"
              desc="All productivity data persists strictly within your local SQLite database. You own your time."
            />
            <FeatureCard 
              icon={<Scale className="w-8 h-8" />}
              title="Production Hardened"
              desc="Clinically audited source code with all placeholders and network hooks purged for compliance."
            />
          </div>
        </div>
      </section>

      {/* Technical Evidence Showcase */}
      <section id="technical" className="py-24 px-6 relative overflow-hidden">
        <div className="absolute top-0 left-1/2 -translate-x-1/2 w-[800px] h-[800px] bg-orange-500/5 blur-[120px] rounded-full" />
        
        <div className="max-w-7xl mx-auto relative z-10">
          <div className="flex flex-col md:flex-row items-end justify-between mb-16 gap-8">
            <div className="max-w-2xl">
              <h2 className="text-4xl md:text-5xl font-black tracking-tighter mb-6">TECHNICAL SPECIFICATIONS</h2>
              <p className="text-slate-400 font-medium">
                Our architecture is fully auditable. We provide a 
                Offline-First implementation through strict code standards.
              </p>
            </div>
            <div className="flex gap-4">
              <div className="px-6 py-3 rounded-2xl glass flex items-center gap-3">
                <BarChart3 className="w-5 h-5 text-orange-500" />
                <span className="text-sm font-bold">SQLITE 3.X READY</span>
              </div>
              <div className="px-6 py-3 rounded-2xl glass flex items-center gap-3">
                <Smartphone className="w-5 h-5 text-indigo-400" />
                <span className="text-sm font-bold">FLUTTER 3.22.X</span>
              </div>
            </div>
          </div>

          <div className="grid grid-cols-1 lg:grid-cols-2 gap-8">
            <EvidenceCard 
              title="Offline Services Layer"
              desc="Refactored services to depend exclusively on local SQLite streams, removing all cloud dependencies."
              tag="ARCHITECTURE"
            />
            <EvidenceCard 
              title="Localization Sovereignty"
              desc="Implementation of L10nService providing zero-mixed English and Indonesian translations via local-only state management."
              tag="LOCALIZATION"
            />
            <EvidenceCard 
              title="Purged Dependency Tree"
              desc="Sanitization of dependency tree to eliminate all cloud-bound SDKs, ensuring 100% binary isolation."
              tag="SECURITY"
            />
            <EvidenceCard 
              title="Accessibility Standards"
              desc="Validated high-contrast UI system (Contrast Ratio 7.1:1+) for professional-grade readability and accessibility compliance."
              tag="UI/UX"
            />
          </div>
        </div>
      </section>

      {/* Footer / Compliance */}
      <footer id="compliance" className="py-24 px-6 border-t border-white/5">
        <div className="max-w-7xl mx-auto">
          <div className="grid grid-cols-1 md:grid-cols-4 gap-12 mb-16">
            <div className="col-span-1 md:col-span-2">
              <div className="flex items-center gap-3 mb-8">
                <div className="w-8 h-8 forge-gradient rounded-lg flex items-center justify-center">
                  <Zap className="w-5 h-5 text-white" />
                </div>
                <span className="text-lg font-black tracking-tighter uppercase">FocusForge</span>
              </div>
              <p className="text-slate-400 font-medium max-w-sm mb-8">
                is a sacred asset that should never be monitored or tracked.
              </p>
              <div className="flex gap-4">
                <div className="w-10 h-10 glass rounded-full flex items-center justify-center hover:text-orange-500 transition-colors">
                  <Globe className="w-5 h-5" />
                </div>
                <div className="w-10 h-10 glass rounded-full flex items-center justify-center hover:text-orange-500 transition-colors">
                  <ExternalLink className="w-5 h-5" />
                </div>
              </div>
            </div>
            <div>
              <h4 className="text-sm font-black mb-8 tracking-widest text-orange-500">LEGAL DOCUMENTS</h4>
              <ul className="space-y-4 text-slate-400 font-bold text-sm">
                <li><a href="#" className="hover:text-white transition-colors">PRIVACY POLICY</a></li>
                <li><a href="#" className="hover:text-white transition-colors">TERMS OF SERVICE</a></li>
                <li><a href="#" className="hover:text-white transition-colors">DATA USAGE</a></li>
                <li><a href="#" className="hover:text-white transition-colors">REFUND POLICY</a></li>
              </ul>
            </div>
            <div>
              <h4 className="text-sm font-black mb-8 tracking-widest text-orange-500">DEVELOPER</h4>
              <ul className="space-y-4 text-slate-400 font-bold text-sm">
                <li><a href="#" className="hover:text-white transition-colors">REPOSITORY</a></li>
                <li><a href="#" className="hover:text-white transition-colors">DOCUMENTATION</a></li>
                <li><a href="#" className="hover:text-white transition-colors">RELEASE NOTES</a></li>
                <li><a href="#" className="hover:text-white transition-colors">AUDIT LOGS</a></li>
              </ul>
            </div>
          </div>
          <div className="pt-12 border-t border-white/5 flex flex-col md:row items-center justify-between gap-6 text-xs font-black tracking-widest text-slate-500">
            <span>© 2026 FOCUSFORGE PROTOCOL. ALL RIGHTS RESERVED.</span>
            <div className="flex gap-8">
              <span>FORGED BY NAYRBRYANGAMING</span>
              <span>18TH SUBMISSION EDITION</span>
            </div>
          </div>
        </div>
      </footer>
    </main>
  );
}

function FeatureCard({ icon, title, desc }: { icon: React.ReactNode, title: string, desc: string }) {
  return (
    <div className="p-10 rounded-[40px] glass hover:bg-white/5 transition-colors group">
      <div className="w-16 h-16 rounded-2xl bg-orange-500/10 flex items-center justify-center mb-8 text-orange-500 group-hover:scale-110 transition-transform">
        {icon}
      </div>
      <h3 className="text-2xl font-black tracking-tight mb-4">{title}</h3>
      <p className="text-slate-400 font-medium leading-relaxed">{desc}</p>
    </div>
  );
}

function EvidenceCard({ title, desc, tag }: { title: string, desc: string, tag: string }) {
  return (
    <div className="p-8 rounded-3xl bg-white/2 shadow-xl border border-white/5 hover:border-orange-500/30 transition-all group">
      <div className="flex items-center justify-between mb-6">
        <span className="text-[10px] font-black tracking-[0.2em] text-orange-500 px-3 py-1 rounded-full bg-orange-500/10">
          {tag}
        </span>
        <Target className="w-5 h-5 text-white/10 group-hover:text-orange-500/50 transition-colors" />
      </div>
      <h3 className="text-xl font-black mb-4 flex items-center gap-2">
        {title}
        <ChevronRight className="w-5 h-5 text-orange-500 opacity-0 group-hover:opacity-100 -translate-x-2 group-hover:translate-x-0 transition-all" />
      </h3>
      <p className="text-slate-400 text-sm font-medium leading-relaxed">
        {desc}
      </p>
    </div>
  );
}
