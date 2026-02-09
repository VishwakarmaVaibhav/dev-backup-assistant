@echo off
title Backup Pro - Installer
mode con: cols=60 lines=35
color 0B
cls

echo.
echo   ========================================
echo        BACKUP PRO - INSTALLER
echo   ========================================
echo.
echo   Welcome to Backup Pro!
echo.
echo   This installer will:
echo     [1] Check system requirements
echo     [2] Install dependencies
echo     [3] Create desktop shortcut (with logo.ico support)
echo     [4] Launch the application
echo.
echo   ----------------------------------------
echo   TIP: Add a 'logo.ico' file to this folder 
echo        for custom branding!
echo   ----------------------------------------
pause

cls
echo.
echo   ========================================
echo        CHECKING REQUIREMENTS
echo   ========================================
echo.

:: Check if Node.js is installed
where node >nul 2>nul
if %errorlevel% neq 0 (
    echo   [X] Node.js is NOT installed
    echo.
    echo   Node.js is required to run Backup Pro.
    echo.
    echo   Opening Node.js download page...
    echo.
    start https://nodejs.org/en/download/
    echo   Please:
    echo     1. Install Node.js from the opened page
    echo     2. Restart your computer
    echo     3. Run this installer again
    echo.
    pause
    exit /b 1
)

echo   [OK] Node.js found
for /f "tokens=*" %%i in ('node -v') do set NODE_VERSION=%%i
echo        Version: %NODE_VERSION%
echo.

:: Check if WinRAR is installed (using flag-based approach)
set "WINRAR_FOUND=0"

if exist "C:\Program Files\WinRAR\rar.exe" (
    echo   [OK] WinRAR found ^(64-bit^)
    set "WINRAR_FOUND=1"
)

if exist "C:\Program Files (x86)\WinRAR\rar.exe" (
    echo   [OK] WinRAR found ^(32-bit^)
    set "WINRAR_FOUND=1"
)

if "%WINRAR_FOUND%"=="0" (
    echo   [!] WinRAR not found
    echo.
    echo   WinRAR is required for creating backups.
    echo   Opening WinRAR download page...
    start https://www.win-rar.com/download.html
    echo.
    echo   Please install WinRAR and run this again.
    echo.
    pause
    exit /b 1
)
echo.

echo   ----------------------------------------
echo.

:: Install npm dependencies
echo   Installing dependencies...
cd /d "%~dp0"
call npm install --silent 2>nul
if %errorlevel% neq 0 (
    echo   [!] Dependency installation failed
    echo       Trying again...
    call npm install
)
echo   [OK] Dependencies installed
echo.

:: Create desktop shortcut
echo   Creating desktop shortcut...
set SCRIPT="%TEMP%\CreateShortcut.vbs"
echo Set oWS = WScript.CreateObject("WScript.Shell") > %SCRIPT%
echo sLinkFile = oWS.SpecialFolders("Desktop") ^& "\Backup Pro.lnk" >> %SCRIPT%
echo Set oLink = oWS.CreateShortcut(sLinkFile) >> %SCRIPT%
echo oLink.TargetPath = "%~dp0Setup.bat" >> %SCRIPT%
echo oLink.WorkingDirectory = "%~dp0" >> %SCRIPT%
echo oLink.Description = "Backup Pro - Automatic Project Backups" >> %SCRIPT%
if exist "%~dp0logo.ico" (
    echo oLink.IconLocation = "%~dp0logo.ico" >> %SCRIPT%
)
echo oLink.Save >> %SCRIPT%
cscript /nologo %SCRIPT%
del %SCRIPT%
echo   [OK] Desktop shortcut created
echo.

echo   ========================================
echo        INSTALLATION COMPLETE!
echo   ========================================
echo.
echo   A shortcut "Backup Pro" has been added
echo   to your Desktop!
echo.
echo   The application will now launch.
echo.
echo   ----------------------------------------
timeout /t 3 >nul

:: Launch the app
start "" powershell -ExecutionPolicy Bypass -File "%~dp0scripts\setup-gui.ps1"
