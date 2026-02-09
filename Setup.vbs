Set objShell = CreateObject("WScript.Shell")
Set objFSO = CreateObject("Scripting.FileSystemObject")

strScriptPath = objFSO.GetParentFolderName(WScript.ScriptFullName)
strPSScript = strScriptPath & "\scripts\setup-gui.ps1"

objShell.Run "powershell -ExecutionPolicy Bypass -WindowStyle Hidden -File """ & strPSScript & """", 0, False
