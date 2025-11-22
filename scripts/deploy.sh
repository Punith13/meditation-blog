#!/bin/bash

# Deployment script for Mindful Journeys meditation blog
# This script builds the Next.js static export and prepares for S3 upload

set -e  # Exit on any error

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Default values
AWS_PROFILE=""
AWS_REGION="us-east-1"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
CDK_DIR="$PROJECT_ROOT/cdk"

# Parse command line arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    --profile)
      AWS_PROFILE="$2"
      shift 2
      ;;
    --region)
      AWS_REGION="$2"
      shift 2
      ;;
    -h|--help)
      echo "Usage: $0 [--profile AWS_PROFILE] [--region AWS_REGION]"
      echo ""
      echo "Options:"
      echo "  --profile  AWS CLI profile to use (optional)"
      echo "  --region   AWS region (default: us-east-1)"
      echo "  -h, --help Show this help message"
      exit 0
      ;;
    *)
      echo -e "${RED}Error: Unknown option $1${NC}"
      echo "Use --help for usage information"
      exit 1
      ;;
  esac
done

# Build AWS CLI command prefix with optional profile
AWS_CMD="aws"
if [ -n "$AWS_PROFILE" ]; then
  AWS_CMD="aws --profile $AWS_PROFILE"
  echo -e "${YELLOW}Using AWS profile: $AWS_PROFILE${NC}"
fi
AWS_CMD="$AWS_CMD --region $AWS_REGION"

echo ""
echo -e "${BOLD}${CYAN}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BOLD}${CYAN}║     Mindful Journeys Blog - AWS Deployment Script         ║${NC}"
echo -e "${BOLD}${CYAN}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Step 1: Build the Next.js static export
echo -e "${BOLD}${BLUE}[1/4] Building Next.js static export...${NC}"
cd "$PROJECT_ROOT"

if npm run build; then
  echo ""
  echo -e "${BOLD}${GREEN}✓ Build Status: SUCCESS${NC}"
  echo -e "${GREEN}  Next.js static export generated in out/ directory${NC}"
else
  echo ""
  echo -e "${BOLD}${RED}✗ Build Status: FAILED${NC}"
  echo -e "${RED}  Please fix the build errors and try again${NC}"
  exit 1
fi

echo ""

# Step 2: Get CDK stack outputs
echo -e "${BOLD}${BLUE}[2/4] Retrieving CDK stack outputs...${NC}"
cd "$CDK_DIR"

# Check if CDK stack is deployed
if ! $AWS_CMD cloudformation describe-stacks --stack-name MeditationBlogStack &> /dev/null; then
  echo -e "${RED}✗ CDK stack 'MeditationBlogStack' not found${NC}"
  echo -e "${YELLOW}Please deploy the CDK stack first:${NC}"
  echo -e "  cd $CDK_DIR"
  echo -e "  cdk deploy"
  exit 1
fi

# Parse CDK outputs
STACK_OUTPUTS=$($AWS_CMD cloudformation describe-stacks \
  --stack-name MeditationBlogStack \
  --query 'Stacks[0].Outputs' \
  --output json)

S3_BUCKET=$(echo "$STACK_OUTPUTS" | grep -A 1 '"OutputKey": "BucketName"' | grep '"OutputValue"' | sed 's/.*"OutputValue": "\(.*\)".*/\1/')
CLOUDFRONT_ID=$(echo "$STACK_OUTPUTS" | grep -A 1 '"OutputKey": "DistributionId"' | grep '"OutputValue"' | sed 's/.*"OutputValue": "\(.*\)".*/\1/')
CLOUDFRONT_URL=$(echo "$STACK_OUTPUTS" | grep -A 1 '"OutputKey": "DistributionURL"' | grep '"OutputValue"' | sed 's/.*"OutputValue": "\(.*\)".*/\1/')

if [ -z "$S3_BUCKET" ] || [ -z "$CLOUDFRONT_ID" ]; then
  echo -e "${RED}✗ Failed to retrieve CDK stack outputs${NC}"
  echo -e "${RED}Could not find S3 bucket name or CloudFront distribution ID${NC}"
  exit 1
fi

echo -e "${BOLD}${GREEN}✓ Stack Outputs Retrieved${NC}"
echo -e "${GREEN}  S3 Bucket: ${BOLD}$S3_BUCKET${NC}"
echo -e "${GREEN}  CloudFront Distribution ID: ${BOLD}$CLOUDFRONT_ID${NC}"
echo -e "${GREEN}  CloudFront URL: ${BOLD}$CLOUDFRONT_URL${NC}"

