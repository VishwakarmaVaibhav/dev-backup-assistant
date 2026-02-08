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

try {
  console.log("\n========================================");
  console.log("   CREATING BACKUP...");
  console.log("========================================\n");
  console.log(`   Project: ${config.projectPath}`);
  console.log(`   Output: ${zipPath}`);
  console.log(`   Excluding: ${config.excludeFolders.join(", ")}\n`);

  const isWindows = process.platform === "win32";

  if (isWindows) {
    // Windows: Use WinRAR
    const winrarPath = `"${config.winrarPath}"`;
    // Build exclude arguments for WinRAR
    const excludeArgs = config.excludeFolders
      .map(folder => `-x*\\${folder}\\*`)
      .join(" ");

    // Use -m5 for best compression, a for add, -r for recursive
    const cmd = `${winrarPath} a -r -ep1 "${zipPath}" "${config.projectPath}\\*" ${excludeArgs}`;
    execSync(cmd, { stdio: "inherit" });
  } else {
    // macOS/Linux: Use zip
    // Build exclude arguments for zip (needs relative paths or wildcards)
    // zip -r backup.zip . -x "node_modules/*"
    // Build exclude args
    // Add backup folder to excludes to prevent recursion if it's inside project
    const backupFolderName = path.basename(config.backupFolder);
    const allExcludes = [...config.excludeFolders, backupFolderName];

    const excludeArgs = allExcludes
      .map(folder => `-x "*/${folder}/*"`)
      .join(" ");

    // Check if zip is available
    try {
      execSync("which zip");
    } catch (e) {
      console.error("❌ 'zip' command not found. Please install zip.");
      process.exit(1);
    }

    console.log("   Using 'zip' for compression...");

    // Go to project folder to avoid full path structure in zip if desired, 
    // but here we might want to keep the folder structure of the project itself.
    // Let's zip the project directory.
    const parentDir = path.dirname(config.projectPath);
    const folderName = path.basename(config.projectPath);

    // cd to parent, then zip the folder
    const cmd = `cd "${parentDir}" && zip -r "${zipPath}" "${folderName}" ${excludeArgs}`;
    execSync(cmd, { stdio: "inherit" });
  }

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
  const openCmd = isWindows ? `explorer "${config.backupFolder}"` : `open "${config.backupFolder}"`;
  exec(openCmd);

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