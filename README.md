# 📦 Backup Pro - Developer's Safety Net

> **Automatic, flexible, and smart project backups for Windows developers.**

![Windows](https://img.shields.io/badge/Windows-10%2F11-0078D6?style=for-the-badge&logo=windows&logoColor=white)
![Node.js](https://img.shields.io/badge/Node.js-14%2B-339933?style=for-the-badge&logo=nodedotjs&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)

**Stop worrying about losing code.** Backup Pro runs silently in the background, reminds you to backup daily, and keeps your project safe without bloating your drive.

---

## ✨ Features

### 🕒 **Flexible Daily Schedule**
Set different backup times for different days. Working late on Friday but relaxing on Sunday? Configure it exactly how you work.

### 🧠 **Smart Exclusions**
automatically skips heavy folders like:
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

### 🎨 **Beautiful Dark UI**
A modern, dark-themed interface that feels right at home on a developer's machine.

---

## 🚀 Installation

### Option 1: Download & Run (Recommended)
1. Download the latest **[Backup-Pro.zip](https://github.com/VishwakarmaVaibhav/dev-backup-assistant/releases)**.
2. Extract the folder.
3. Double-click **`Install.bat`**.
   - It will check requirements (Node.js, WinRAR).
   - Install dependencies.
   - Create a desktop shortcut.

### Option 2: For Developers (Git)
```bash
git clone https://github.com/VishwakarmaVaibhav/dev-backup-assistant.git
cd backup-pro
npm install
```
Then run **`Setup.bat`** to launch.

---

## 📖 How to Use

1. **Launch Backup Pro** from your desktop.
2. **First Run:** You'll see a Welcome Wizard. Click "Get Started".
3. **Configure:**
   - Select your **Project Folder** (Source).
   - Select your **Backup Folder** (Destination).
   - Set your **Schedule** (Enable/Disable days + Time).
4. Click **Save Settings**.
5. Click **Install Schedule** to enable automatic popups.

That's it! You'll get a popup at your scheduled time asking if you want to backup.

---

## ⚙️ Configuration

Your settings are saved in `config.json`. You can edit it manually if you prefer:

```json
{
  "projectPath": "D:\\Projects\\MySuperApp",
  "backupFolder": "D:\\Backups",
  "schedule": {
    "monday": { "enabled": true, "time": "18:00" },
    "saturday": { "enabled": true, "time": "12:00" },
    "sunday": { "enabled": false, "time": "18:00" }
  }
}
```

---

## 🛠️ Requirements

- **Windows 10 or 11**
- **Node.js** (Installed automatically if missing)
- **WinRAR** (Default path: `C:\Program Files\WinRAR\rar.exe`)

---

## 🤝 Contributing

Got a better idea?
1. Fork it
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📄 License

Distributed under the MIT License. See `LICENSE` for more information.

---

**Made with ❤️ by [Vaibhav](https://github.com/VishwakarmaVaibhav)**
