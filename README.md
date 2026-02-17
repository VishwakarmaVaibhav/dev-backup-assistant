# Backup Pro 📂🚀

**Backup Pro** is a robust, cross-platform backup solution designed for **developers and students**. It automatically zips your project folders and stores them in a designated backup location, keeping multiple versions safe.

![Windows](https://img.shields.io/badge/Windows-10%2F11-0078D6?style=for-the-badge&logo=windows&logoColor=white)
![macOS](https://img.shields.io/badge/macOS-Default-000000?style=for-the-badge&logo=apple&logoColor=white)
![Node.js](https://img.shields.io/badge/Node.js-14%2B-339933?style=for-the-badge&logo=nodedotjs&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)

It features a **modern, Dark Mode Web UI** for configuration on both **macOS** and **Windows**, running locally on your machine.

---

## ✨ Features

- **Cross-Platform**: Works on macOS, Windows, and Linux.
- **Smart Scheduling**: Set daily backups at specific times (e.g. 18:00 on weekdays).
- **Visual Setup UI**: No more editing JSON files manually!
- **Incremental Archives**: Keeps `N` versions of your backups.
- **Recursion Protection**: Smartly excludes the backup folder if it's inside the project.
- **Email Integration**: Easily email your latest backup (supports Outlook, Mail.app).
- **Native Experience**:
  - **macOS**: `Install.app` launches a silent setup window.
  - **Windows**: `Install.bat` provides a native experience.

### 🕒 **Flexible Daily Schedule**
Set different backup times for different days. Working late on Friday but relaxing on Sunday? Configure it exactly how you work.

### 🧠 **Smart Exclusions**
Automatically skips heavy folders like:
- `node_modules`
- `.git`
- `dist` / `build`
- `.next`
- `__pycache__`

### 🧹 **Auto-Cleanup**
Keeps your drive clean by retaining only the last **N** backups (configurable, default: 10).

### 📤 **One-Click Sharing**
After a backup, instantly:
- 📂 Open the folder
- 📧 Send via Email
- 📋 Copy path to clipboard

---

## 📸 Screenshots

*(Add screenshots of the Web UI and Windows GUI here)*

---

## 🚀 Installation

### 🍎 macOS

1. Download the latest release (`Backup-Pro-Mac.zip`) and unzip it.

2. **First time only:** Open **Terminal** and paste this command:
   ```bash
   cd ~/Downloads/backup-pro-mac && xattr -cr . && chmod +x *.sh scripts/*.sh && open Install.app
   ```
   *(This removes download restrictions and opens the installer)*

3. **After that**, just double-click `Install.app` anytime - it will work normally!

4. The **Setup UI** will open in your browser.
5. Configure your folders, schedule, and click **"Install Schedule"**.

### 🪟 Windows

#### Option 1: Download & Run (Recommended)
1. Download the latest **[Backup-Pro-Win.zip](https://github.com/VishwakarmaVaibhav/dev-backup-assistant/releases)**.
2. Extract the folder.
3. Double-click **`Install.bat`**.
   - It will check requirements (Node.js, WinRAR).
   - Install dependencies.
   - Create a desktop shortcut.

#### Option 2: For Developers (Git)
```bash
git clone https://github.com/VishwakarmaVaibhav/dev-backup-assistant.git
cd dev-backup-assistant
npm install
node setup.js
```

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

## ⚙️ Configuration

Your settings are saved in `config.json`. You can edit it manually if you prefer, but the Web UI is recommended.

```json
{
  "projectPath": "/path/to/project",
  "backupFolder": "/path/to/backups",
  "schedule": {
    "monday": { "enabled": true, "time": "18:00" },
    "saturday": { "enabled": true, "time": "12:00" }
  }
}
```

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

---

**Made with ❤️ by [Vaibhav](https://github.com/VishwakarmaVaibhav)**

## 🚀 Deployment Status

[![Deploy with Vercel](https://vercel.com/button)](https://vercel.com/new/clone?repository-url=https%3A%2F%2Fgithub.com%2FVishwakarmaVaibhav%2Fdev-backup-assistant%2Ftree%2Fmain%2Fweb-portal)

The Web Portal is designed to be deployed on Vercel. Ensure `Root Directory` is set to `web-portal`.
