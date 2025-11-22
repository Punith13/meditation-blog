import type { Metadata } from "next";
import { Lato, Quicksand } from "next/font/google";
import "./globals.css";

const lato = Lato({
  variable: "--font-lato",
  subsets: ["latin"],
  weight: ["300", "400", "700"],
  display: "swap",
});

const quicksand = Quicksand({
  variable: "--font-quicksand",
  subsets: ["latin"],
  weight: ["400", "500", "600", "700"],
  display: "swap",
});

export const metadata: Metadata = {
  title: "Mindful Journeys - Meditation & Mind Exploration",
  description: "Explore the depths of consciousness through meditation, mindfulness, and inner reflection",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en">
      <body
        className={`${lato.variable} ${quicksand.variable} antialiased`}
      >
        {children}
      </body>
    </html>
  );
}
