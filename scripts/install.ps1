# Install Scheduled Tasks for Daily Backup
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$rootDir = Split-Path -Parent $scriptDir
$configPath = Join-Path $rootDir "config.json"
$vbsPath = Join-Path $scriptDir "backup-popup.vbs"

# Load config
$config = Get-Content $configPath | ConvertFrom-Json

Write-Host ""
Write-Host "========================================"
Write-Host "   INSTALLING BACKUP SCHEDULER"
Write-Host "========================================" 
Write-Host ""

# Remove existing tasks
Write-Host "   Removing old tasks..."
Get-ScheduledTask -TaskName "ProjectBackup_*" -ErrorAction SilentlyContinue | Unregister-ScheduledTask -Confirm:$false -ErrorAction SilentlyContinue

$days = @("Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday")
$dayMap = @{
    "Monday" = "monday"
    "Tuesday" = "tuesday"
    "Wednesday" = "wednesday"
    "Thursday" = "thursday"
    "Friday" = "friday"
    "Saturday" = "saturday"
    "Sunday" = "sunday"
}

$tasksCreated = 0

foreach ($day in $days) {
    $dayKey = $dayMap[$day]
    $schedule = $config.schedule.$dayKey
    
    if ($schedule.enabled) {
        $taskName = "ProjectBackup_$day"
        $time = $schedule.time
        
        Write-Host "   Creating task for $day at $time..."
        
        $action = New-ScheduledTaskAction -Execute "wscript.exe" -Argument "`"$vbsPath`""
        $trigger = New-ScheduledTaskTrigger -Weekly -DaysOfWeek $day -At $time
        $settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable
        
        Register-ScheduledTask -TaskName $taskName -Action $action -Trigger $trigger -Settings $settings -Force | Out-Null
        $tasksCreated++
    }
}

Write-Host ""
Write-Host "========================================"
Write-Host "   ✅ INSTALLATION COMPLETE!"
Write-Host "========================================"
Write-Host ""
Write-Host "   Created $tasksCreated scheduled tasks."
Write-Host ""
Write-Host "   Your backup popup will appear at:"
foreach ($day in $days) {
    $dayKey = $dayMap[$day]
    $schedule = $config.schedule.$dayKey
    if ($schedule.enabled) {
        Write-Host "      $day at $($schedule.time)"
    }
}
Write-Host ""
Write-Host "   To test now, double-click: scripts\backup-popup.vbs"
Write-Host ""
