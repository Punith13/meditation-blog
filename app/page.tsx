import Link from "next/link";
import { getAllPosts } from "@/lib/posts";

export default function Home() {
  const posts = getAllPosts();

  return (
    <div className="min-h-screen bg-background">
      <header className="border-b border-accent-light/20 bg-white/50 backdrop-blur-sm dark:bg-black/50">
        <div className="mx-auto max-w-4xl px-6 py-8">
          <h1 className="font-serif text-4xl font-bold text-accent">Mindful Journeys</h1>
          <p className="mt-2 text-lg text-foreground/70">Exploring consciousness through meditation and reflection</p>
        </div>
      </header>

      <main className="mx-auto max-w-4xl px-6 py-12">
        <div className="space-y-12">
          {posts.map((post) => (
            <article key={post.slug} className="group">
              <Link href={`/posts/${post.slug}`}>
                <div className="space-y-3">
                  <time className="text-sm text-accent">{post.date}</time>
                  <h2 className="font-serif text-3xl font-semibold text-foreground transition-colors group-hover:text-accent">
                    {post.title}
                  </h2>
                  <p className="text-lg leading-relaxed text-foreground/70">{post.excerpt}</p>
                  <span className="inline-block text-sm font-medium text-accent transition-colors group-hover:text-accent-light">
                    Read more →
                  </span>
                </div>
              </Link>
            </article>
          ))}
        </div>
      </main>

      <footer className="mt-20 border-t border-accent-light/20 py-8">
        <div className="mx-auto max-w-4xl px-6 text-center text-sm text-foreground/60">
          <p>© 2025 Mindful Journeys. All rights reserved.</p>
        </div>
      </footer>
    </div>
  );
}
