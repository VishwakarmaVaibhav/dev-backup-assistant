Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName System.Windows.Forms

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$rootDir = Split-Path -Parent $scriptDir

# Show popup
$result = [System.Windows.MessageBox]::Show(
    "Time to backup your project!`n`nClick YES to create a backup now.`nClick NO to skip.",
    "Daily Project Backup",
    "YesNo",
    "Question"
)

if ($result -eq "Yes") {
    # Run backup
    Set-Location $rootDir
    $process = Start-Process -FilePath "node" -ArgumentList "backup.js" -Wait -PassThru -NoNewWindow
    
    if ($process.ExitCode -eq 0) {
        [System.Windows.MessageBox]::Show(
            "Backup completed successfully!`n`nThe backup folder has been opened.`nYou can now share the ZIP file wherever you want.",
            "Backup Complete",
            "OK",
            "Information"
        )
    } else {
        [System.Windows.MessageBox]::Show(
            "Backup failed! Check the console for errors.",
            "Backup Error",
            "OK",
            "Error"
        )
    }
}
