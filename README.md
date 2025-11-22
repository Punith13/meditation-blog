# Mindful Journeys - Meditation Blog

A serene, meditation-themed blog built with Next.js and designed for deployment to AWS S3.

## Features

- 🧘 Meditation and mindfulness themed design
- 📝 Static blog with pre-written meditation content
- 🎨 Calming color palette with earth tones
- 📱 Fully responsive design
- ⚡ Optimized for static hosting on AWS S3
- 🌙 Dark mode support

## Getting Started

### Prerequisites

- Node.js 18+ and npm
- AWS CLI configured with appropriate credentials
- An S3 bucket configured for static website hosting

### Installation

```bash
npm install
```

### Development

Run the development server:

```bash
npm run dev
```

Open [http://localhost:3000](http://localhost:3000) to view the blog.

### Building for Production

```bash
npm run build
```

This generates a static export in the `out/` directory.

## Deployment to AWS S3

### 1. Create an S3 Bucket

```bash
aws s3 mb s3://your-meditation-blog --region us-east-1
```

### 2. Configure Bucket for Static Website Hosting

```bash
aws s3 website s3://your-meditation-blog \
    --index-document index.html \
    --error-document 404.html
```

### 3. Set Bucket Policy for Public Access

Create a file `bucket-policy.json`:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "PublicReadGetObject",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::your-meditation-blog/*"
    }
  ]
}
```

Apply the policy:

```bash
aws s3api put-bucket-policy \
    --bucket your-meditation-blog \
    --policy file://bucket-policy.json
```

### 4. Deploy Using the Script

Edit `deploy-to-s3.sh` and update the configuration:

```bash
S3_BUCKET="your-meditation-blog"
AWS_REGION="us-east-1"
```

Then run:

```bash
./deploy-to-s3.sh
```

### 5. (Optional) Set Up CloudFront

For better performance and HTTPS support:

```bash
aws cloudfront create-distribution \
    --origin-domain-name your-meditation-blog.s3-website-us-east-1.amazonaws.com \
    --default-root-object index.html
```

Update the `CLOUDFRONT_ID` in `deploy-to-s3.sh` for automatic cache invalidation.

## Project Structure

```
meditation-blog/
├── app/
│   ├── layout.tsx          # Root layout with fonts and metadata
│   ├── page.tsx            # Home page with blog post list
│   ├── globals.css         # Global styles with meditation theme
│   └── posts/
│       └── [slug]/
│           └── page.tsx    # Dynamic post pages
├── content/
│   └── posts/              # Blog posts as markdown files
│       ├── *.md            # Individual blog posts
│       └── README.md       # Guide for adding posts
├── lib/
│   └── posts.ts            # Blog post utilities (reads markdown files)
├── public/                 # Static assets
├── deploy-to-s3.sh        # Deployment script
└── next.config.ts         # Next.js configuration for static export
```

## Customization

### Adding New Posts

Create a new markdown file in `content/posts/`:

```markdown
---
title: "Your Post Title"
date: "Month Day, Year"
excerpt: "A brief description..."
---

# Your Post Title

Your post content goes here with full markdown support.
```

The filename (without `.md`) becomes the URL slug. See `content/posts/README.md` for detailed instructions.

### Changing Colors

Edit the CSS variables in `app/globals.css`:

```css
:root {
  --background: #faf9f7;
  --foreground: #2d2d2d;
  --accent: #8b7355;
  /* ... */
}
```

### Updating Metadata

Edit `app/layout.tsx` to change the site title and description.

## Tech Stack

- **Framework**: Next.js 16 with App Router
- **Styling**: Tailwind CSS 4
- **Fonts**: Lora (serif) and Inter (sans-serif) from Google Fonts
- **Deployment**: AWS S3 + CloudFront (optional)
- **Language**: TypeScript

## License

ISC

## Support

For issues or questions, please open an issue in the repository.

---

*May your code be bug-free and your mind be at peace* 🧘‍♀️
