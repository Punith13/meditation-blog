# AWS S3 Deployment Guide

## Quick Start

### Step 1: Install Dependencies

```bash
cd meditation-blog
npm install
```

### Step 2: Test Locally

```bash
npm run dev
```

Visit http://localhost:3000 to preview your blog.

### Step 3: Build Static Site

```bash
npm run build
```

This creates an `out/` directory with your static files.

## AWS S3 Setup

### Prerequisites

1. AWS Account
2. AWS CLI installed and configured:
   ```bash
   aws configure
   ```

### Create and Configure S3 Bucket

```bash
# 1. Create bucket (replace with your bucket name)
aws s3 mb s3://mindful-journeys-blog --region us-east-1

# 2. Enable static website hosting
aws s3 website s3://mindful-journeys-blog \
    --index-document index.html \
    --error-document 404.html

# 3. Update bucket-policy.json with your bucket name
# Then apply the policy:
aws s3api put-bucket-policy \
    --bucket mindful-journeys-blog \
    --policy file://bucket-policy.json

# 4. Disable block public access (required for public website)
aws s3api put-public-access-block \
    --bucket mindful-journeys-blog \
    --public-access-block-configuration \
    "BlockPublicAcls=false,IgnorePublicAcls=false,BlockPublicPolicy=false,RestrictPublicBuckets=false"
```

### Deploy

```bash
# 1. Update deploy-to-s3.sh with your bucket name
# 2. Run deployment script
./deploy-to-s3.sh
```

Your site will be available at:
```
http://mindful-journeys-blog.s3-website-us-east-1.amazonaws.com
```

## Optional: CloudFront Setup (Recommended)

CloudFront provides:
- HTTPS support
- Custom domain names
- Better performance with CDN
- Lower costs for high traffic

### Create CloudFront Distribution

```bash
aws cloudfront create-distribution \
    --origin-domain-name mindful-journeys-blog.s3.us-east-1.amazonaws.com \
    --default-root-object index.html
```

Or use the AWS Console:
1. Go to CloudFront
2. Create Distribution
3. Origin Domain: Select your S3 bucket
4. Origin Access: Public
5. Default Root Object: index.html
6. Create Distribution

### Custom Domain (Optional)

1. In Route 53, create a hosted zone for your domain
2. Add an A record (Alias) pointing to your CloudFront distribution
3. In CloudFront, add your domain as an alternate domain name (CNAME)
4. Request an SSL certificate in ACM (us-east-1 region)
5. Attach the certificate to your CloudFront distribution

## Costs

Typical monthly costs for a small blog:
- S3 Storage: ~$0.023 per GB
- S3 Requests: ~$0.0004 per 1,000 requests
- CloudFront: First 1TB free tier, then ~$0.085 per GB
- Route 53 (if using custom domain): $0.50 per hosted zone

For a blog with 1,000 visitors/month: **~$1-5/month**

## Troubleshooting

### 403 Forbidden Error
- Check bucket policy is applied correctly
- Verify public access is not blocked
- Ensure files are in the bucket

### 404 Errors on Refresh
- Verify error document is set to 404.html
- For CloudFront, configure custom error responses

### Build Fails
```bash
# Clear cache and reinstall
rm -rf node_modules .next out
npm install
npm run build
```

## Updating Content

1. Edit posts in `lib/posts.ts`
2. Build: `npm run build`
3. Deploy: `./deploy-to-s3.sh`

That's it! Your changes are live.
