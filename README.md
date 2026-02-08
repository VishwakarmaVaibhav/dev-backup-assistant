# Backup Pro 📂🚀

**Backup Pro** is a robust, cross-platform backup solution designed for **developers and students**. It automatically zips your project folders and stores them in a designated backup location, keeping multiple versions safe.

It features a **modern, Dark Mode Web UI** for configuration on both **macOS** and **Windows**, running locally on your machine.

---

## ✨ Features

- **Cross-Platform**: Works on macOS, Windows, and Linux.
- **Smart Scheduling**: Set daily backups at specific times.
- **Visual Setup UI**: No more editing JSON files manually!
- **Incremental Archives**: Keeps `N` versions of your backups.
- **Recursion Protection**: Smartly excludes the backup folder if it's inside the project.
- **Email Integration**: Easily email your latest backup (supports Outlook, Mail.app).
- **Native Experience**:
  - **macOS**: `Install.app` launches a silent setup window.
  - **Windows**: `setup-gui.ps1` provides a native form interface.

---

## 📸 Screenshots

*(Add screenshots of the Web UI and Windows GUI here)*

---

## 🚀 Installation

### 🍎 macOS

1. Download the latest release (`Backup-Pro-Mac.zip`).
2. Unzip the file.
3. Double-click **`Install.app`**.
   - *Note: If asked, allow the app to run in System Settings > Security.*
4. The **Setup UI** will open in your browser (App Mode).
5. Configure your folders, schedule, and click **"Install Schedule"**.

### 🪟 Windows

1. Download the repository or release.
2. Right-click `install.bat` and select **"Run as Administrator"**.
3. Follow the GUI prompts to set up your paths and schedule.

---

## 🛠️ Usage

### Manual Backup
- Open the Setup UI and click **"Backup Now"**.
- Or run `node backup.js` in your project folder.

### Configuration
- Launch the installer again to open the UI.
- Change your settings and click **"Save Settings"**.
- If you change the schedule, click **"Install Schedule"** to update the system timer.

### Uninstall
- **macOS**: Run `uninstall.sh`.
- **Windows**: Run `uninstall.bat`.

---

## ⚙️ Tech Stack

- **Node.js**: Core logic (`FS`, `Child Process`).
- **AppleScript / JXA**: MacOS native interactions.
- **PowerShell**: Windows native interactions.
- **HTML/CSS/JS**: Local Web UI.
- **Cron / Task Scheduler**: Automation.

---

## 🏗️ How to Release

### 1. Build macOS Release
Run the build script in terminal:
```bash
./build_release.sh
```
This creates `Backup-Pro-Mac.zip` containing `Install.app` and all necessary scripts.

### 2. Build Windows Release
1. Create a zip file containing the following:
   - `install.bat`
   - `uninstall.bat`
   - `backup.js`, `setup.js`, `package.json`
   - `website/` folder
   - `scripts/` folder (Windows scripts only)
2. Name it `Backup-Pro-Win.zip`.

### 3. Publish to GitHub
1. Go to **Releases** > **Draft a new release**.
2. Tag: `v1.1.0` (Matches package.json).
3. Upload both `Backup-Pro-Mac.zip` and `Backup-Pro-Win.zip`.
4. Publish! 🚀

---

## 📜 License

MIT License. Free to use and modify.
