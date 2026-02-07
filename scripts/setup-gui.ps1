Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$rootDir = Split-Path -Parent $scriptDir
$configPath = Join-Path $rootDir "config.json"

# Modern color scheme - Dark with Teal/Cyan accent
$colors = @{
    Background = [System.Drawing.Color]::FromArgb(18, 18, 24)
    Card = [System.Drawing.Color]::FromArgb(28, 28, 36)
    Accent = [System.Drawing.Color]::FromArgb(0, 200, 180)
    AccentHover = [System.Drawing.Color]::FromArgb(0, 230, 200)
    Text = [System.Drawing.Color]::FromArgb(240, 240, 245)
    TextDim = [System.Drawing.Color]::FromArgb(140, 140, 160)
    Success = [System.Drawing.Color]::FromArgb(80, 200, 120)
    Warning = [System.Drawing.Color]::FromArgb(255, 180, 50)
    Danger = [System.Drawing.Color]::FromArgb(220, 80, 80)
    Input = [System.Drawing.Color]::FromArgb(38, 38, 48)
}

# Load existing config or create default
if (Test-Path $configPath) {
    $config = Get-Content $configPath -Raw | ConvertFrom-Json
} else {
    $config = [PSCustomObject]@{
        projectPath = ""
        backupFolder = ""
        projectName = "MyProject"
        maxBackups = 10
        winrarPath = "C:\Program Files\WinRAR\rar.exe"
        schedule = [PSCustomObject]@{
            monday = [PSCustomObject]@{ enabled = $true; time = "18:50" }
            tuesday = [PSCustomObject]@{ enabled = $true; time = "18:50" }
            wednesday = [PSCustomObject]@{ enabled = $true; time = "18:50" }
            thursday = [PSCustomObject]@{ enabled = $true; time = "18:50" }
            friday = [PSCustomObject]@{ enabled = $true; time = "18:50" }
            saturday = [PSCustomObject]@{ enabled = $true; time = "14:30" }
            sunday = [PSCustomObject]@{ enabled = $false; time = "18:50" }
        }
        excludeFolders = @("node_modules", ".git", "dist", "build", ".next", "__pycache__")
        isFirstRun = $true
    }
}

$isFirstRun = $config.isFirstRun -eq $true -or [string]::IsNullOrEmpty($config.projectPath)

