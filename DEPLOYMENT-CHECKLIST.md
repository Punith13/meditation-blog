# AWS S3 Deployment Checklist

Use this checklist to deploy your meditation blog to AWS S3.

## ☐ Prerequisites

- [ ] AWS account created
- [ ] AWS CLI installed (`aws --version`)
- [ ] AWS CLI configured (`aws configure`)
- [ ] Node.js 18+ installed (`node --version`)
- [ ] Decided on bucket name (must be globally unique)

## ☐ Local Setup

- [ ] Dependencies installed (`npm install`)
- [ ] Local dev server works (`npm run dev`)
- [ ] Build succeeds (`npm run build`)
- [ ] Reviewed content in `lib/posts.ts`
- [ ] Updated site metadata in `app/layout.tsx`

## ☐ AWS S3 Configuration

- [ ] Created S3 bucket
  ```bash
  aws s3 mb s3://your-bucket-name --region us-east-1
  ```

- [ ] Enabled static website hosting
  ```bash
  aws s3 website s3://your-bucket-name \
      --index-document index.html \
      --error-document 404.html
  ```

- [ ] Updated `bucket-policy.json` with your bucket name

- [ ] Applied bucket policy
  ```bash
  aws s3api put-bucket-policy \
      --bucket your-bucket-name \
      --policy file://bucket-policy.json
  ```

- [ ] Disabled block public access
  ```bash
  aws s3api put-public-access-block \
      --bucket your-bucket-name \
      --public-access-block-configuration \
      "BlockPublicAcls=false,IgnorePublicAcls=false,BlockPublicPolicy=false,RestrictPublicBuckets=false"
  ```

## ☐ Deployment Script Setup

- [ ] Updated `deploy-to-s3.sh`:
  - [ ] Set `S3_BUCKET` variable
  - [ ] Set `AWS_REGION` variable
  - [ ] (Optional) Set `CLOUDFRONT_ID` if using CloudFront

- [ ] Made script executable (`chmod +x deploy-to-s3.sh`)

## ☐ First Deployment

- [ ] Ran deployment script (`./deploy-to-s3.sh`)
- [ ] Checked for errors in output
- [ ] Verified files uploaded to S3
  ```bash
  aws s3 ls s3://your-bucket-name/
  ```

## ☐ Testing

- [ ] Visited S3 website URL
  ```
  http://your-bucket-name.s3-website-us-east-1.amazonaws.com
  ```

- [ ] Home page loads correctly
- [ ] All 3 blog posts load
- [ ] Navigation works
- [ ] 404 page works (try invalid URL)
- [ ] Tested on mobile device
- [ ] Tested in different browsers

## ☐ Optional: CloudFront Setup

- [ ] Created CloudFront distribution
- [ ] Pointed origin to S3 bucket
- [ ] Configured default root object (index.html)
- [ ] Configured custom error responses (404 → 404.html)
- [ ] Waited for distribution to deploy (~15 minutes)
- [ ] Tested CloudFront URL
- [ ] Updated `deploy-to-s3.sh` with distribution ID

## ☐ Optional: Custom Domain

- [ ] Registered domain (or have existing domain)
- [ ] Created Route 53 hosted zone
- [ ] Requested SSL certificate in ACM (us-east-1)
- [ ] Validated certificate
- [ ] Added alternate domain name to CloudFront
- [ ] Attached SSL certificate to CloudFront
- [ ] Created Route 53 A record (alias to CloudFront)
- [ ] Tested custom domain with HTTPS

## ☐ Optional: CI/CD with GitHub Actions

- [ ] Pushed code to GitHub
- [ ] Added GitHub secrets:
  - [ ] `AWS_ACCESS_KEY_ID`
  - [ ] `AWS_SECRET_ACCESS_KEY`
  - [ ] `AWS_REGION`
  - [ ] `S3_BUCKET`
  - [ ] `CLOUDFRONT_DISTRIBUTION_ID` (if using CloudFront)
- [ ] Tested automated deployment

## ☐ Post-Deployment

- [ ] Bookmarked website URL
- [ ] Shared with friends/colleagues
- [ ] Set up monitoring (optional)
- [ ] Documented any custom changes
- [ ] Backed up bucket policy and configs

## 🎉 Success Criteria

Your deployment is successful when:
- ✅ Website loads at S3 or CloudFront URL
- ✅ All pages render correctly
- ✅ Images and styles load
- ✅ Navigation works
- ✅ Mobile responsive
- ✅ 404 page displays for invalid URLs

## 📝 Notes

**S3 Website URL Format:**
```
http://[bucket-name].s3-website-[region].amazonaws.com
```

**Common Regions:**
- us-east-1 (N. Virginia)
- us-west-2 (Oregon)
- eu-west-1 (Ireland)
- ap-southeast-1 (Singapore)

**Estimated Time:**
- Basic S3 setup: 10-15 minutes
- With CloudFront: 30-45 minutes
- With custom domain: 1-2 hours

## 🆘 Troubleshooting

**403 Forbidden:**
- Check bucket policy is correct
- Verify public access is not blocked
- Ensure files exist in bucket

**404 on all pages:**
- Verify static website hosting is enabled
- Check index document is set to `index.html`

**Styles not loading:**
- Check browser console for errors
- Verify `_next` folder uploaded to S3
- Clear browser cache

**Build fails:**
```bash
rm -rf node_modules .next out
npm install
npm run build
```

---

**Ready to deploy? Start from the top and check off each item!** ✅
