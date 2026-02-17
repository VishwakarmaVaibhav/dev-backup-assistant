const { getDeviceFingerprint } = require('./device-id');

(async () => {
    try {
        const id = await getDeviceFingerprint();
        console.log(id);
    } catch (e) {
        console.error("Error generating ID");
    }
})();
