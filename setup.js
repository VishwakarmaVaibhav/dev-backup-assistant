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
  console.log("   Configure backup times for each day (press Enter to keep default)\n");
  console.log("   NOTE: You can enter multiple times separated by commas (e.g. 09:00, 14:00, 18:00)");

  const days = ["monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday"];

  for (const day of days) {
    const current = config.schedule[day] || { enabled: false, times: ["09:00"] };
    // Handle migration from old string time to array
    if (typeof current.time === 'string') {
        current.times = [current.time];
        delete current.time;
    }

    const enabled = await ask(`   ${day.charAt(0).toUpperCase() + day.slice(1)} - Enable? (y/n) [${current.enabled ? 'y' : 'n'}]: `);

    if (enabled.toLowerCase() === 'n') {
      config.schedule[day] = { enabled: false, times: [] };
    } else if (enabled.toLowerCase() === 'y' || enabled === '') {
      config.schedule[day] = { enabled: true, times: current.times };
      
      const defaultTimes = current.times.join(", ");
      const timesInput = await ask(`   ${day.charAt(0).toUpperCase() + day.slice(1)} - Times (HH:MM) [${defaultTimes}]: `);
      
      const finalTimes = (timesInput.trim() || defaultTimes)
        .split(",")
        .map(t => t.trim())
        .filter(t => /^\d{2}:\d{2}$/.test(t));
      
      if (finalTimes.length === 0) {
          console.log("   ⚠️  Invalid time format. Using default.");
          config.schedule[day].times = current.times;
      } else {
          config.schedule[day].times = finalTimes;
      }
    }
  }

  // Backup Mode
  console.log("\n⚙️  BACKUP SETTINGS");
  console.log("   1. Versioned Mode (Keep multiple backups)");
  console.log("   2. Overwrite Mode (Keep only the latest backup)");
  
  const modeInput = await ask("   Select Mode [1]: ");
  const isOverwrite = modeInput.trim() === "2";
  
  config.backupMode = isOverwrite ? "overwrite" : "versioned";

  if (isOverwrite) {
      config.maxBackups = 1;
      config.retentionDays = 0; // Not applicable or just 1
      console.log("   👉 Mode: Overwrite (Single file will be maintained)");
  } else {
      // Max Backups
      console.log("\n🗂️  How many backups to keep by COUNT? (older ones deleted)");
      const maxBackups = await ask(`   Max Backups [${config.maxBackups || 10}]: `);
      config.maxBackups = parseInt(maxBackups) || 10;
      
      // Retention Days
      console.log("\n🗓️  How many DAYS to keep backups? (0 = keep forever until Max Backups reached)");
      const retention = await ask(`   Retention Days [${config.retentionDays || 0}]: `);
      config.retentionDays = parseInt(retention) || 0;
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
