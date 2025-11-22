import Link from "next/link";

export default function NotFound() {
  return (
    <div className="flex min-h-screen flex-col items-center justify-center bg-background px-6">
      <div className="text-center space-y-6">
        <h1 className="font-serif text-6xl font-bold text-accent">404</h1>
        <h2 className="font-serif text-3xl font-semibold text-foreground">
          Lost in Thought
        </h2>
        <p className="text-lg text-foreground/70 max-w-md">
          Like a wandering mind during meditation, this page seems to have drifted away.
          Let's gently bring you back to the present.
        </p>
        <Link
          href="/"
          className="inline-block rounded-full bg-accent px-8 py-3 text-white transition-colors hover:bg-accent-light"
        >
          Return Home
        </Link>
      </div>
    </div>
  );
}
