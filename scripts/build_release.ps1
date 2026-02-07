Write-Host "Building Release Zip..." -ForegroundColor Cyan

$zipName = "backup-pro.zip"
$tempDir = "temp_release_build"
$projectRoot = "$PSScriptRoot\.."

# Ensure we are in the project root context
Push-Location $projectRoot

# Clean previous
if (Test-Path $zipName) { Remove-Item $zipName }
if (Test-Path $tempDir) { Remove-Item $tempDir -Recurse -Force }

# Create temp dir structure
New-Item -Path "$tempDir\backup-pro" -ItemType Directory -Force | Out-Null

# Copy files
# Excluding dev files and the script itself
$exclude = @('.git', '.vscode', 'node_modules', 'backup-pro.zip', $tempDir, 'website', '.gitignore', 'package-lock.json')
# Note: package-lock.json is usually good to include, but if we want fresh install... keeping it is better for consistency. 
# actually let's keep package-lock.json.

$exclude = @('.git', '.vscode', 'node_modules', 'backup-pro.zip', $tempDir, 'website', '.github', '.antigravityignore')

Get-ChildItem -Path . | Where-Object { $exclude -notcontains $_.Name } | Copy-Item -Destination "$tempDir\backup-pro" -Recurse

# Create Zip
Compress-Archive -Path "$tempDir\backup-pro" -DestinationPath $zipName -Force

# Cleanup
Remove-Item $tempDir -Recurse -Force
Pop-Location

Write-Host "Done! Created $zipName in project root." -ForegroundColor Green
