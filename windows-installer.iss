; Inno Setup Script for Backup Pro
#define MyAppName "Backup Pro"
#define MyAppVersion "1.2.0"
#define MyAppPublisher "Vaibhav"
#define MyAppURL "https://github.com/VishwakarmaVaibhav/dev-backup-assistant"
#define MyAppExeName "BackupPro.exe"

[Setup]
; NOTE: The value of AppId uniquely identifies this application. Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{E8B38F5F-4A9C-4D2A-885E-5D3E8BAE9D8F}
ArchitecturesAllowed=x64
ArchitecturesInstallIn64BitMode=x64
AppName={#MyAppName}
AppVersion={#MyAppVersion}
;AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={autopf}\{#MyAppName}
DisableProgramGroupPage=yes
LicenseFile=dist\app\LICENSE
; Uncomment the following line to run in non administrative install mode (install for current user only.)
;PrivilegesRequired=lowest
OutputDir=dist\output
OutputBaseFilename=Backup-Pro-Setup-v120
SetupIconFile=dist\app\logo.ico
Compression=lzma
SolidCompression=yes
WizardStyle=modern

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
; Bundled Node.js
Source: "dist\bin\node.exe"; DestDir: "{app}\bin"; Flags: ignoreversion
; App Files
Source: "dist\app\*"; DestDir: "{app}\app"; Flags: ignoreversion recursesubdirs createallsubdirs
; Logo for shortcuts
Source: "dist\app\logo.ico"; DestDir: "{app}"; Flags: ignoreversion

[Icons]
Name: "{autoprograms}\{#MyAppName}"; FileName: "{sys}\wscript.exe"; Parameters: """{app}\app\run-setup.vbs"""; WorkingDir: "{app}\app"; IconFilename: "{app}\app\logo.ico"
Name: "{autodesktop}\{#MyAppName}"; FileName: "{sys}\wscript.exe"; Parameters: """{app}\app\run-setup.vbs"""; WorkingDir: "{app}\app"; IconFilename: "{app}\app\logo.ico"; Tasks: desktopicon

[Run]
; Run setup silently after installation
Filename: "{sys}\wscript.exe"; Parameters: """{app}\app\run-setup.vbs"""; Flags: nowait postinstall skipifsilent; Description: "Launch Backup Pro Settings"

[UninstallDelete]
Type: files; Name: "{app}\app\config.json"

[UninstallRun]
; Run the uninstaller script to remove scheduled tasks
Filename: "{sys}\wscript.exe"; Parameters: """{app}\app\run-uninstall.vbs"""; Flags: runhidden

[Registry]
Root: HKCR; Subkey: "backuppro"; ValueType: string; ValueName: ""; ValueData: "URL:Backup Pro Protocol"; Flags: uninsdeletekey
Root: HKCR; Subkey: "backuppro"; ValueType: string; ValueName: "URL Protocol"; ValueData: ""
Root: HKCR; Subkey: "backuppro\DefaultIcon"; ValueType: string; ValueName: ""; ValueData: "{app}\app\logo.ico"
Root: HKCR; Subkey: "backuppro\shell\open\command"; ValueType: string; ValueName: ""; ValueData: """{app}\bin\node.exe"" ""{app}\app\utils\protocol-handler.js"" ""%1"""

[Code]
function InitializeUninstall(): Boolean;
var
  ResultCode: Integer;
begin
  // Terminate any running node processes from our app folder before uninstallation starts
  Exec('powershell.exe', '-Command "Get-Process node -ErrorAction SilentlyContinue | Where-Object {$_.Path -like ''*' + ExpandConstant('{app}') + '*''} | Stop-Process -Force"', '', SW_HIDE, ewWaitUntilTerminated, ResultCode);
  Result := True;
end;

procedure CurPageChanged(CurPageID: Integer);
var
  ResultCode: Integer;
begin
  if CurPageID = wpInstalling then
  begin
    // Terminate any running node processes from our app folder before installation
    Exec('powershell.exe', '-Command "Get-Process node -ErrorAction SilentlyContinue | Where-Object {$_.Path -like ''*' + ExpandConstant('{app}') + '*''} | Stop-Process -Force"', '', SW_HIDE, ewWaitUntilTerminated, ResultCode);
  end;
end;
