const crypto = require('crypto');
const SECRET_KEY = 'BACKUP_PRO_SECRET_KEY';

const deviceId = process.argv[2];

if (!deviceId) {
    console.error("Usage: node gen-license.js <device-id>");
    process.exit(1);
}

const data = `${deviceId}-${SECRET_KEY}`;
const key = crypto.createHash('sha256').update(data).digest('hex').substring(0, 24).toUpperCase();

console.log(key);
