# Quick Start Guide

## 🚀 Get Running in 3 Minutes

### 1. Install & Run

```bash
cd meditation-blog
npm install
npm run dev
```

Open http://localhost:3000 - your meditation blog is live locally!

### 2. Customize Content

Edit `lib/posts.ts` to add your own meditation posts:

```typescript
{
  slug: "my-meditation-practice",
  title: "My Meditation Practice",
  date: "November 15, 2025",
  excerpt: "Sharing my journey...",
  content: `Your full post content here...`
}
```

### 3. Deploy to AWS S3

```bash
# Build the static site
npm run build

# Update deploy-to-s3.sh with your bucket name
# Then deploy
./deploy-to-s3.sh
```

## 📝 What You Get

- ✅ 4 pre-written meditation blog posts
- ✅ Markdown-based content management
- ✅ Beautiful, calming design with earth tones
- ✅ Fully responsive (mobile, tablet, desktop)
- ✅ Dark mode support
- ✅ SEO optimized
- ✅ Ready for S3 deployment
- ✅ TypeScript + Tailwind CSS

## 🎨 Theme Colors

The blog uses a calming meditation palette:
- Warm beige background (#faf9f7)
- Earth brown accent (#8b7355)
- Calm blue highlights (#a8c5dd)
- Sage green accents (#9caf88)

## 📚 Key Files

- `content/posts/*.md` - Blog posts (add yours here!)
- `app/page.tsx` - Home page with post list
- `app/posts/[slug]/page.tsx` - Individual post pages
- `lib/posts.ts` - Post utilities (reads markdown files)
- `app/globals.css` - Theme colors and styles
- `deploy-to-s3.sh` - Deployment script

## 🔧 Common Tasks

### Add a new post
Create a new `.md` file in `content/posts/` (see `ADDING-POSTS.md`)

### Change colors
Edit CSS variables in `app/globals.css`

### Update site title
Edit metadata in `app/layout.tsx`

### Deploy updates
```bash
npm run build && ./deploy-to-s3.sh
```

## 💡 Need Help?

- Full deployment guide: See `DEPLOYMENT.md`
- Project details: See `README.md`
- AWS setup: See `DEPLOYMENT.md`

---

*Happy blogging! 🧘*
