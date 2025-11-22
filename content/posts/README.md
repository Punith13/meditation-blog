# Blog Posts

This directory contains all blog posts as individual markdown files.

## Adding a New Post

1. Create a new `.md` file in this directory with a URL-friendly filename (e.g., `my-new-post.md`)
2. Add frontmatter at the top with the required fields:

```markdown
---
title: "Your Post Title"
date: "Month Day, Year"
excerpt: "A brief description of your post that appears on the home page."
---

# Your Post Title

Your post content goes here. You can use markdown formatting:

## Headings

- Lists
- **Bold text**
- *Italic text*

And more!
```

## Required Frontmatter Fields

- `title`: The post title (displayed on home page and post page)
- `date`: Publication date (used for sorting posts)
- `excerpt`: Short description (displayed on home page)

## File Naming

The filename (without `.md`) becomes the URL slug:
- `my-meditation-practice.md` → `/posts/my-meditation-practice`
- `beginning-journey.md` → `/posts/beginning-journey`

Use lowercase letters, numbers, and hyphens only.

## Example Post

See any of the existing `.md` files in this directory for examples.

## After Adding a Post

1. The post will automatically appear on the home page
2. It will be sorted by date (newest first)
3. Rebuild the site: `npm run build`
4. Deploy: `./deploy-to-s3.sh`
