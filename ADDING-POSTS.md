# Adding New Blog Posts

## Quick Guide

Blog posts are now stored as individual markdown files in `content/posts/`. This makes it easy to manage and add new content without bloating the codebase.

## Step-by-Step

### 1. Create a New Markdown File

Navigate to `content/posts/` and create a new file:

```bash
touch content/posts/my-new-post.md
```

The filename (without `.md`) becomes the URL:
- `my-new-post.md` → `/posts/my-new-post`
- `meditation-tips.md` → `/posts/meditation-tips`

**Naming Rules:**
- Use lowercase letters
- Use hyphens for spaces
- No special characters
- Keep it short and descriptive

### 2. Add Frontmatter

At the top of your markdown file, add frontmatter with three required fields:

```markdown
---
title: "Your Post Title"
date: "November 15, 2025"
excerpt: "A brief description that appears on the home page (1-2 sentences)."
---
```

### 3. Write Your Content

Below the frontmatter, write your post content using markdown:

```markdown
---
title: "My Meditation Journey"
date: "November 15, 2025"
excerpt: "Reflections on my first year of daily meditation practice."
---

# My Meditation Journey

It's been one year since I started meditating daily...

## What I've Learned

Here are the key insights:

- **Consistency matters** more than duration
- The mind naturally wanders—that's okay
- Progress is subtle but profound

## Tips for Beginners

1. Start with just 5 minutes
2. Find a quiet space
3. Be patient with yourself
```

### 4. Markdown Formatting

You can use all standard markdown features:

```markdown
# Heading 1
## Heading 2
### Heading 3

**Bold text**
*Italic text*

- Bullet list
- Another item

1. Numbered list
2. Another item

> Blockquote for emphasis

[Link text](https://example.com)
```

### 5. Preview Locally

```bash
npm run dev
```

Visit http://localhost:3000 to see your new post.

### 6. Build and Deploy

```bash
# Build the static site
npm run build

# Deploy to S3
./deploy-to-s3.sh
```

## Complete Example

Here's a complete example post file:

**File:** `content/posts/breath-awareness.md`

```markdown
---
title: "The Power of Breath Awareness"
date: "November 16, 2025"
excerpt: "Discover how focusing on your breath can transform your meditation practice and daily life."
---

# The Power of Breath Awareness

The breath is always with us, yet we rarely pay attention to it. In meditation, the breath becomes our anchor—a constant point of return when the mind wanders.

## Why the Breath?

The breath has several qualities that make it ideal for meditation:

- **Always present**: You can't forget to bring it to your practice
- **Neutral**: It doesn't trigger strong emotions
- **Rhythmic**: Its natural pattern is calming
- **Accessible**: No special equipment needed

## Basic Breath Awareness Practice

1. **Sit comfortably** with your spine upright
2. **Close your eyes** or soften your gaze
3. **Notice your breath** without changing it
4. **Feel the sensations** of breathing
5. **When your mind wanders**, gently return to the breath

## Beyond the Cushion

Breath awareness isn't just for meditation. Throughout your day:

- Take three conscious breaths before important meetings
- Notice your breath when feeling stressed
- Use breath as a reminder to return to the present moment

## Deepening the Practice

As you become more familiar with breath awareness, you might notice:

- Subtle changes in breath quality
- The space between breaths
- How emotions affect breathing patterns
- The calming effect of simply observing

Remember: there's no "perfect" way to breathe in meditation. The practice is simply to notice, without judgment, whatever is happening.

*May your breath guide you home to the present moment.*
```

## Tips for Great Posts

### Content
- Write from personal experience when possible
- Keep paragraphs short (3-4 sentences)
- Use subheadings to break up long posts
- Include practical exercises or tips
- End with a reflection or call to action

### Style
- Use a calm, contemplative tone
- Avoid jargon unless you explain it
- Write in second person ("you") to engage readers
- Use metaphors and imagery related to nature, space, or stillness

### Length
- Aim for 500-1500 words
- Quality over quantity
- Each post should have one clear focus

## Troubleshooting

### Post doesn't appear
- Check that the file ends with `.md`
- Verify frontmatter is properly formatted
- Make sure the file is in `content/posts/`
- Rebuild: `npm run build`

### Formatting looks wrong
- Check markdown syntax
- Ensure there's a blank line after frontmatter (`---`)
- Test locally with `npm run dev`

### Date sorting is wrong
- Use consistent date format: "Month Day, Year"
- Example: "November 15, 2025"

## Need Help?

See `content/posts/README.md` for a quick reference, or check the existing post files for examples.

---

Happy writing! 🧘‍♀️
