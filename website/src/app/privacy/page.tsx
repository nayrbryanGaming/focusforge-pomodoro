import Link from 'next/link';

export default function PrivacyPolicy() {
  return (
    <div className="min-h-screen bg-[#0F172A] text-slate-300 font-sans py-20">
      <div className="container mx-auto px-6 max-w-4xl">
        <Link href="/" className="text-[#FF6B35] hover:text-[#FFA573] transition-colors mb-12 inline-block font-bold items-center gap-2">
          ← Back to FocusForge
        </Link>
        <h1 className="text-4xl md:text-6xl font-black text-white mb-8 tracking-tight">Privacy Policy</h1>
        <p className="text-lg mb-12 text-slate-400 font-medium">Last Updated: April 11, 2026</p>

        <div className="prose prose-invert prose-orange max-w-none space-y-12">
          <section>
            <h2 className="text-2xl font-bold text-white mb-4">1. Introduction</h2>
            <p className="leading-relaxed">
              Welcome to <strong>FocusForge</strong> ("the App", "we", "us", or "our"). This Privacy Policy describes how FocusForge collects, uses, discloses, and safeguards your information when you use our mobile application and related services.
              By using FocusForge, you agree to the collection and use of information in accordance with this policy.
            </p>
          </section>

          <section>
            <h2 className="text-2xl font-bold text-white mb-4">2. Information We Collect</h2>
            <div className="bg-slate-900/50 rounded-2xl p-6 border border-slate-800">
              <h3 className="text-lg font-semibold text-[#FF6B35] mb-4">Data You Provide</h3>
              <ul className="list-disc pl-6 space-y-2">
                <li>Email address for account creation and synchronization.</li>
                <li>Display name and optional profile photo for personalization.</li>
                <li>Tasks, categories, and focus session data created within the app.</li>
              </ul>
            </div>
          </section>

          <section>
            <h2 className="text-2xl font-bold text-white mb-4">3. Data Security & Storage</h2>
            <p className="leading-relaxed">
              We take the security of your focus data seriously. All information is stored using <strong>Google Firebase</strong> infrastructure, benefiting from industry-leading physical and digital security measures. 
              Data is encrypted in transit using TLS 1.3 and at rest using AES-256 encryption.
            </p>
          </section>

          <section>
            <h2 className="text-2xl font-bold text-white mb-4">4. Account Deletion & Data Rights</h2>
            <div className="bg-red-900/10 border border-red-900/30 rounded-2xl p-6">
              <p className="leading-relaxed mb-4">
                You have the absolute right to delete your account and all associated data at any time.
              </p>
              <ul className="list-disc pl-6 space-y-2">
                <li><strong>In-App:</strong> Profile → Settings → Delete Account</li>
                <li><strong>Web Request:</strong> Visit our <Link href="/deletion" className="text-red-400 underline font-bold">Deletion Request Page</Link></li>
              </ul>
            </div>
          </section>

          <section className="border-t border-slate-800 pt-12">
            <h2 className="text-2xl font-bold text-white mb-4">Contact Us</h2>
            <p className="leading-relaxed">
              If you have any questions about this Privacy Policy, please reach out to our team at:<br />
              <strong className="text-white">support@focusforge.app</strong>
            </p>
          </section>
        </div>
      </div>
    </div>
  );
}
