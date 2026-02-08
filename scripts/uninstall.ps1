# Uninstall Scheduled Tasks
Write-Host ""
Write-Host "========================================"
Write-Host "   UNINSTALLING BACKUP SCHEDULER"
Write-Host "========================================"
Write-Host ""

$tasks = Get-ScheduledTask -TaskName "ProjectBackup_*" -ErrorAction SilentlyContinue

if ($tasks) {
    foreach ($task in $tasks) {
        Write-Host "   Removing: $($task.TaskName)"
        Unregister-ScheduledTask -TaskName $task.TaskName -Confirm:$false
    }
    Write-Host ""
    Write-Host "   ✅ All backup tasks removed."
} else {
    Write-Host "   No backup tasks found."
}

Write-Host ""
