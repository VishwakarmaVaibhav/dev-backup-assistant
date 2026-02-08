# PowerShell script to send email via Outlook with attachment

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$rootDir = Split-Path -Parent $scriptDir
$configPath = Join-Path $rootDir "config.json"

if (-not (Test-Path $configPath)) {
    Write-Host "Config not found!"
    exit 1
}

$config = Get-Content $configPath | ConvertFrom-Json
$backupFolder = $config.backupFolder
$projectName = $config.projectName

# Find latest zip
$latestZip = Get-ChildItem -Path $backupFolder -Filter "$projectName*.zip" | Sort-Object LastWriteTime -Descending | Select-Object -First 1

if (-not $latestZip) {
    Write-Host "No backup file found."
    exit 1
}

Write-Host "Found backup: $($latestZip.FullName)"

try {
    # Try using Outlook COM object
    $outlook = New-Object -ComObject Outlook.Application
    $mail = $outlook.CreateItem(0) # 0 = olMailItem
    $mail.Subject = "Project Backup: $projectName"
    $mail.Body = "Attached is the latest backup for project: $projectName"
    $mail.Attachments.Add($latestZip.FullName)
    $mail.Display() # Open the window
    Write-Host "Outlook opened with attachment."
} catch {
    Write-Warning "Could not automate Outlook. Fallback to opening folder."
    Write-Warning $_.Exception.Message
    
    # Fallback: Select file in Explorer and open default mailto (no attachment possible via mailto)
    Start-Process "explorer.exe" -ArgumentList "/select,`"$($latestZip.FullName)`""
    Start-Process "mailto:?subject=Project Backup: $projectName&body=Please attach the backup file manually."
}
