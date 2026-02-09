# 🍎 Mac Installation Guide (Gatekeeper Bypass)

If the normal `Install.command` or `Install.app` doesn't work due to macOS Gatekeeper, follow these **Terminal** steps instead. This method **always works**.

---

## 📋 Quick Install (Copy-Paste in Terminal)

### Step 1: Open Terminal
Press `Cmd + Space`, type **Terminal**, and press Enter.

### Step 2: Navigate to the folder
```bash
cd ~/Downloads/backup-pro-mac
```
*(Change path if you extracted the folder elsewhere)*

### Step 3: Run these commands
```bash
# Remove quarantine flag
xattr -cr .

# Make scripts executable
chmod +x install.sh Install.command scripts/*.sh

# Run install
./install.sh

# Launch the Setup GUI
node setup-server.js
```

---

## 🎯 One-Liner (For Advanced Users)
Copy this entire line and paste it into Terminal:

```bash
cd ~/Downloads/backup-pro-mac && xattr -cr . && chmod +x install.sh Install.command scripts/*.sh && ./install.sh && node setup-server.js
```

---

## ❓ Troubleshooting

### "command not found: node"
Install Node.js first: https://nodejs.org/

### "No such file or directory"
Make sure you're in the correct folder. Run `ls` to see if you can see `install.sh` in the current directory.

### Still having issues?
Run each command separately and share any error messages:
```bash
cd ~/Downloads/backup-pro-mac
ls -la
./install.sh
```
