const fs = require("fs");
const path = require("path");
const { exec } = require("child_process");
const archiver = require("archiver");
const licenseManager = require("./utils/license-manager");

const CONFIG_FILE = path.join(__dirname, "config.json");

(async () => {
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
  
  // LICENSE CHECK
  try {
    const licenseStatus = await licenseManager.getStatus();
    
    console.log("\n========================================");
    console.log("   LICENSE STATUS");
    console.log("========================================");
    console.log(`   Status: ${licenseStatus.status}`);
    console.log(`   Message: ${licenseStatus.message}\n`);

    if (licenseStatus.status === 'EXPIRED') {
      console.error("❌ TRIAL EXPIRED. Please purchase a license to continue backups.");
      const deviceId = await require('./utils/device-id').getDeviceFingerprint();
      console.error("   Device ID: " + deviceId);
      process.exit(1);
    }

    if (licenseStatus.status === 'TRIAL') {
      console.log(`   ⚠️  TRIAL MODE: Consuming 1 backup credit...`);
      licenseManager.consumeTrial();
    }
  } catch (err) {
    console.error("License check failed:", err);
    process.exit(1);
  }

  // Ensure backup folder exists
  if (!fs.existsSync(config.backupFolder)) {
    fs.mkdirSync(config.backupFolder, { recursive: true });
  }

  // Generate backup filename
  const isOverwrite = config.backupMode === 'overwrite';
  let zipName;

  if (isOverwrite) {
    zipName = `${config.projectName}_Latest.zip`;
  } else {
    const now = new Date();
    const date = now.toISOString().split("T")[0];
    const time = now.toTimeString().split(" ")[0].replace(/:/g, "-");
    zipName = `${config.projectName}_${date}_${time}.zip`;
  }

  const zipPath = path.join(config.backupFolder, zipName);

  try {

    console.log("\n========================================");
    console.log("   CREATING BACKUP...");
    console.log("========================================\n");
    console.log(`   Project: ${config.projectPath}`);
    console.log(`   Output: ${zipPath}`);
    console.log(`   Mode: ${isOverwrite ? 'Overwrite' : 'Versioned'}`);
    
    // Ensure we don't backup the backup folder itself if it's inside the project
    const backupFolderRelative = path.relative(config.projectPath, config.backupFolder);
    const isBackupInsideProject = !backupFolderRelative.startsWith('..') && !path.isAbsolute(backupFolderRelative);
    
    if (isBackupInsideProject) {
      config.excludeFolders.push(backupFolderRelative);
    }

    console.log(`   Excluding: ${config.excludeFolders.join(", ")}\n`);

    const output = fs.createWriteStream(zipPath);
    const archive = archiver('zip', {
      zlib: { level: 9 } // Sets the compression level.
    });

    output.on('close', function() {
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
      if (!isOverwrite) {
        cleanupOldBackups(config);
      } else {
        // In overwrite mode, try to clean up old timestamped backups if any exist
        cleanupOldVersionedBackups(config);
      }

      // Open folder for user
      console.log("   📂 Opening backup folder...\n");
      const openCmd = process.platform === "win32" ? `explorer "${config.backupFolder}"` : `open "${config.backupFolder}"`;
      exec(openCmd);
    });

    archive.on('error', function(err) {
      console.error("\n❌ BACKUP FAILED:", err);
      process.exit(1);
    });

    archive.pipe(output);

    // Glob pattern to include everything in projectPath
    // archiver.glob(pattern, options, data)
    
    // We want the files inside the zip to be in a folder named after the project
    // e.g. backup.zip/MyProject/package.json
    const projectNameInZip = path.basename(config.projectPath);
    
    archive.glob('**/*', { 
      cwd: config.projectPath,
      ignore: config.excludeFolders.map(f => `**/${f}/**`),
      dot: true 
    }, { prefix: projectNameInZip });

    archive.finalize();


  } catch (err) {
    console.error("\n❌ BACKUP FAILED:", err.message);
    process.exit(1);
  }
})();

function cleanupOldBackups(config) {
  const files = fs.readdirSync(config.backupFolder)
    .filter(f => f.startsWith(config.projectName) && f.endsWith(".zip") && !f.includes("Latest"))
    .map(f => ({
      name: f,
      time: fs.statSync(path.join(config.backupFolder, f)).mtime.getTime()
    }))
    .sort((a, b) => b.time - a.time);

  let deletedCount = 0;

  // 1. Retention Days Cleanup
  if (config.retentionDays && config.retentionDays > 0) {
    const cutoffTime = Date.now() - (config.retentionDays * 24 * 60 * 60 * 1000);
    const oldFiles = files.filter(f => f.time < cutoffTime);
    
    if (oldFiles.length > 0) {
      console.log(`   🗓️  Retention Policy (${config.retentionDays} days): Cleaning ${oldFiles.length} old backups...`);
      oldFiles.forEach(file => {
        try {
          fs.unlinkSync(path.join(config.backupFolder, file.name));
          console.log(`      Deleted: ${file.name}`);
          deletedCount++;
        } catch (e) {
          console.error(`      Failed to delete: ${file.name}`);
        }
      });
      // Update files list after deletion
      files.length = 0; // clear
    }
  }

  // Reload files list for Max Count check
  const remainingFiles = fs.readdirSync(config.backupFolder)
    .filter(f => f.startsWith(config.projectName) && f.endsWith(".zip") && !f.includes("Latest"))
    .map(f => ({
      name: f,
      time: fs.statSync(path.join(config.backupFolder, f)).mtime.getTime()
    }))
    .sort((a, b) => b.time - a.time); // Newest first

  // 2. Max Backups Count Cleanup
  if (remainingFiles.length > config.maxBackups) {
    console.log(`   🗂️  Max Limit (${config.maxBackups}): Cleaning extra backups...`);
    remainingFiles.slice(config.maxBackups).forEach(file => {
        try {
            fs.unlinkSync(path.join(config.backupFolder, file.name));
            console.log(`      Deleted: ${file.name}`);
        } catch (e) {}
    });
  }
}

function cleanupOldVersionedBackups(config) {
    const files = fs.readdirSync(config.backupFolder)
    .filter(f => f.startsWith(config.projectName) && f.endsWith(".zip") && !f.includes("Latest"))
    
    if (files.length > 0) {
        console.log("   🧹 Cleaning up old versioned backups (switched to Overwrite Mode)...");
        files.forEach(f => {
            try {
                fs.unlinkSync(path.join(config.backupFolder, f));
                console.log(`      Deleted: ${f}`);
            } catch(e){}
        });
    }
}