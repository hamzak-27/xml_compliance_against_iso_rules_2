# DigitalOcean App Platform Component Detection Fix

## Problem
DigitalOcean App Platform shows "No components detected" because it's looking for `package.json`, `requirements.txt`, or `Dockerfile` files, but they're nested in subdirectories.

## Solution Options

### Option 1: Manual Configuration (Recommended)

Since your files are in subdirectories, you need to manually specify the source directories:

1. **Go to DigitalOcean App Platform**: https://cloud.digitalocean.com/apps

2. **Create App** and connect your GitHub repository

3. **Skip the automatic detection** and manually configure:

#### Backend Service Configuration:
- **Name**: `backend`
- **Source Directory**: `ai_compliance/Backend`  ← This is crucial!
- **Environment**: `Python`
- **Build Command**: Leave empty (will use requirements.txt)
- **Run Command**: `gunicorn --bind 0.0.0.0:$PORT --workers 2 --timeout 120 main:app`
- **HTTP Port**: `5000`
- **Health Check Path**: `/api/health`

**Environment Variables:**
```
FLASK_ENV=production
OPENAI_API_KEY=your_actual_openai_api_key_here
PYTHONUNBUFFERED=1
PORT=5000
```

#### Frontend Static Site Configuration:
- **Name**: `frontend`
- **Source Directory**: `ai_compliance/Frontend`  ← This is crucial!
- **Build Command**: `npm ci && VITE_API_BASE_URL=${backend.PUBLIC_URL}/api npm run build`
- **Output Directory**: `dist`

### Option 2: Use App Spec (Alternative)

1. **Create App** from GitHub
2. **Skip auto-detection**
3. **Import App Spec**: Upload the `.do/app.yaml` file from your repository
4. **Update the repo name** in the YAML file to match your actual GitHub repository

### Option 3: Restructure Repository (If needed)

If the above doesn't work, we can flatten the structure:

```
xml_compliance_against_iso_rules_2/
├── backend/          ← Move from ai_compliance/Backend/
│   ├── requirements.txt
│   ├── Dockerfile
│   └── main.py
├── frontend/         ← Move from ai_compliance/Frontend/
│   ├── package.json
│   ├── Dockerfile
│   └── src/
└── docker-compose.yml
```

## Step-by-Step Manual Configuration

### Step 1: Backend Service

1. Click **"Create Service"** → **"Web Service"**
2. **Source**: Select your GitHub repository
3. **Source Directory**: Type `ai_compliance/Backend`
4. **Environment**: Python
5. **Build Phase**:
   - **Build Command**: Leave empty (auto-detected from requirements.txt)
6. **Run Phase**:
   - **Run Command**: `gunicorn --bind 0.0.0.0:$PORT --workers 2 --timeout 120 main:app`
7. **Health Checks**:
   - **HTTP Path**: `/api/health`
8. **Environment Variables**:
   ```
   FLASK_ENV=production
   OPENAI_API_KEY=sk-your-actual-key-here
   PYTHONUNBUFFERED=1
   PORT=5000
   ```

### Step 2: Frontend Static Site

1. Click **"Create Static Site"**
2. **Source**: Same GitHub repository
3. **Source Directory**: Type `ai_compliance/Frontend`
4. **Build Settings**:
   - **Build Command**: `npm ci && VITE_API_BASE_URL=${backend.PUBLIC_URL}/api npm run build`
   - **Output Directory**: `dist`
5. **Routes**: `/` (default)

### Step 3: Deploy

1. Review your configuration
2. Click **"Create Resources"**
3. Wait for deployment (usually 5-10 minutes)

## Troubleshooting

### If components still not detected:

1. **Check Source Directory**: Make sure you typed `ai_compliance/Backend` and `ai_compliance/Frontend` exactly
2. **Check Repository Access**: Ensure DigitalOcean has access to your GitHub repository
3. **Check File Locations**: Verify files are in the correct subdirectories
4. **Try Manual Setup**: Skip auto-detection entirely and create services manually

### Common Issues:

- **Build Fails**: Check that `requirements.txt` is in `ai_compliance/Backend/`
- **Frontend Build Fails**: Check that `package.json` is in `ai_compliance/Frontend/`
- **API Connection Issues**: Verify the `VITE_API_BASE_URL` is set correctly

## Expected Result

After successful deployment:
- **Backend**: `https://your-backend-app-xxxxx.ondigitalocean.app`
- **Frontend**: `https://your-frontend-app-xxxxx.ondigitalocean.app`
- **Health Check**: `https://your-backend-app-xxxxx.ondigitalocean.app/api/health`

## Alternative: Use Docker Droplet Instead

If App Platform continues to have issues, consider using a DigitalOcean Droplet with Docker:

```bash
# On your droplet
git clone your-repo-url
cd xml_compliance_against_iso_rules_2
cp .env.example .env
nano .env  # Add your OpenAI API key
./deploy-droplet.sh
```

This approach uses Docker Compose and will definitely work since we've already validated it.