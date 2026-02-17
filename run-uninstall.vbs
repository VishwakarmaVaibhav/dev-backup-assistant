' Backup Pro - Silent Uninstaller
On Error Resume Next
Set shell = CreateObject("WScript.Shell")
Set fso = CreateObject("Scripting.FileSystemObject")

' Get app directory
appDir = fso.GetParentFolderName(WScript.ScriptFullName)
uninstallPs1 = fso.BuildPath(fso.BuildPath(appDir, "scripts"), "uninstall.ps1")

If fso.FileExists(uninstallPs1) Then
    ' Run powershell uninstall script hidden
    cmd = "powershell.exe -ExecutionPolicy Bypass -File """ & uninstallPs1 & """"
    shell.Run cmd, 0, True
End If
