const licenseManager = require('./license-manager');

(async () => {
    try {
        const status = await licenseManager.getStatus();
        console.log(JSON.stringify(status));
    } catch (e) {
        console.error(JSON.stringify({ status: 'ERROR', message: e.message }));
    }
})();