# =============== WELCOME WIZARD ===============
if ($isFirstRun) {
    $welcomeForm = New-Object System.Windows.Forms.Form
    $welcomeForm.Text = "Welcome to Backup Pro"
    $welcomeForm.Size = New-Object System.Drawing.Size(550, 500)
    $welcomeForm.StartPosition = "CenterScreen"
    $welcomeForm.FormBorderStyle = "FixedDialog"
    $welcomeForm.MaximizeBox = $false
    $welcomeForm.BackColor = $colors.Background
    
    # Logo area
    $logoPath = Join-Path $rootDir "logo.ico"
    if (Test-Path $logoPath) {
        $logoBox = New-Object System.Windows.Forms.PictureBox
        $logoBox.ImageLocation = $logoPath
        $logoBox.SizeMode = [System.Windows.Forms.PictureBoxSizeMode]::Zoom
        $logoBox.Location = New-Object System.Drawing.Point(175, 20)
        $logoBox.Size = New-Object System.Drawing.Size(200, 60)
        $welcomeForm.Controls.Add($logoBox)
    } else {
        $logoLabel = New-Object System.Windows.Forms.Label
        $logoLabel.Text = "BACKUP PRO"
        $logoLabel.Font = New-Object System.Drawing.Font("Segoe UI", 28, [System.Drawing.FontStyle]::Bold)
        $logoLabel.ForeColor = $colors.Accent
        $logoLabel.Location = New-Object System.Drawing.Point(30, 30)
        $logoLabel.Size = New-Object System.Drawing.Size(490, 50)
        $logoLabel.TextAlign = "MiddleCenter"
        $welcomeForm.Controls.Add($logoLabel)
    }
    
    $tagline = New-Object System.Windows.Forms.Label
    $tagline.Text = "Automatic Project Backups Made Easy"
    $tagline.Font = New-Object System.Drawing.Font("Segoe UI", 11)
    $tagline.ForeColor = $colors.TextDim
    $tagline.Location = New-Object System.Drawing.Point(30, 85)
    $tagline.Size = New-Object System.Drawing.Size(490, 25)
    $tagline.TextAlign = "MiddleCenter"
    $welcomeForm.Controls.Add($tagline)
    
    # Features Panel
    $featuresPanel = New-Object System.Windows.Forms.Panel
    $featuresPanel.Location = New-Object System.Drawing.Point(40, 130)
    $featuresPanel.Size = New-Object System.Drawing.Size(460, 250)
    $featuresPanel.BackColor = $colors.Card
    $welcomeForm.Controls.Add($featuresPanel)
    
    $featuresTitle = New-Object System.Windows.Forms.Label
    $featuresTitle.Text = "What you get:"
    $featuresTitle.Font = New-Object System.Drawing.Font("Segoe UI", 12, [System.Drawing.FontStyle]::Bold)
    $featuresTitle.ForeColor = $colors.Text
    $featuresTitle.Location = New-Object System.Drawing.Point(20, 15)
    $featuresTitle.Size = New-Object System.Drawing.Size(420, 25)
    $featuresPanel.Controls.Add($featuresTitle)
    
    $features = @(
        "Daily popup reminders at your preferred time",
        "Smart backup - excludes node_modules, .git, etc.",
        "Flexible scheduling - different times per day",
        "Auto-cleanup - keeps only last N backups",
        "One-click sharing via Email or File Explorer",
        "Completely free and open source"
    )
    
    $y = 50
    foreach ($feature in $features) {
        $featureLabel = New-Object System.Windows.Forms.Label
        $featureLabel.Text = "  $feature"
        $featureLabel.Font = New-Object System.Drawing.Font("Segoe UI", 10)
        $featureLabel.ForeColor = $colors.Text
        $featureLabel.Location = New-Object System.Drawing.Point(20, $y)
        $featureLabel.Size = New-Object System.Drawing.Size(420, 28)
        $featuresPanel.Controls.Add($featureLabel)
        $y += 32
    }
    
    # Get Started Button
    $btnGetStarted = New-Object System.Windows.Forms.Button
    $btnGetStarted.Text = "Get Started"
    $btnGetStarted.Font = New-Object System.Drawing.Font("Segoe UI", 12, [System.Drawing.FontStyle]::Bold)
    $btnGetStarted.Location = New-Object System.Drawing.Point(175, 400)
    $btnGetStarted.Size = New-Object System.Drawing.Size(200, 50)
    $btnGetStarted.BackColor = $colors.Accent
    $btnGetStarted.ForeColor = $colors.Background
    $btnGetStarted.FlatStyle = "Flat"
    $btnGetStarted.FlatAppearance.BorderSize = 0
    $btnGetStarted.Cursor = "Hand"
    $btnGetStarted.Add_Click({ $welcomeForm.Close() })
    $welcomeForm.Controls.Add($btnGetStarted)
    
    [void]$welcomeForm.ShowDialog()
}

# =============== MAIN SETUP FORM ===============
$form = New-Object System.Windows.Forms.Form
$form.Text = "Backup Pro - Settings"
$form.Size = New-Object System.Drawing.Size(620, 720)
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = "FixedDialog"
$form.MaximizeBox = $false
$form.BackColor = $colors.Background
$form.Font = New-Object System.Drawing.Font("Segoe UI", 10)

# Header
$logoPath = Join-Path $rootDir "logo.ico"
if (Test-Path $logoPath) {
    $logoBox = New-Object System.Windows.Forms.PictureBox
    $logoBox.ImageLocation = $logoPath
    $logoBox.SizeMode = [System.Windows.Forms.PictureBoxSizeMode]::Zoom
    $logoBox.Location = New-Object System.Drawing.Point(20, 15)
    $logoBox.Size = New-Object System.Drawing.Size(50, 50)
    $form.Controls.Add($logoBox)

    $header = New-Object System.Windows.Forms.Label
    $header.Text = "BACKUP PRO"
    $header.Font = New-Object System.Drawing.Font("Segoe UI", 20, [System.Drawing.FontStyle]::Bold)
    $header.ForeColor = $colors.Accent
    $header.Location = New-Object System.Drawing.Point(80, 20)
    $header.Size = New-Object System.Drawing.Size(300, 40)
    $form.Controls.Add($header)
} else {
    $header = New-Object System.Windows.Forms.Label
    $header.Text = "BACKUP PRO"
    $header.Font = New-Object System.Drawing.Font("Segoe UI", 20, [System.Drawing.FontStyle]::Bold)
    $header.ForeColor = $colors.Accent
    $header.Location = New-Object System.Drawing.Point(20, 15)
    $header.Size = New-Object System.Drawing.Size(300, 40)
    $form.Controls.Add($header)
}

