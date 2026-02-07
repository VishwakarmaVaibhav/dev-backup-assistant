const fs = require("fs");
const path = require("path");
const { execSync, exec } = require("child_process");

const CONFIG_FILE = path.join(__dirname, "config.json");

// Load config
if (!fs.existsSync(CONFIG_FILE)) {
  console.error("Config not found! Run 'npm run setup' first.");
  process.exit(1);
}

const config = JSON.parse(fs.readFileSync(CONFIG_FILE, "utf-8"));

// Validate config
if (!config.projectPath || !config.backupFolder) {
  console.error("Project path or backup folder not configured!");
  console.error("Run 'npm run setup' to configure.");
  process.exit(1);
}

// Ensure backup folder exists
if (!fs.existsSync(config.backupFolder)) {
  fs.mkdirSync(config.backupFolder, { recursive: true });
}

// Generate backup filename with timestamp
const now = new Date();
const date = now.toISOString().split("T")[0];
const time = now.toTimeString().split(" ")[0].replace(/:/g, "-");
const zipName = `${config.projectName}_${date}_${time}.zip`;
const zipPath = path.join(config.backupFolder, zipName);

// Build exclude arguments
const excludeArgs = config.excludeFolders
  .map(folder => `-x*\\${folder}\\*`)
  .join(" ");

try {
  console.log("\n========================================");
  console.log("   CREATING BACKUP...");
  console.log("========================================\n");
  console.log(`   Project: ${config.projectPath}`);
  console.log(`   Output: ${zipPath}`);
  console.log(`   Excluding: ${config.excludeFolders.join(", ")}\n`);

  const winrarPath = `"${config.winrarPath}"`;
  // Use -m5 for best compression, a for add, -r for recursive
  const cmd = `${winrarPath} a -r -ep1 "${zipPath}" "${config.projectPath}\\*" ${excludeArgs}`;
  
  execSync(cmd, { stdio: "inherit" });

  // Get file size
  const stats = fs.statSync(zipPath);
  const sizeMB = (stats.size / (1024 * 1024)).toFixed(2);

  console.log("\n========================================");
  console.log("   ✅ BACKUP COMPLETED!");
  console.log("========================================");
  console.log(`   📁 File: ${zipName}`);
  console.log(`   📏 Size: ${sizeMB} MB`);
  console.log(`   📍 Location: ${config.backupFolder}\n`);

  // Cleanup old backups
  cleanupOldBackups();

  // Open folder for user to share
  console.log("   📂 Opening backup folder...\n");
  exec(`explorer "${config.backupFolder}"`);

} catch (err) {
  console.error("\n❌ BACKUP FAILED:", err.message);
  process.exit(1);
}

function cleanupOldBackups() {
  const files = fs.readdirSync(config.backupFolder)
    .filter(f => f.startsWith(config.projectName) && f.endsWith(".zip"))
    .map(f => ({
      name: f,
      time: fs.statSync(path.join(config.backupFolder, f)).mtime.getTime()
    }))
    .sort((a, b) => b.time - a.time);

  if (files.length > config.maxBackups) {
    console.log(`   🗑️  Cleaning up (keeping last ${config.maxBackups})...`);
    files.slice(config.maxBackups).forEach(file => {
      fs.unlinkSync(path.join(config.backupFolder, file.name));
      console.log(`      Deleted: ${file.name}`);
    });
    console.log("");
  }
}