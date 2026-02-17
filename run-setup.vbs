' Backup Pro - Final Launcher
On Error Resume Next
Set shell = CreateObject("WScript.Shell")
Set fso = CreateObject("Scripting.FileSystemObject")

' Get the directory where THIS script is located (app folder)
appDir = fso.GetParentFolderName(WScript.ScriptFullName)
' Move up to root and then into bin for node
binDir = fso.BuildPath(fso.GetParentFolderName(appDir), "bin")
scriptPs1 = fso.BuildPath(fso.BuildPath(appDir, "scripts"), "setup-gui.ps1")

If fso.FileExists(scriptPs1) Then
    ' Run PowerShell GUI (WindowStyle 1 = Normal, but we can use 0 for hidden if we want it silent)
    ' However, for a GUI setup, we want the window visible.
    ' Actually, the VBS launcher runner (shell.Run) can control this.
    ' We use powershell -WindowStyle Visible to ensure the WinForm appears.
    cmd = "powershell.exe -ExecutionPolicy Bypass -File """ & scriptPs1 & """"
    shell.Run cmd, 1, False
Else
    MsgBox "Critical Error: Backup Pro files missing." & vbCrLf & _
           "Looking for:" & vbCrLf & _
           "- " & nodeExe & vbCrLf & _
           "- " & scriptJs, 16, "Launch Error"
End If