$subHeader = New-Object System.Windows.Forms.Label
$subHeader.Text = "Configure your backup settings"
$subHeader.ForeColor = $colors.TextDim
$subHeader.Location = New-Object System.Drawing.Point(22, 55)
$subHeader.Size = New-Object System.Drawing.Size(400, 20)
$form.Controls.Add($subHeader)

# ===== PROJECT SETTINGS =====
$y = 90

$lblProject = New-Object System.Windows.Forms.Label
$lblProject.Text = "PROJECT FOLDER"
$lblProject.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
$lblProject.ForeColor = $colors.TextDim
$lblProject.Location = New-Object System.Drawing.Point(20, $y)
$lblProject.Size = New-Object System.Drawing.Size(200, 20)
$form.Controls.Add($lblProject)

$txtProject = New-Object System.Windows.Forms.TextBox
$txtProject.Text = $config.projectPath
$txtProject.Location = New-Object System.Drawing.Point(20, ($y + 22))
$txtProject.Size = New-Object System.Drawing.Size(480, 28)
$txtProject.BackColor = $colors.Input
$txtProject.ForeColor = $colors.Text
$txtProject.BorderStyle = "FixedSingle"
$form.Controls.Add($txtProject)

$btnBrowseProject = New-Object System.Windows.Forms.Button
$btnBrowseProject.Text = "Browse"
$btnBrowseProject.Location = New-Object System.Drawing.Point(510, ($y + 21))
$btnBrowseProject.Size = New-Object System.Drawing.Size(80, 28)
$btnBrowseProject.BackColor = $colors.Card
$btnBrowseProject.ForeColor = $colors.Text
$btnBrowseProject.FlatStyle = "Flat"
$btnBrowseProject.FlatAppearance.BorderColor = $colors.Accent
$btnBrowseProject.Add_Click({
    $folder = New-Object System.Windows.Forms.FolderBrowserDialog
    if ($folder.ShowDialog() -eq "OK") { $txtProject.Text = $folder.SelectedPath }
})
$form.Controls.Add($btnBrowseProject)

$y += 65

$lblBackup = New-Object System.Windows.Forms.Label
$lblBackup.Text = "BACKUP DESTINATION"
$lblBackup.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
$lblBackup.ForeColor = $colors.TextDim
$lblBackup.Location = New-Object System.Drawing.Point(20, $y)
$lblBackup.Size = New-Object System.Drawing.Size(200, 20)
$form.Controls.Add($lblBackup)

$txtBackup = New-Object System.Windows.Forms.TextBox
$txtBackup.Text = $config.backupFolder
$txtBackup.Location = New-Object System.Drawing.Point(20, ($y + 22))
$txtBackup.Size = New-Object System.Drawing.Size(480, 28)
$txtBackup.BackColor = $colors.Input
$txtBackup.ForeColor = $colors.Text
$txtBackup.BorderStyle = "FixedSingle"
$form.Controls.Add($txtBackup)

$btnBrowseBackup = New-Object System.Windows.Forms.Button
$btnBrowseBackup.Text = "Browse"
$btnBrowseBackup.Location = New-Object System.Drawing.Point(510, ($y + 21))
$btnBrowseBackup.Size = New-Object System.Drawing.Size(80, 28)
$btnBrowseBackup.BackColor = $colors.Card
$btnBrowseBackup.ForeColor = $colors.Text
$btnBrowseBackup.FlatStyle = "Flat"
$btnBrowseBackup.FlatAppearance.BorderColor = $colors.Accent
$btnBrowseBackup.Add_Click({
    $folder = New-Object System.Windows.Forms.FolderBrowserDialog
    if ($folder.ShowDialog() -eq "OK") { $txtBackup.Text = $folder.SelectedPath }
})
$form.Controls.Add($btnBrowseBackup)

$y += 65

# Project Name and Max Backups
$lblName = New-Object System.Windows.Forms.Label
$lblName.Text = "PROJECT NAME"
$lblName.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
$lblName.ForeColor = $colors.TextDim
$lblName.Location = New-Object System.Drawing.Point(20, $y)
$lblName.Size = New-Object System.Drawing.Size(200, 20)
$form.Controls.Add($lblName)

