const axios = require('axios');

(async () => {
    try {
        const response = await axios.post('http://localhost:3000/api/admin/generate');
        console.log(response.data.key);
    } catch (e) {
        console.error("Error generating key:", e.message);
    }
})();
