#!/bin/bash

# Diagnostic script for CloudFront Access Denied issues

set -e

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

# Parse command line arguments
AWS_PROFILE=""
AWS_REGION="us-east-1"

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
    *)
      shift
      ;;
  esac
done

# Build AWS CLI command
AWS_CMD="aws"
if [ -n "$AWS_PROFILE" ]; then
  AWS_CMD="aws --profile $AWS_PROFILE"
fi
AWS_CMD="$AWS_CMD --region $AWS_REGION"

echo ""
echo -e "${BOLD}${CYAN}CloudFront Access Denied Diagnostic${NC}"
echo -e "${CYAN}=====================================${NC}"
echo ""

# Get stack outputs
echo -e "${BLUE}[1/5] Retrieving stack information...${NC}"
STACK_OUTPUTS=$($AWS_CMD cloudformation describe-stacks \
  --stack-name MeditationBlogStack \
  --query 'Stacks[0].Outputs' \
  --output json 2>/dev/null)

if [ $? -ne 0 ]; then
  echo -e "${RED}✗ Stack not found. Please deploy the CDK stack first.${NC}"
  exit 1
fi

S3_BUCKET=$(echo "$STACK_OUTPUTS" | grep -A 1 '"OutputKey": "BucketName"' | grep '"OutputValue"' | sed 's/.*"OutputValue": "\(.*\)".*/\1/')
CLOUDFRONT_ID=$(echo "$STACK_OUTPUTS" | grep -A 1 '"OutputKey": "DistributionId"' | grep '"OutputValue"' | sed 's/.*"OutputValue": "\(.*\)".*/\1/')

echo -e "${GREEN}✓ S3 Bucket: ${BOLD}$S3_BUCKET${NC}"
echo -e "${GREEN}✓ CloudFront ID: ${BOLD}$CLOUDFRONT_ID${NC}"
echo ""

