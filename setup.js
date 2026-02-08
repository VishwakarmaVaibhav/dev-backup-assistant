const fs = require("fs");
const path = require("path");
const readline = require("readline");

const CONFIG_FILE = path.join(__dirname, "config.json");

const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout
});

const ask = (question) => new Promise((resolve) => rl.question(question, resolve));

async function setup() {
  console.log("\n========================================");
  console.log("   PROJECT BACKUP PRO - SETUP WIZARD");
  console.log("========================================\n");

  let config = JSON.parse(fs.readFileSync(CONFIG_FILE, "utf-8"));

  // Project Path
  console.log("📁 Enter the FULL PATH of your project folder:");
  console.log("   Example: D:\\Projects\\MyAwesomeApp\n");
  const projectPath = await ask("   Project Path: ");
  config.projectPath = projectPath.trim();

  // Backup Folder
  console.log("\n💾 Enter the FULL PATH where backups should be saved:");
  console.log("   Example: D:\\Backups\n");
  const backupFolder = await ask("   Backup Folder: ");
  config.backupFolder = backupFolder.trim();

  // Project Name
  console.log("\n📝 Enter a name for your project (used in backup filename):");
  const projectName = await ask("   Project Name: ");
  config.projectName = projectName.trim() || "MyProject";

  // Schedule Setup
  console.log("\n⏰ SCHEDULE SETUP");
  console.log("   Configure backup time for each day (press Enter to keep default)\n");

  const days = ["monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday"];

  for (const day of days) {
    const current = config.schedule[day];
    const enabled = await ask(`   ${day.charAt(0).toUpperCase() + day.slice(1)} - Enable? (y/n) [${current.enabled ? 'y' : 'n'}]: `);

    if (enabled.toLowerCase() === 'n') {
      config.schedule[day].enabled = false;
    } else if (enabled.toLowerCase() === 'y' || enabled === '') {
      config.schedule[day].enabled = current.enabled || enabled.toLowerCase() === 'y';

      if (config.schedule[day].enabled) {
        const time = await ask(`   ${day.charAt(0).toUpperCase() + day.slice(1)} - Time (HH:MM) [${current.time}]: `);
        config.schedule[day].time = time.trim() || current.time;
      }
    }
  }

  // Max Backups
  console.log("\n🗂️  How many backups to keep? (older ones will be deleted)");
  const maxBackups = await ask("   Max Backups [10]: ");
  config.maxBackups = parseInt(maxBackups) || 10;

  // WinRAR Path (Only for Windows)
  const isWindows = process.platform === "win32";
  if (isWindows) {
    console.log("\n📦 WinRAR Path (press Enter if default is correct):");
    console.log(`   Default: ${config.winrarPath}`);
    const winrarPath = await ask("   WinRAR Path: ");
    config.winrarPath = winrarPath.trim() || config.winrarPath;
  } else {
    // For macOS/Linux, we use 'zip', which is usually in PATH
    console.log("\n📦 Compression Tool:");
    console.log("   Using system 'zip' command (auto-detected).");
  }

  // Save Config
  fs.writeFileSync(CONFIG_FILE, JSON.stringify(config, null, 2));

  console.log("\n========================================");
  console.log("   ✅ SETUP COMPLETE!");
  console.log("========================================");
  console.log("\n📋 Your Configuration:");
  console.log(`   Project: ${config.projectPath}`);
  console.log(`   Backups: ${config.backupFolder}`);
  console.log(`   Name: ${config.projectName}`);
  console.log(`   Keep: Last ${config.maxBackups} backups`);
  console.log("\n🚀 Next Steps:");
  console.log("   1. Run: npm run install-task");
  console.log("   2. That's it! Popup will appear at scheduled times.\n");

  rl.close();
}

setup().catch(console.error);
