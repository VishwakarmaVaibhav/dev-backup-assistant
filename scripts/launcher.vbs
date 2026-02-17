' Backup Pro Silent Launcher
Set shell = CreateObject("WScript.Shell")
If WScript.Arguments.Count >= 2 Then
    nodeExe = WScript.Arguments(0)
    scriptJs = WScript.Arguments(1)
    ' Run node with the script hidden (0)
    shell.Run """" & nodeExe & """ """ & scriptJs & """", 0, True
End If