# Check S3 bucket contents
echo -e "${BLUE}[2/5] Checking S3 bucket contents...${NC}"
FILE_COUNT=$($AWS_CMD s3 ls s3://$S3_BUCKET/ --recursive | wc -l)

if [ "$FILE_COUNT" -eq 0 ]; then
  echo -e "${RED}✗ ISSUE FOUND: S3 bucket is empty!${NC}"
  echo -e "${YELLOW}  Solution: Upload your blog files to S3${NC}"
  echo -e "${CYAN}  Run: ./scripts/deploy.sh${NC}"
  echo ""
else
  echo -e "${GREEN}✓ Bucket contains $FILE_COUNT files${NC}"
  
  # Check for index.html
  if $AWS_CMD s3 ls s3://$S3_BUCKET/index.html &>/dev/null; then
    echo -e "${GREEN}✓ index.html found${NC}"
  else
    echo -e "${RED}✗ ISSUE FOUND: index.html not found in bucket root${NC}"
    echo -e "${YELLOW}  Solution: Ensure Next.js build creates index.html${NC}"
  fi
fi
echo ""

# Check CloudFront distribution status
echo -e "${BLUE}[3/5] Checking CloudFront distribution status...${NC}"
DIST_STATUS=$($AWS_CMD cloudfront get-distribution \
  --id $CLOUDFRONT_ID \
  --query 'Distribution.Status' \
  --output text 2>/dev/null)

if [ "$DIST_STATUS" = "Deployed" ]; then
  echo -e "${GREEN}✓ Distribution status: Deployed${NC}"
else
  echo -e "${YELLOW}⚠ Distribution status: $DIST_STATUS${NC}"
  echo -e "${YELLOW}  Note: Distribution is still deploying. This can take 5-15 minutes.${NC}"
  echo -e "${YELLOW}  Wait a few minutes and try accessing the URL again.${NC}"
fi
echo ""

# Check bucket policy
echo -e "${BLUE}[4/5] Checking S3 bucket policy...${NC}"
BUCKET_POLICY=$($AWS_CMD s3api get-bucket-policy \
  --bucket $S3_BUCKET \
  --query 'Policy' \
  --output text 2>/dev/null)

if [ $? -eq 0 ]; then
  if echo "$BUCKET_POLICY" | grep -q "cloudfront.amazonaws.com"; then
    echo -e "${GREEN}✓ Bucket policy allows CloudFront access${NC}"
    
    # Check if the distribution ID matches
    if echo "$BUCKET_POLICY" | grep -q "$CLOUDFRONT_ID"; then
      echo -e "${GREEN}✓ Bucket policy references correct distribution${NC}"
    else
      echo -e "${RED}✗ ISSUE FOUND: Bucket policy references wrong distribution ID${NC}"
      echo -e "${YELLOW}  Solution: Redeploy the CDK stack${NC}"
      echo -e "${CYAN}  Run: cd cdk && cdk deploy${NC}"
    fi
  else
    echo -e "${RED}✗ ISSUE FOUND: Bucket policy doesn't allow CloudFront access${NC}"
    echo -e "${YELLOW}  Solution: Redeploy the CDK stack${NC}"
    echo -e "${CYAN}  Run: cd cdk && cdk deploy${NC}"
  fi
else
  echo -e "${RED}✗ ISSUE FOUND: No bucket policy found${NC}"
  echo -e "${YELLOW}  Solution: Redeploy the CDK stack${NC}"
  echo -e "${CYAN}  Run: cd cdk && cdk deploy${NC}"
fi
echo ""

# Check Origin Access Control
echo -e "${BLUE}[5/5] Checking Origin Access Control configuration...${NC}"
DIST_CONFIG=$($AWS_CMD cloudfront get-distribution-config \
  --id $CLOUDFRONT_ID \
  --output json 2>/dev/null)

OAC_ID=$(echo "$DIST_CONFIG" | grep -o '"OriginAccessControlId": "[^"]*"' | head -1 | sed 's/.*": "\(.*\)"/\1/')

if [ -n "$OAC_ID" ] && [ "$OAC_ID" != "" ]; then
  echo -e "${GREEN}✓ Origin Access Control is configured${NC}"
  echo -e "${GREEN}  OAC ID: $OAC_ID${NC}"
else
  echo -e "${RED}✗ ISSUE FOUND: Origin Access Control not configured${NC}"
  echo -e "${YELLOW}  Solution: Redeploy the CDK stack${NC}"
  echo -e "${CYAN}  Run: cd cdk && cdk deploy${NC}"
fi
echo ""

# Summary
echo -e "${BOLD}${CYAN}=====================================${NC}"
echo -e "${BOLD}${CYAN}Summary & Recommendations${NC}"
echo -e "${BOLD}${CYAN}=====================================${NC}"
echo ""

if [ "$FILE_COUNT" -eq 0 ]; then
  echo -e "${YELLOW}Primary Issue: S3 bucket is empty${NC}"
  echo -e "${BOLD}Next Steps:${NC}"
  echo -e "  1. Build and deploy your blog:"
  echo -e "     ${CYAN}cd meditation-blog${NC}"
  echo -e "     ${CYAN}./scripts/deploy.sh${NC}"
  echo ""
elif [ "$DIST_STATUS" != "Deployed" ]; then
  echo -e "${YELLOW}Primary Issue: CloudFront distribution still deploying${NC}"
  echo -e "${BOLD}Next Steps:${NC}"
  echo -e "  1. Wait 5-10 more minutes"
  echo -e "  2. Run this diagnostic again"
  echo -e "  3. Try accessing your CloudFront URL"
  echo ""
else
  echo -e "${GREEN}All checks passed!${NC}"
  echo -e "${BOLD}If you're still seeing Access Denied:${NC}"
  echo -e "  1. Wait a few more minutes for changes to propagate"
  echo -e "  2. Clear your browser cache (Ctrl+Shift+R or Cmd+Shift+R)"
  echo -e "  3. Try accessing in an incognito/private window"
  echo -e "  4. Check CloudWatch logs for more details"
  echo ""
fi

echo -e "${CYAN}For more help, see: meditation-blog/cdk/README.md (Troubleshooting section)${NC}"
echo ""
