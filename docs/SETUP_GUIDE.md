# Setup Guide: API Keys & Deployment

This guide explains how to get the necessary keys for Google Login and PayU Payment Gateway, and how to push your code to GitHub.

## 1. Google Authentication (NextAuth)

You need a **Client ID** and **Client Secret** from Google Cloud.

1.  Go to the [Google Cloud Console](https://console.cloud.google.com/).
2.  Create a **New Project** (e.g., "Backup Pro Auth").
3.  Navigate to **APIs & Services** > **Credentials**.
4.  Click **Create Credentials** > **OAuth client ID**.
5.  If prompted, configure the **Consent Screen**:
    *   **User Type**: External.
    *   **App Name**: Backup Pro.
    *   **Support Email**: Your email.
    *   **Developer Contact**: Your email.
    *   **Scopes**: Select `userinfo.email` and `userinfo.profile`.
6.  Back in **Create OAuth client ID**:
    *   **Application type**: Web application.
    *   **Name**: Backup Pro Web.
    *   **Authorized JavaScript origins**: `http://localhost:3001` (and your production domain later, e.g., `https://backup-pro.vercel.app`).
    *   **Authorized redirect URIs**: `http://localhost:3001/api/auth/callback/google` (and `https://.../api/auth/callback/google`).
7.  Click **Create**.
8.  Copy the **Client ID** and **Client Secret**.

## 2. PayU Payment Gateway (Test Mode)

You need a **Merchant Key** and **Salt**.

1.  Go to the [PayU Dashboard](https://onboarding.payu.in/app/account/signin).
2.  Sign up for a merchant account (or log in).
3.  Switch to **Test Mode** (toggle button usually at the top right).
4.  Go to **Settings** > **API Keys** (or similar section).
5.  Copy the **Merchant Key** and **Salt** (for Test Environment).

**Note**: If you don't have a PayU account yet, you can use their universal test credentials for development:
*   **Key**: `GTKFFx`
*   **Salt**: `eCwWELxi`
*   **Test URL**: `https://test.payu.in/_payment`

## 3. Configure Local Environment

Create a file named `.env.local` inside the `web-portal` folder:

```ini
# Google Auth
GOOGLE_CLIENT_ID=your_pasted_client_id
GOOGLE_CLIENT_SECRET=your_pasted_client_secret
NEXTAUTH_SECRET=any_random_string_here_for_security
NEXTAUTH_URL=http://localhost:3001

# PayU (Test)
PAYU_KEY=GTKFFx
PAYU_SALT=eCwWELxi
# For production, replace with your real keys
```

## 4. Push to GitHub

To save your changes and upload the new `web-portal` to your repository:

### Step 1: Initialize Web Portal (Optional if nested)
Since `web-portal` is inside your main repo, just commit from the root.

### Step 2: Commit and Push
Open a terminal in `c:\Users\Admin\Dev-backup-assistant` and run:

```bash
# Add all new files (including web-portal)
git add .

# Commit changes
git commit -m "feat: Add Next.js web portal with Google Auth and PayU"

# Push to GitHub
git push origin main
```

## 5. Deployment (Vercel)

### Option A: New Project
1.  Go to [Vercel](https://vercel.com).
2.  Import your GitHub repository (`dev-backup-assistant`).
3.  **Root Directory**: Click "Edit" and select `web-portal`.
4.  **Environment Variables**: Add the variables from `.env.local` (GOOGLE_..., PAYU_...).
5.  Click **Deploy**.

### Option B: Existing Project (Update Root Directory)
If you already deployed the `website` folder:
1.  Go to your Project Settings in Vercel.
2.  Navigate to **General** > **Root Directory**.
3.  Change it from `website` (or `.`) to `web-portal`.
4.  Go to **Environment Variables** and add your keys (`GOOGLE_CLIENT_ID`, etc.).
5.  Go to **Deployments** tab and redeploy the latest commit.
