import type { Metadata } from "next";
import { Geist, Geist_Mono } from "next/font/google";
import "./globals.css";

const geistSans = Geist({
  variable: "--font-geist-sans",
  subsets: ["latin"],
});

const geistMono = Geist_Mono({
  variable: "--font-geist-mono",
  subsets: ["latin"],
});

export const metadata: Metadata = {
  title: "FocusForge | Deep Focus & Habit System",
  description: "Forge unbreakable deep work habits with structured Pomodoro sessions, task management, and powerful productivity analytics.",
  keywords: ["pomodoro", "productivity", "focus", "deep work", "habit tracker", "flutter", "firebase"],
  authors: [{ name: "FocusForge Team" }],
  openGraph: {
    title: "FocusForge | Deep Focus System",
    description: "The ultimate focus habit system for knowledge workers.",
    url: "https://focusforge.app",
    siteName: "FocusForge",
    images: [{ url: "/og-image.png", width: 1200, height: 630 }],
    locale: "en_US",
    type: "website",
  },
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html
      lang="en"
      className={`${geistSans.variable} ${geistMono.variable} h-full antialiased`}
    >
      <body className="min-h-full flex flex-col">{children}</body>
    </html>
  );
}
