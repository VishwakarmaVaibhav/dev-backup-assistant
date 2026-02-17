const { exec } = require('child_process');
const crypto = require('crypto');
const os = require('os');
const fs = require('fs');
const path = require('path');

function getCommandOutput(command) {
  return new Promise((resolve) => {
    exec(command, (error, stdout) => {
      if (error) {
        resolve('');
      } else {
        resolve(stdout.trim());
      }
    });
  });
}

async function getDeviceFingerprint() {
  // 1. CPU ID (Windows)
  const cpuId = await getCommandOutput('wmic cpu get ProcessorId');
  
  // 2. Disk Serial (First disk)
  const diskSerial = await getCommandOutput('wmic diskdrive get SerialNumber');
  
  // 3. MAC Address (First non-internal interface)
  const networkInterfaces = os.networkInterfaces();
  let macAddress = '';
  for (const key in networkInterfaces) {
    const validInterface = networkInterfaces[key].find(i => !i.internal && i.mac !== '00:00:00:00:00:00');
    if (validInterface) {
      macAddress = validInterface.mac;
      break;
    }
  }

  // 4. Hostname & User (Fallback)
  const hostname = os.hostname();
  const username = os.userInfo().username;

  // Combine all info
  const rawId = `${cpuId}-${diskSerial}-${macAddress}-${hostname}-${username}`;
  
  // Hash it
  const hash = crypto.createHash('sha256').update(rawId).digest('hex');
  
  return hash;
}

module.exports = { getDeviceFingerprint };
