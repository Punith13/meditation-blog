# Changelog

## Refactored to Markdown-Based Content (Latest)

### What Changed
- **Blog posts are now individual markdown files** instead of being hardcoded in `posts.ts`
- Posts are stored in `content/posts/` directory
- Each post has frontmatter (title, date, excerpt) and markdown content
- Added `gray-matter` package for parsing markdown frontmatter

### Benefits
- ✅ **Easier to manage**: Each post is a separate file
- ✅ **No code bloat**: `posts.ts` is now just utility functions
- ✅ **Better organization**: All content in one place
- ✅ **Simpler editing**: Just edit markdown, no TypeScript knowledge needed
- ✅ **Version control friendly**: Easy to see changes in git diffs

### File Structure
```
content/
└── posts/
    ├── beginning-meditation-journey.md
    ├── exploring-consciousness.md
    ├── mindfulness-daily-life.md
    ├── we-are-what-we-think.md
    └── README.md (guide for adding posts)
```

### How to Add Posts Now
1. Create a new `.md` file in `content/posts/`
2. Add frontmatter with title, date, and excerpt
3. Write your content in markdown
4. Build and deploy

See `ADDING-POSTS.md` for detailed instructions.

### Migration Notes
- All existing posts have been converted to markdown
- The `posts.ts` file now reads from markdown files
- No changes needed to the app structure or pages
- Build and deployment process remains the same

### New Files
- `content/posts/*.md` - Individual blog posts
- `content/posts/README.md` - Quick guide for adding posts
- `ADDING-POSTS.md` - Comprehensive guide for content creation

### Updated Files
- `lib/posts.ts` - Now reads from markdown files
- `README.md` - Updated project structure
- `QUICKSTART.md` - Updated with new content management info
- `package.json` - Added `gray-matter` dependency

---

## Initial Release

### Features
- Next.js 16 blog with App Router
- Meditation and mind exploration theme
- 4 pre-written blog posts
- Static site generation for S3 deployment
- Responsive design with dark mode
- TypeScript + Tailwind CSS
- Deployment scripts and documentation
