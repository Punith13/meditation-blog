#!/bin/bash

# Meditation Blog - AWS S3 Deployment Script
# This script builds and deploys your Next.js blog to AWS S3

# Configuration - Update these values
S3_BUCKET="your-bucket-name"
AWS_REGION="us-east-1"
CLOUDFRONT_ID="" # Optional: Add CloudFront distribution ID for cache invalidation

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}🧘 Building Meditation Blog...${NC}"

# Build the Next.js app
npm run build

if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Build failed${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Build successful${NC}"
echo -e "${BLUE}📦 Deploying to S3...${NC}"

# Sync to S3
aws s3 sync out/ s3://${S3_BUCKET}/ \
    --delete \
    --cache-control "public, max-age=31536000, immutable" \
    --exclude "*.html" \
    --region ${AWS_REGION}

# Upload HTML files with different cache settings
aws s3 sync out/ s3://${S3_BUCKET}/ \
    --delete \
    --cache-control "public, max-age=0, must-revalidate" \
    --exclude "*" \
    --include "*.html" \
    --region ${AWS_REGION}

if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Deployment failed${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Deployed to S3${NC}"

# Optional: Invalidate CloudFront cache
if [ ! -z "$CLOUDFRONT_ID" ]; then
    echo -e "${BLUE}🔄 Invalidating CloudFront cache...${NC}"
    aws cloudfront create-invalidation \
        --distribution-id ${CLOUDFRONT_ID} \
        --paths "/*"
    echo -e "${GREEN}✅ CloudFront cache invalidated${NC}"
fi

echo -e "${GREEN}🎉 Deployment complete!${NC}"