echo ""

# Step 3: Upload files to S3 with cache control headers
echo -e "${BOLD}${BLUE}[3/4] Uploading files to S3...${NC}"
cd "$PROJECT_ROOT"

# Upload static assets (JS, CSS, images, fonts) with long cache TTL
echo -e "${CYAN}  → Uploading static assets (JS, CSS, images) with long cache TTL...${NC}"
if $AWS_CMD s3 sync out/ s3://$S3_BUCKET/ \
  --exclude "*.html" \
  --cache-control "public,max-age=31536000,immutable" \
  --delete; then
  echo -e "${GREEN}    ✓ Static assets uploaded${NC}"
else
  echo ""
  echo -e "${BOLD}${RED}✗ S3 Upload Status: FAILED (Static Assets)${NC}"
  echo -e "${RED}  Please check your AWS credentials and permissions${NC}"
  exit 1
fi

# Upload HTML files with short cache TTL
echo -e "${CYAN}  → Uploading HTML files with short cache TTL...${NC}"
if $AWS_CMD s3 sync out/ s3://$S3_BUCKET/ \
  --exclude "*" \
  --include "*.html" \
  --cache-control "public,max-age=0,must-revalidate" \
  --delete; then
  echo -e "${GREEN}    ✓ HTML files uploaded${NC}"
else
  echo ""
  echo -e "${BOLD}${RED}✗ S3 Upload Status: FAILED (HTML Files)${NC}"
  echo -e "${RED}  Please check your AWS credentials and permissions${NC}"
  exit 1
fi

echo ""
echo -e "${BOLD}${GREEN}✓ S3 Upload Status: SUCCESS${NC}"
echo -e "${GREEN}  All files synced to S3 bucket with appropriate cache headers${NC}"

echo ""

# Step 4: Invalidate CloudFront cache
echo -e "${BOLD}${BLUE}[4/4] Invalidating CloudFront cache...${NC}"

INVALIDATION_OUTPUT=$($AWS_CMD cloudfront create-invalidation \
  --distribution-id $CLOUDFRONT_ID \
  --paths "/*" \
  --output json 2>&1)

if [ $? -eq 0 ]; then
  INVALIDATION_ID=$(echo "$INVALIDATION_OUTPUT" | grep '"Id"' | head -1 | sed 's/.*"Id": "\(.*\)".*/\1/')
  echo ""
  echo -e "${BOLD}${GREEN}✓ CloudFront Invalidation Status: SUCCESS${NC}"
  echo -e "${GREEN}  Invalidation ID: ${BOLD}$INVALIDATION_ID${NC}"
  echo -e "${GREEN}  Status: ${BOLD}In Progress${NC}"
  echo -e "${CYAN}  Note: Cache invalidation typically completes within 1-3 minutes${NC}"
else
  echo ""
  echo -e "${BOLD}${YELLOW}⚠ CloudFront Invalidation Status: WARNING${NC}"
  echo -e "${YELLOW}  Cache invalidation failed, but your content has been uploaded${NC}"
  echo -e "${YELLOW}  Cached content may be stale until TTL expires or manual invalidation${NC}"
  echo -e "${YELLOW}  Error: $INVALIDATION_OUTPUT${NC}"
fi

echo ""
echo -e "${BOLD}${CYAN}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BOLD}${CYAN}║                  DEPLOYMENT SUCCESSFUL                     ║${NC}"
echo -e "${BOLD}${CYAN}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${BOLD}${GREEN}✓ Your Mindful Journeys blog has been deployed successfully!${NC}"
echo ""
echo -e "${BOLD}Deployment Summary:${NC}"
echo -e "  ${GREEN}✓${NC} Next.js build completed"
echo -e "  ${GREEN}✓${NC} Files uploaded to S3"
echo -e "  ${GREEN}✓${NC} CloudFront cache invalidated"
echo ""
echo -e "${BOLD}Access your blog at:${NC}"
echo -e "  ${BOLD}${BLUE}$CLOUDFRONT_URL${NC}"
echo ""
echo -e "${CYAN}Next steps:${NC}"
echo -e "  • Visit the URL above to view your deployed blog"
echo -e "  • Changes may take 1-3 minutes to propagate globally"
echo -e "  • Monitor CloudFront metrics in AWS Console for performance insights"
echo ""
