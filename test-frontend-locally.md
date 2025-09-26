# Test Frontend Locally with Live Backend

## Quick Test Setup:

1. **Navigate to frontend directory:**
   ```bash
   cd ai_compliance/Frontend
   ```

2. **Install dependencies:**
   ```bash
   npm install
   ```

3. **Create environment file:**
   Create `.env.local` file with:
   ```
   VITE_API_BASE_URL=https://your-backend-app-xxxxx.ondigitalocean.app/api
   ```
   Replace `your-backend-app-xxxxx` with your actual backend URL.

4. **Run frontend locally:**
   ```bash
   npm run dev
   ```

5. **Open browser:**
   Go to `http://localhost:5173`

This will let you test your frontend locally while using your live backend API.

## What You Should See:
- ✅ Frontend loads at localhost:5173
- ✅ Can upload XML files
- ✅ Files get processed by your live backend
- ✅ See compliance results

Once this works locally, add the frontend component to DigitalOcean for full deployment!