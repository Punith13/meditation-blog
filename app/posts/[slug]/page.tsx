import Link from "next/link";
import { getPostBySlug, getAllPosts } from "@/lib/posts";
import { notFound } from "next/navigation";
import ReactMarkdown from "react-markdown";
import remarkGfm from "remark-gfm";

export async function generateStaticParams() {
  const posts = getAllPosts();
  return posts.map((post) => ({
    slug: post.slug,
  }));
}

export default async function PostPage({ params }: { params: Promise<{ slug: string }> }) {
  const { slug } = await params;
  const post = getPostBySlug(slug);

  if (!post) {
    notFound();
  }

  return (
    <div className="min-h-screen bg-background">
      <header className="border-b border-accent-light/20 bg-white/50 backdrop-blur-sm dark:bg-black/50">
        <div className="mx-auto max-w-4xl px-6 py-6">
          <Link href="/" className="text-accent hover:text-accent-light transition-colors">
            ← Back to all posts
          </Link>
        </div>
      </header>

      <article className="mx-auto max-w-3xl px-6 py-12">
        <header className="mb-12 space-y-4">
          <time className="text-sm text-accent">{post.date}</time>
          <h1 className="font-serif text-5xl font-bold text-foreground">{post.title}</h1>
        </header>

        <div className="prose prose-lg prose-stone dark:prose-invert max-w-none markdown-content">
          <ReactMarkdown remarkPlugins={[remarkGfm]}>
            {post.content}
          </ReactMarkdown>
        </div>
      </article>

      <footer className="mt-20 border-t border-accent-light/20 py-8">
        <div className="mx-auto max-w-4xl px-6 text-center text-sm text-foreground/60">
          <p>© 2025 Mindful Journeys. All rights reserved.</p>
        </div>
      </footer>
    </div>
  );
}
