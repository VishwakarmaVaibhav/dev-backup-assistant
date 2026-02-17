# Build script for Backup Pro Windows Installer
$ErrorActionPreference = "Stop"

$projectName = "Backup Pro"
$rootDir = Resolve-Path "."
$distDir = Join-Path $rootDir "dist"
$nodeUrl = "https://nodejs.org/dist/v20.11.1/win-x64/node.exe"

Write-Host "--- Preparing $projectName Installer ---" -ForegroundColor Cyan
Write-Host "   Root Directory: $rootDir" -ForegroundColor Gray
Write-Host "   Current Directory: $(Get-Location)" -ForegroundColor Gray

# 1. Clean up
if (Test-Path $distDir) {
    Write-Host "   Cleaning up previous dist..."
    Remove-Item -Path $distDir -Recurse -Force
}
New-Item -ItemType Directory -Path $distDir | Out-Null
New-Item -ItemType Directory -Path (Join-Path $distDir "app") | Out-Null
New-Item -ItemType Directory -Path (Join-Path $distDir "bin") | Out-Null

# 2. Download Node.js if not present
$nodeDest = Join-Path $distDir "bin\node.exe"
$cacheNode = Join-Path $rootDir "node-cache.exe"

Write-Host "   Checking for Node.js binary..."
if (Test-Path $cacheNode) {
    Write-Host "   Using cached Node.js binary from root."
    Copy-Item $cacheNode -Destination $nodeDest
} elseif (Test-Path $nodeDest) {
    Write-Host "   Using existing Node.js binary."
} else {
    Write-Host "   Downloading Node.js (v20.11.1)..." -ForegroundColor Yellow
    try {
        Invoke-WebRequest -Uri $nodeUrl -OutFile $nodeDest -ErrorAction Stop
        Write-Host "   Download complete."
    } catch {
        Write-Warning "   Download failed: $($_.Exception.Message)"
        Write-Host "   Attempting to use system Node.js..."
        
        try {
            $systemNode = (Get-Command node).Source
            Copy-Item $systemNode -Destination $nodeDest -ErrorAction Stop
            Write-Host "   Copied system Node.js."
        } catch {
            Write-Error "   Failed to obtain Node.js binary. Please ensure internet access or place node.exe in '$nodeDest' manually."
            exit 1
        }
    }
}

# 3. Copy App Files
Write-Host "   Staging application files..."
$filesToCopy = @(
    "backup.js",
    "setup.js",
    "setup-server.js",
    "run-setup.vbs",
    "run-uninstall.vbs",
    "package.json",
    "config.json",
    "logo.ico",
    "LICENSE"
)

foreach ($file in $filesToCopy) {
    if (Test-Path $file) {
        Write-Host "   Copying $file..."
        Copy-Item $file -Destination (Join-Path $distDir "app") -Force
    } else {
        Write-Host "   [MISSING] $file" -ForegroundColor Red
    }
}

# Copy folders
Write-Host "   Copying folders..."
if (Test-Path "website") {
    Copy-Item "website" -Destination (Join-Path $distDir "app") -Recurse -Force
}
if (Test-Path "scripts") {
    Copy-Item "scripts" -Destination (Join-Path $distDir "app") -Recurse -Force
}
if (Test-Path "utils") {
    Copy-Item "utils" -Destination (Join-Path $distDir "app") -Recurse -Force
}
if (Test-Path "node_modules") {
    Write-Host "   Copying node_modules (this may take a while)..."
    Copy-Item "node_modules" -Destination (Join-Path $distDir "app") -Recurse -Force
}

# Verify staging
Write-Host "   Verifying staging..."
$appFiles = Get-ChildItem (Join-Path $distDir "app") -Recurse
Write-Host "   Staged $($appFiles.Count) items in app folder." -ForegroundColor Gray

# 4. Check for Inno Setup
$iscc = (Get-Command "iscc.exe" -ErrorAction SilentlyContinue).Source
if (!$iscc) {
    if (Test-Path "C:\Program Files (x86)\Inno Setup 6\ISCC.exe") {
        $iscc = "C:\Program Files (x86)\Inno Setup 6\ISCC.exe"
    }
}

if ($iscc) {
    Write-Host "   Inno Setup found at: $iscc" -ForegroundColor Green
    Write-Host "   Compiling installer..."
    $issPath = Join-Path $rootDir "windows-installer.iss"
    
    # Check if LICENSE exists in dist/app before continuing
    $licenseStaged = Join-Path $distDir "app\LICENSE"
    if (Test-Path $licenseStaged) {
        Write-Host "   Verified: $licenseStaged exists." -ForegroundColor Green
    } else {
        Write-Host "   [CRITICAL] $licenseStaged NOT FOUND!" -ForegroundColor Red
        # List contents of dist/app for debugging
        Get-ChildItem (Join-Path $distDir "app") | Select-Object Name
    }

    & $iscc "`"$issPath`""
} else {
    Write-Host "   [WARNING] Inno Setup (ISCC.exe) not found." -ForegroundColor Red
    Write-Host "   Please install Inno Setup 6 to compile the .exe installer." -ForegroundColor Yellow
}

Write-Host "--- Preparations Complete ---" -ForegroundColor Cyan