$txtName = New-Object System.Windows.Forms.TextBox
$txtName.Text = $config.projectName
$txtName.Location = New-Object System.Drawing.Point(20, ($y + 22))
$txtName.Size = New-Object System.Drawing.Size(200, 28)
$txtName.BackColor = $colors.Input
$txtName.ForeColor = $colors.Text
$txtName.BorderStyle = "FixedSingle"
$form.Controls.Add($txtName)

$lblKeep = New-Object System.Windows.Forms.Label
$lblKeep.Text = "KEEP BACKUPS"
$lblKeep.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
$lblKeep.ForeColor = $colors.TextDim
$lblKeep.Location = New-Object System.Drawing.Point(250, $y)
$lblKeep.Size = New-Object System.Drawing.Size(120, 20)
$form.Controls.Add($lblKeep)

$txtKeep = New-Object System.Windows.Forms.TextBox
$txtKeep.Text = $config.maxBackups
$txtKeep.Location = New-Object System.Drawing.Point(250, ($y + 22))
$txtKeep.Size = New-Object System.Drawing.Size(60, 28)
$txtKeep.BackColor = $colors.Input
$txtKeep.ForeColor = $colors.Text
$txtKeep.BorderStyle = "FixedSingle"
$form.Controls.Add($txtKeep)

# ===== SCHEDULE SECTION =====
$y += 75

$scheduleHeader = New-Object System.Windows.Forms.Label
$scheduleHeader.Text = "SCHEDULE"
$scheduleHeader.Font = New-Object System.Drawing.Font("Segoe UI", 11, [System.Drawing.FontStyle]::Bold)
$scheduleHeader.ForeColor = $colors.Accent
$scheduleHeader.Location = New-Object System.Drawing.Point(20, $y)
$scheduleHeader.Size = New-Object System.Drawing.Size(200, 25)
$form.Controls.Add($scheduleHeader)

$y += 30

$days = @("Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday")
$dayKeys = @("monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday")
$checkboxes = @{}
$timeboxes = @{}

foreach ($i in 0..6) {
    $day = $days[$i]
    $key = $dayKeys[$i]
    $scheduleData = $config.schedule.$key
    
    $chk = New-Object System.Windows.Forms.CheckBox
    $chk.Text = $day
    $chk.Checked = $scheduleData.enabled
    $chk.ForeColor = $colors.Text
    $chk.Location = New-Object System.Drawing.Point(20, $y)
    $chk.Size = New-Object System.Drawing.Size(110, 24)
    $form.Controls.Add($chk)
    $checkboxes[$key] = $chk
    
    $txt = New-Object System.Windows.Forms.TextBox
    $txt.Text = $scheduleData.time
    $txt.Location = New-Object System.Drawing.Point(140, $y)
    $txt.Size = New-Object System.Drawing.Size(65, 24)
    $txt.BackColor = $colors.Input
    $txt.ForeColor = $colors.Text
    $txt.BorderStyle = "FixedSingle"
    $form.Controls.Add($txt)
    $timeboxes[$key] = $txt
    
    $y += 28
}

# ===== ACTION BUTTONS =====
$y += 20

$btnSave = New-Object System.Windows.Forms.Button
$btnSave.Text = "Save Settings"
$btnSave.Location = New-Object System.Drawing.Point(20, $y)
$btnSave.Size = New-Object System.Drawing.Size(135, 42)
$btnSave.BackColor = $colors.Accent
$btnSave.ForeColor = $colors.Background
$btnSave.FlatStyle = "Flat"
$btnSave.FlatAppearance.BorderSize = 0
$btnSave.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$form.Controls.Add($btnSave)

$btnInstall = New-Object System.Windows.Forms.Button
$btnInstall.Text = "Install Schedule"
$btnInstall.Location = New-Object System.Drawing.Point(165, $y)
$btnInstall.Size = New-Object System.Drawing.Size(135, 42)
$btnInstall.BackColor = $colors.Card
$btnInstall.ForeColor = $colors.Text
$btnInstall.FlatStyle = "Flat"
$btnInstall.FlatAppearance.BorderColor = $colors.Accent
$btnInstall.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$form.Controls.Add($btnInstall)

$btnBackupNow = New-Object System.Windows.Forms.Button
$btnBackupNow.Text = "Backup Now"
$btnBackupNow.Location = New-Object System.Drawing.Point(310, $y)
$btnBackupNow.Size = New-Object System.Drawing.Size(135, 42)
$btnBackupNow.BackColor = $colors.Success
$btnBackupNow.ForeColor = $colors.Background
$btnBackupNow.FlatStyle = "Flat"
$btnBackupNow.FlatAppearance.BorderSize = 0
$btnBackupNow.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$form.Controls.Add($btnBackupNow)

