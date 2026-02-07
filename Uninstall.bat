@echo off
title Uninstall Backup Pro
color 0C
cls

echo.
echo   ========================================
echo        BACKUP PRO - UNINSTALLER
echo   ========================================
echo.
echo   This will remove:
echo     [1] Desktop shortcut
echo     [2] Scheduled backup tasks
echo     [3] Configuration settings (optional)
echo.

set /p CONFIRM="   Are you sure? (Y/N): "
if /i not "%CONFIRM%"=="Y" exit

echo.
echo   Removing scheduled tasks...
powershell -ExecutionPolicy Bypass -File "%~dp0scripts\uninstall.ps1"

echo   Removing desktop shortcut...
if exist "%USERPROFILE%\Desktop\Backup Pro.lnk" del "%USERPROFILE%\Desktop\Backup Pro.lnk"

echo.
echo   [OK] Uninstallation complete.
echo   You can now delete this folder manually.
echo.
pause
