# Repository Restructure Script for DigitalOcean App Platform
# This script moves files to a flatter structure that DigitalOcean can auto-detect

Write-Host "🔄 Restructuring repository for better DigitalOcean App Platform compatibility..." -ForegroundColor Green
Write-Host ""

# Create backup
Write-Host "📦 Creating backup of current structure..." -ForegroundColor Yellow
$timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$backupDir = "backup_$timestamp"
Copy-Item -Path "ai_compliance" -Destination $backupDir -Recurse
Write-Host "✅ Backup created: $backupDir" -ForegroundColor Green

# Create new directory structure
Write-Host "📁 Creating new directory structure..." -ForegroundColor Yellow

# Create backend directory in root
if (-not (Test-Path "backend")) {
    New-Item -ItemType Directory -Path "backend" -Force | Out-Null
}

# Create frontend directory in root
if (-not (Test-Path "frontend")) {
    New-Item -ItemType Directory -Path "frontend" -Force | Out-Null
}

# Move backend files
Write-Host "⬅️  Moving backend files..." -ForegroundColor Yellow
$backendFiles = Get-ChildItem -Path "ai_compliance\Backend" -Recurse
foreach ($file in $backendFiles) {
    if ($file.PSIsContainer) {
        $destDir = $file.FullName -replace [regex]::Escape("ai_compliance\Backend"), "backend"
        if (-not (Test-Path $destDir)) {
            New-Item -ItemType Directory -Path $destDir -Force | Out-Null
        }
    } else {
        $destFile = $file.FullName -replace [regex]::Escape("ai_compliance\Backend"), "backend"
        $destDir = Split-Path $destFile -Parent
        if (-not (Test-Path $destDir)) {
            New-Item -ItemType Directory -Path $destDir -Force | Out-Null
        }
        Copy-Item -Path $file.FullName -Destination $destFile -Force
    }
}

# Move frontend files
Write-Host "⬅️  Moving frontend files..." -ForegroundColor Yellow
$frontendFiles = Get-ChildItem -Path "ai_compliance\Frontend" -Recurse
foreach ($file in $frontendFiles) {
    if ($file.PSIsContainer) {
        $destDir = $file.FullName -replace [regex]::Escape("ai_compliance\Frontend"), "frontend"
        if (-not (Test-Path $destDir)) {
            New-Item -ItemType Directory -Path $destDir -Force | Out-Null
        }
    } else {
        $destFile = $file.FullName -replace [regex]::Escape("ai_compliance\Frontend"), "frontend"
        $destDir = Split-Path $destFile -Parent
        if (-not (Test-Path $destDir)) {
            New-Item -ItemType Directory -Path $destDir -Force | Out-Null
        }
        Copy-Item -Path $file.FullName -Destination $destFile -Force
    }
}

# Update docker-compose.yml
Write-Host "🔧 Updating docker-compose.yml..." -ForegroundColor Yellow
if (Test-Path "docker-compose.yml") {
    $dockerCompose = Get-Content "docker-compose.yml" -Raw
    $dockerCompose = $dockerCompose -replace "ai_compliance/Backend", "backend"
    $dockerCompose = $dockerCompose -replace "ai_compliance/Frontend", "frontend"
    $dockerCompose = $dockerCompose -replace "./ai_compliance/Backend/iso_controls.csv", "./backend/iso_controls.csv"
    Set-Content -Path "docker-compose.yml" -Value $dockerCompose
}

# Update deployment configurations
Write-Host "🔧 Updating deployment configurations..." -ForegroundColor Yellow
if (Test-Path ".do\app.yaml") {
    $appYaml = Get-Content ".do\app.yaml" -Raw
    $appYaml = $appYaml -replace "/ai_compliance/Backend", "/backend"
    $appYaml = $appYaml -replace "/ai_compliance/Frontend", "/frontend"
    Set-Content -Path ".do\app.yaml" -Value $appYaml
}

# Update deployment script
if (Test-Path "deploy-droplet.sh") {
    $deployScript = Get-Content "deploy-droplet.sh" -Raw
    $deployScript = $deployScript -replace "ai_compliance/Backend", "backend"
    $deployScript = $deployScript -replace "ai_compliance/Frontend", "frontend"
    Set-Content -Path "deploy-droplet.sh" -Value $deployScript
}

# Create new directory listing
Write-Host ""
Write-Host "📊 New directory structure:" -ForegroundColor Cyan
Write-Host "xml_compliance_against_iso_rules_2/" -ForegroundColor White
Write-Host "├── backend/" -ForegroundColor Green
Write-Host "│   ├── requirements.txt" -ForegroundColor White
Write-Host "│   ├── Dockerfile" -ForegroundColor White
Write-Host "│   ├── main.py" -ForegroundColor White
Write-Host "│   └── ..." -ForegroundColor White
Write-Host "├── frontend/" -ForegroundColor Green
Write-Host "│   ├── package.json" -ForegroundColor White
Write-Host "│   ├── Dockerfile" -ForegroundColor White
Write-Host "│   └── src/" -ForegroundColor White
Write-Host "├── docker-compose.yml" -ForegroundColor White
Write-Host "├── .env.example" -ForegroundColor White
Write-Host "└── .do/app.yaml" -ForegroundColor White

Write-Host ""
Write-Host "✅ Repository restructured successfully!" -ForegroundColor Green
Write-Host ""
Write-Host "📋 Next steps:" -ForegroundColor Cyan
Write-Host "1. Test the new structure locally:" -ForegroundColor White
Write-Host "   docker-compose up" -ForegroundColor Yellow
Write-Host "2. Commit and push changes to GitHub:" -ForegroundColor White
Write-Host "   git add ." -ForegroundColor Yellow
Write-Host "   git commit -m 'Restructure for DigitalOcean App Platform compatibility'" -ForegroundColor Yellow
Write-Host "   git push" -ForegroundColor Yellow
Write-Host "3. Try DigitalOcean App Platform auto-detection again" -ForegroundColor White
Write-Host ""
Write-Host "🔄 To revert changes, you can use the backup: $backupDir" -ForegroundColor Yellow