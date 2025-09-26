# Deployment Validation Script for Windows PowerShell
Write-Host "Validating XML Compliance Checker for DigitalOcean Deployment..." -ForegroundColor Green
Write-Host ""

$errors = @()
$warnings = @()

# Check Docker Compose configuration
Write-Host "Checking Docker Compose configuration..." -ForegroundColor Yellow
try {
    $dockerComposeConfig = docker-compose config 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Docker Compose configuration is valid" -ForegroundColor Green
    } else {
        $errors += "Docker Compose configuration is invalid"
        Write-Host "Docker Compose configuration is invalid" -ForegroundColor Red
    }
} catch {
    $errors += "Docker Compose not available"
    Write-Host "Docker Compose not available" -ForegroundColor Red
}

# Check required files
Write-Host ""
Write-Host "Checking required files..." -ForegroundColor Yellow

$requiredFiles = @(
    "docker-compose.yml",
    "ai_compliance\Backend\Dockerfile",
    "ai_compliance\Frontend\Dockerfile",
    "ai_compliance\Backend\requirements.txt",
    "ai_compliance\Frontend\package.json",
    "ai_compliance\Backend\main.py",
    "ai_compliance\Backend\iso_controls.csv",
    "ai_compliance\Frontend\nginx.conf",
    ".env.example"
)

foreach ($file in $requiredFiles) {
    if (Test-Path $file) {
        Write-Host "$file - OK" -ForegroundColor Green
    } else {
        $errors += "Missing file: $file"
        Write-Host "Missing: $file" -ForegroundColor Red
    }
}

# Summary
Write-Host ""
Write-Host "Validation Summary" -ForegroundColor Cyan
Write-Host "=================" -ForegroundColor Cyan

if ($errors.Count -eq 0) {
    Write-Host "No blocking errors found!" -ForegroundColor Green
    Write-Host "Your application appears to be ready for DigitalOcean deployment." -ForegroundColor Green
} else {
    Write-Host "Found $($errors.Count) error(s) that must be fixed:" -ForegroundColor Red
    foreach ($error in $errors) {
        Write-Host "- $error" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "Next Steps:" -ForegroundColor Cyan
Write-Host "1. Create .env file: Copy-Item .env.example .env" -ForegroundColor White
Write-Host "2. Update .env with your OpenAI API key" -ForegroundColor White
Write-Host "3. Test locally: docker-compose up" -ForegroundColor White
Write-Host "4. Deploy to DigitalOcean using DEPLOYMENT.md guide" -ForegroundColor White