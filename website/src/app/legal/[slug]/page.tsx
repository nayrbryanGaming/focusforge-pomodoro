import fs from 'fs';
import path from 'path';
import ReactMarkdown from 'react-markdown';
import remarkGfm from 'remark-gfm';
import { notFound } from 'next/navigation';

interface Props {
  params: Promise<{
    slug: string;
  }>;
}

const slugToFileName: Record<string, string> = {
  'privacy-policy': 'privacy_policy.md',
  'terms-of-service': 'terms_of_service.md',
  'data-usage': 'data_usage_policy.md',
  'disclaimer': 'disclaimer.md',
};

export default async function LegalPage({ params }: Props) {
  const { slug } = await params;
  const fileName = slugToFileName[slug];

  if (!fileName) {
    notFound();
  }

  const filePath = path.join(process.cwd(), 'src/legal-content', fileName);
  
  if (!fs.existsSync(filePath)) {
    notFound();
  }

  const content = fs.readFileSync(filePath, 'utf8');

  return (
    <div className="min-h-screen bg-[#0F172A] text-slate-200 font-sans selection:bg-[#FF6B35] selection:text-white pb-24">
      {/* Mini Nav */}
      <nav className="border-b border-slate-800 py-6 bg-slate-900/50 backdrop-blur-md sticky top-0 z-50">
        <div className="container mx-auto px-6 flex justify-between items-center">
          <a href="/" className="flex items-center gap-2 group">
            <div className="w-8 h-8 rounded-lg bg-gradient-to-br from-[#FF6B35] to-[#FFD166] flex items-center justify-center font-bold text-white text-sm">FF</div>
            <span className="text-xl font-bold tracking-tight group-hover:text-white transition-colors">FocusForge</span>
          </a>
          <a href="/" className="text-slate-400 hover:text-white transition-colors font-medium">Back to Home</a>
        </div>
      </nav>

      <main className="container mx-auto px-6 pt-16 max-w-4xl">
        <div className="prose prose-invert prose-slate max-w-none 
          prose-headings:text-white prose-headings:font-bold prose-headings:tracking-tight
          prose-h1:text-4xl prose-h1:mb-8 prose-h1:bg-gradient-to-r prose-h1:from-[#FF6B35] prose-h1:to-[#FFD166] prose-h1:bg-clip-text prose-h1:text-transparent
          prose-p:text-slate-400 prose-p:leading-relaxed prose-p:mb-6
          prose-li:text-slate-400 prose-li:mb-2
          prose-strong:text-white
          prose-hr:border-slate-800 prose-hr:my-12
          prose-table:border prose-table:border-slate-800 prose-table:rounded-xl
          prose-th:bg-slate-900 prose-th:p-4 prose-th:text-white
          prose-td:p-4 prose-td:border-t prose-td:border-slate-800
        ">
          <ReactMarkdown remarkPlugins={[remarkGfm]}>
            {content}
          </ReactMarkdown>
        </div>
      </main>

      <footer className="mt-24 border-t border-slate-800 py-12 text-center text-slate-500 text-sm">
        <div className="container mx-auto px-6">
          <p>© 2026 FocusForge. Built for unstoppable productivity.</p>
        </div>
      </footer>
    </div>
  );
}
