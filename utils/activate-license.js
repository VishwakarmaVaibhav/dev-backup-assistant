const licenseManager = require('./license-manager');

const key = process.argv[2];

if (!key) {
    console.error("Usage: node activate-license.js <key>");
    process.exit(1);
}

(async () => {
    if (await licenseManager.activate(key)) {
        console.log("SUCCESS");
    } else {
        console.log("INVALID");
    }
})();