$btnUninstall = New-Object System.Windows.Forms.Button
$btnUninstall.Text = "Remove"
$btnUninstall.Location = New-Object System.Drawing.Point(455, $y)
$btnUninstall.Size = New-Object System.Drawing.Size(135, 42)
$btnUninstall.BackColor = $colors.Danger
$btnUninstall.ForeColor = $colors.Text
$btnUninstall.FlatStyle = "Flat"
$btnUninstall.FlatAppearance.BorderSize = 0
$btnUninstall.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$form.Controls.Add($btnUninstall)

$y += 55

# Status Label
$lblStatus = New-Object System.Windows.Forms.Label
$lblStatus.Text = ""
$lblStatus.ForeColor = $colors.Success
$lblStatus.Location = New-Object System.Drawing.Point(20, $y)
$lblStatus.Size = New-Object System.Drawing.Size(570, 25)
$form.Controls.Add($lblStatus)

# ===== BUTTON ACTIONS =====

$btnSave.Add_Click({
    $newConfig = [ordered]@{
        projectPath = $txtProject.Text
        backupFolder = $txtBackup.Text
        projectName = $txtName.Text
        maxBackups = [int]$txtKeep.Text
        winrarPath = $config.winrarPath
        excludeFolders = @("node_modules", ".git", "dist", "build", ".next", "__pycache__")
        isFirstRun = $false
        schedule = [ordered]@{}
    }
    
    foreach ($key in $dayKeys) {
        $newConfig.schedule[$key] = [ordered]@{
            enabled = $checkboxes[$key].Checked
            time = $timeboxes[$key].Text
        }
    }
    
    $jsonContent = $newConfig | ConvertTo-Json -Depth 5
    [System.IO.File]::WriteAllText($configPath, $jsonContent, [System.Text.UTF8Encoding]::new($false))
    $lblStatus.Text = "Settings saved successfully!"
    $lblStatus.ForeColor = $colors.Success
})

