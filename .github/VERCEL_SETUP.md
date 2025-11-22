# Vercel Deployment Setup Guide

This guide will help you set up automatic deployments to Vercel using GitHub Actions.

## Prerequisites

1. A Vercel account (sign up at [vercel.com](https://vercel.com))
2. Your project connected to Vercel
3. GitHub repository with admin access

## Step 1: Get Vercel Token

1. Go to [Vercel Account Settings](https://vercel.com/account/tokens)
2. Click "Create Token"
3. Give it a name (e.g., "GitHub Actions")
4. Select the appropriate scope (recommended: Full Account)
5. Click "Create"
6. **Copy the token** - you won't be able to see it again!

## Step 2: Get Vercel Project IDs

### Option A: Using Vercel CLI (Recommended)

1. Install Vercel CLI if you haven't:
   ```bash
   npm install -g vercel
   ```

2. Login to Vercel:
   ```bash
   vercel login
   ```

3. Link your project (run from the `meditation-blog` directory):
   ```bash
   cd meditation-blog
   vercel link
   ```

4. Get your project details:
   ```bash
   cat .vercel/project.json
   ```

   This will show you:
   - `projectId` - Your Vercel Project ID
   - `orgId` - Your Vercel Organization ID

### Option B: From Vercel Dashboard

1. Go to your project on [Vercel Dashboard](https://vercel.com/dashboard)
2. Click on "Settings"
3. Under "General", you'll find:
   - **Project ID** - Copy this value
4. For Organization ID:
   - Go to your [Account Settings](https://vercel.com/account)
   - Under "General", find your **Team ID** (this is your Org ID)
   - If you're on a personal account, the Org ID is the same as your username

## Step 3: Add GitHub Secrets

1. Go to your GitHub repository
2. Click on "Settings" tab
3. In the left sidebar, click "Secrets and variables" → "Actions"
4. Click "New repository secret" and add the following three secrets:

### Secret 1: VERCEL_TOKEN
- **Name**: `VERCEL_TOKEN`
- **Value**: The token you created in Step 1

### Secret 2: VERCEL_ORG_ID
- **Name**: `VERCEL_ORG_ID`
- **Value**: Your Organization ID from Step 2

### Secret 3: VERCEL_PROJECT_ID
- **Name**: `VERCEL_PROJECT_ID`
- **Value**: Your Project ID from Step 2

## Step 4: Configure Vercel Project (Optional)

If you want to customize your Vercel deployment, create a `vercel.json` file in the `meditation-blog` directory:

```json
{
  "buildCommand": "npm run build",
  "outputDirectory": "out",
  "framework": "nextjs",
  "regions": ["iad1"]
}
```

## Step 5: Test the Deployment

1. Commit and push your changes:
   ```bash
   git add .
   git commit -m "Add Vercel deployment workflow"
   git push origin main
   ```

2. Go to the "Actions" tab in your GitHub repository
3. You should see the "Deploy to Vercel" workflow running
4. Once complete, your site will be deployed to Vercel!

## How It Works

### Production Deployments
- Triggered when you push to `main` or `master` branch
- Deploys to your production Vercel URL
- Uses the `--prod` flag

### Preview Deployments
- Triggered when you create or update a pull request
- Creates a unique preview URL for testing
- Does not affect production

## Workflow Features

- ✅ Automatic deployment on push to main/master
- ✅ Preview deployments for pull requests
- ✅ Node.js caching for faster builds
- ✅ Runs on Ubuntu latest
- ✅ Uses Node.js 18

## Troubleshooting

### "Invalid token" error
- Make sure you copied the entire token
- Verify the token hasn't expired
- Create a new token if needed

### "Project not found" error
- Double-check your `VERCEL_PROJECT_ID`
- Ensure the project exists in your Vercel account
- Verify you're using the correct organization ID

### Build fails
- Check the GitHub Actions logs for specific errors
- Ensure your project builds locally: `npm run build`
- Verify all dependencies are in `package.json`

### Wrong directory
- The workflow is configured for the `meditation-blog` directory
- If your project is in a different location, update the `working-directory` in the workflow file

## Additional Resources

- [Vercel CLI Documentation](https://vercel.com/docs/cli)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Vercel Deployment Documentation](https://vercel.com/docs/deployments/overview)

## Security Notes

- Never commit your Vercel token to the repository
- Use GitHub Secrets for all sensitive information
- Regularly rotate your tokens for security
- Limit token scope to only what's needed
