const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const fs = require('fs');
const path = require('path');
const crypto = require('crypto');

const app = express();
const PORT = 3000;
const DB_FILE = path.join(__dirname, 'db.json');
const SECRET_KEY = 'BACKUP_PRO_MASTER_KEY'; // Master key for generating licenses

app.use(cors());
app.use(bodyParser.json());

// Initialize DB
if (!fs.existsSync(DB_FILE)) {
    fs.writeFileSync(DB_FILE, JSON.stringify({ licenses: [] }, null, 2));
}

function getDb() {
    return JSON.parse(fs.readFileSync(DB_FILE, 'utf-8'));
}

function saveDb(data) {
    fs.writeFileSync(DB_FILE, JSON.stringify(data, null, 2));
}

// Admin: Generate License Key
app.post('/api/admin/generate', (req, res) => {
    // In real app, protect this endpoint!
    const key = crypto.randomBytes(16).toString('hex').toUpperCase();
    const db = getDb();
    
    db.licenses.push({
        key: key,
        deviceId: null, // Not bound yet
        status: 'AVAILABLE',
        createdAt: new Date().toISOString()
    });
    
    saveDb(db);
    res.json({ success: true, key: key });
});

// Client: Activate License
app.post('/api/activate', (req, res) => {
    const { key, deviceId } = req.body;
    
    if (!key || !deviceId) {
        return res.status(400).json({ success: false, message: 'Missing key or deviceId' });
    }
    
    const db = getDb();
    const license = db.licenses.find(l => l.key === key);
    
    if (!license) {
        return res.status(404).json({ success: false, message: 'Invalid License Key' });
    }
    
    if (license.status === 'ACTIVE' && license.deviceId !== deviceId) {
        return res.status(403).json({ success: false, message: 'License already used on another device' });
    }
    
    // Bind license
    if (license.status !== 'ACTIVE') {
        license.status = 'ACTIVE';
        license.deviceId = deviceId;
        license.activatedAt = new Date().toISOString();
        saveDb(db);
    }
    
    res.json({ success: true, message: 'License Activated', license: license });
});

// Client: Check License
app.post('/api/check', (req, res) => {
    const { deviceId } = req.body;
    
    if (!deviceId) return res.status(400).json({ success: false, message: 'Missing deviceId' });
    
    const db = getDb();
    const license = db.licenses.find(l => l.deviceId === deviceId && l.status === 'ACTIVE');
    
    if (license) {
        res.json({ success: true, status: 'ACTIVE' });
    } else {
        res.json({ success: false, status: 'TRIAL', message: 'No active license found' });
    }
});

app.listen(PORT, () => {
    console.log(`Backend Server running on http://localhost:${PORT}`);
});