$btnInstall.Add_Click({
    $lblStatus.Text = "Installing scheduled tasks..."
    $lblStatus.ForeColor = $colors.Warning
    $form.Refresh()
    
    try {
        $installScript = Join-Path $scriptDir "install.ps1"
        Start-Process powershell -ArgumentList "-ExecutionPolicy Bypass -File `"$installScript`"" -Wait -WindowStyle Hidden
        $lblStatus.Text = "Schedule installed! Popups will appear at configured times."
        $lblStatus.ForeColor = $colors.Success
    } catch {
        $lblStatus.Text = "Failed to install: " + $_.Exception.Message
        $lblStatus.ForeColor = $colors.Danger
    }
})

$btnBackupNow.Add_Click({
    $lblStatus.Text = "Creating backup... Please wait."
    $lblStatus.ForeColor = $colors.Warning
    $form.Refresh()
    
    $backupScript = Join-Path $rootDir "backup.js"
    $process = Start-Process -FilePath "node" -ArgumentList "`"$backupScript`"" -WorkingDirectory $rootDir -Wait -PassThru
    
    if ($process.ExitCode -eq 0) {
        # Show success dialog with share options
        $shareForm = New-Object System.Windows.Forms.Form
        $shareForm.Text = "Backup Complete!"
        $shareForm.Size = New-Object System.Drawing.Size(450, 300)
        $shareForm.StartPosition = "CenterScreen"
        $shareForm.FormBorderStyle = "FixedDialog"
        $shareForm.MaximizeBox = $false
        $shareForm.BackColor = $colors.Background
        
        $successIcon = New-Object System.Windows.Forms.Label
        $successIcon.Text = "BACKUP SUCCESSFUL"
        $successIcon.Font = New-Object System.Drawing.Font("Segoe UI", 16, [System.Drawing.FontStyle]::Bold)
        $successIcon.ForeColor = $colors.Success
        $successIcon.Location = New-Object System.Drawing.Point(20, 25)
        $successIcon.Size = New-Object System.Drawing.Size(400, 35)
        $successIcon.TextAlign = "MiddleCenter"
        $shareForm.Controls.Add($successIcon)
        
        $successMsg = New-Object System.Windows.Forms.Label
        $successMsg.Text = "Your project backup has been created.`nHow would you like to share it?"
        $successMsg.Font = New-Object System.Drawing.Font("Segoe UI", 10)
        $successMsg.ForeColor = $colors.Text
        $successMsg.Location = New-Object System.Drawing.Point(20, 70)
        $successMsg.Size = New-Object System.Drawing.Size(400, 45)
        $successMsg.TextAlign = "MiddleCenter"
        $shareForm.Controls.Add($successMsg)
        
        $btnOpenFolder = New-Object System.Windows.Forms.Button
        $btnOpenFolder.Text = "Open Folder"
        $btnOpenFolder.Location = New-Object System.Drawing.Point(30, 130)
        $btnOpenFolder.Size = New-Object System.Drawing.Size(120, 45)
        $btnOpenFolder.BackColor = $colors.Accent
        $btnOpenFolder.ForeColor = $colors.Background
        $btnOpenFolder.FlatStyle = "Flat"
        $btnOpenFolder.FlatAppearance.BorderSize = 0
        $btnOpenFolder.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
        $btnOpenFolder.Add_Click({
            Start-Process explorer $txtBackup.Text
        })
        $shareForm.Controls.Add($btnOpenFolder)
        
        $btnEmail = New-Object System.Windows.Forms.Button
        $btnEmail.Text = "Send Email"
        $btnEmail.Location = New-Object System.Drawing.Point(160, 130)
        $btnEmail.Size = New-Object System.Drawing.Size(120, 45)
        $btnEmail.BackColor = $colors.Card
        $btnEmail.ForeColor = $colors.Text
        $btnEmail.FlatStyle = "Flat"
        $btnEmail.FlatAppearance.BorderColor = $colors.Accent
        $btnEmail.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
        $btnEmail.Add_Click({
            $subject = [System.Web.HttpUtility]::UrlEncode("Project Backup - " + $txtName.Text)
            $body = [System.Web.HttpUtility]::UrlEncode("Please find the project backup attached.")
            Start-Process "mailto:?subject=$subject&body=$body"
            [System.Windows.Forms.MessageBox]::Show("Email client opened. Please attach the backup file from:`n`n" + $txtBackup.Text, "Attach Backup", "OK", "Information")
        })
        $shareForm.Controls.Add($btnEmail)
        
        $btnCopyPath = New-Object System.Windows.Forms.Button
        $btnCopyPath.Text = "Copy Path"
        $btnCopyPath.Location = New-Object System.Drawing.Point(290, 130)
        $btnCopyPath.Size = New-Object System.Drawing.Size(120, 45)
        $btnCopyPath.BackColor = $colors.Card
        $btnCopyPath.ForeColor = $colors.Text
        $btnCopyPath.FlatStyle = "Flat"
        $btnCopyPath.FlatAppearance.BorderColor = $colors.Accent
        $btnCopyPath.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
        $btnCopyPath.Add_Click({
            [System.Windows.Forms.Clipboard]::SetText($txtBackup.Text)
            [System.Windows.Forms.MessageBox]::Show("Backup folder path copied to clipboard!", "Copied", "OK", "Information")
        })
        $shareForm.Controls.Add($btnCopyPath)
        
        $btnClose = New-Object System.Windows.Forms.Button
        $btnClose.Text = "Close"
        $btnClose.Location = New-Object System.Drawing.Point(160, 200)
        $btnClose.Size = New-Object System.Drawing.Size(120, 40)
        $btnClose.BackColor = $colors.Card
        $btnClose.ForeColor = $colors.TextDim
        $btnClose.FlatStyle = "Flat"
        $btnClose.Add_Click({ $shareForm.Close() })
        $shareForm.Controls.Add($btnClose)
        
        [void]$shareForm.ShowDialog()
        
        $lblStatus.Text = "Backup complete!"
        $lblStatus.ForeColor = $colors.Success
    } else {
        $lblStatus.Text = "Backup failed. Check if WinRAR is installed."
        $lblStatus.ForeColor = $colors.Danger
    }
})

$btnUninstall.Add_Click({
    $result = [System.Windows.Forms.MessageBox]::Show(
        "Remove all scheduled backup tasks?",
        "Confirm",
        "YesNo",
        "Question"
    )
    
    if ($result -eq "Yes") {
        $uninstallScript = Join-Path $scriptDir "uninstall.ps1"
        Start-Process powershell -ArgumentList "-ExecutionPolicy Bypass -File `"$uninstallScript`"" -Wait -WindowStyle Hidden
        $lblStatus.Text = "Scheduled tasks removed."
        $lblStatus.ForeColor = $colors.Success
    }
})

# Show Form
[void]$form.ShowDialog()
