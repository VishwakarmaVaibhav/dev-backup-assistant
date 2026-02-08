Write-Host "Downloading Git..." -ForegroundColor Cyan
$gitUrl = "https://github.com/git-for-windows/git/releases/download/v2.47.1.windows.1/Git-2.47.1-64-bit.exe"
$installer = "$env:TEMP\git-install.exe"

Invoke-WebRequest -Uri $gitUrl -OutFile $installer

Write-Host "Installing Git (This may take a minute)..." -ForegroundColor Cyan
Start-Process -FilePath $installer -ArgumentList "/VERYSILENT", "/NORESTART", "/NOCANCEL", "/SP-", "/CLOSEAPPLICATIONS", "/RESTARTAPPLICATIONS" -Wait

Write-Host "Git Installed successfully!" -ForegroundColor Green
Write-Host "Please RESTART your terminal/VS Code to use 'git' command." -ForegroundColor Yellow
Remove-Item $installer
