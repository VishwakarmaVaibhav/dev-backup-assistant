const fs = require('fs');
const path = require('path');
const axios = require('axios');
const { getDeviceFingerprint } = require('./device-id');

const LICENSE_FILE = path.join(__dirname, '..', 'license.json');
const TRIAL_FILE = path.join(__dirname, '..', '.trial_data');
const CONFIG_FILE = path.join(__dirname, '..', 'config.json');

function getServerUrl() {
    if (fs.existsSync(CONFIG_FILE)) {
        try {
            const config = JSON.parse(fs.readFileSync(CONFIG_FILE, 'utf-8'));
            return config.serverUrl || 'http://localhost:3000';
        } catch (e) {}
    }
    return 'http://localhost:3000';
}

class LicenseManager {
  constructor() {
    this.deviceFingerprint = null;
  }

  async init() {
    this.deviceFingerprint = await getDeviceFingerprint();
  }

  // Check current status
  async getStatus() {
    if (!this.deviceFingerprint) await this.init();

    // 1. Check local active license
    if (fs.existsSync(LICENSE_FILE)) {
      try {
        const licenseData = JSON.parse(fs.readFileSync(LICENSE_FILE, 'utf-8'));
        if (licenseData.deviceId === this.deviceFingerprint) {
            // Optional: Re-validate with server in background?
            // For now, trust local file if device ID matches.
            return { status: 'ACTIVE', message: 'License Active' };
        }
      } catch (e) {}
    }

    // 2. Check Local Trial
    const trialData = this.getTrialData();
    if (trialData.count < 3) {
      return { 
        status: 'TRIAL', 
        remaining: 3 - trialData.count, 
        message: `Trial Mode: ${3 - trialData.count} backups remaining.` 
      };
    }

    return { status: 'EXPIRED', message: 'Trial Expired. Please purchase a license.' };
  }

  getTrialData() {
    if (fs.existsSync(TRIAL_FILE)) {
      try {
        return JSON.parse(fs.readFileSync(TRIAL_FILE, 'utf-8'));
      } catch (e) {}
    }
    return { count: 0 };
  }

  consumeTrial() {
    const data = this.getTrialData();
    data.count++;
    fs.writeFileSync(TRIAL_FILE, JSON.stringify(data));
  }

  async activate(key) {
    if (!this.deviceFingerprint) await this.init();

    try {
        const serverUrl = getServerUrl();
        const response = await axios.post(`${serverUrl}/api/activate`, {
            key: key,
            deviceId: this.deviceFingerprint
        });

        if (response.data.success) {
            // Save license locally
            fs.writeFileSync(LICENSE_FILE, JSON.stringify({
                key: key,
                deviceId: this.deviceFingerprint,
                activatedAt: new Date().toISOString(),
                serverData: response.data.license
            }, null, 2));
            return true;
        }
    } catch (error) {
        console.error("Activation failed:", error.response ? error.response.data : error.message);
    }
    return false;
  }
}

module.exports = new LicenseManager();
