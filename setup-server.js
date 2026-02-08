const http = require('http');
const fs = require('fs');
const path = require('path');
const { exec } = require('child_process');

const PORT = 3000;
const PUBLIC_DIR = path.join(__dirname, 'website');
const CONFIG_FILE = path.join(__dirname, 'config.json');

// Helper to open browser in App Mode if possible
const openBrowser = (url) => {
    const platform = process.platform;

    if (platform === 'darwin') {
        // Try Chrome then Edge in App Mode
        const chromePath = '/Applications/Google Chrome.app/Contents/MacOS/Google Chrome';
        const edgePath = '/Applications/Microsoft Edge.app/Contents/MacOS/Microsoft Edge';

        if (fs.existsSync(chromePath)) {
            exec(`"${chromePath}" --app=${url}`);
        } else if (fs.existsSync(edgePath)) {
            exec(`"${edgePath}" --app=${url}`);
        } else {
            exec(`open ${url}`);
        }
    } else if (platform === 'win32') {
        exec(`start chrome --app=${url} || start msedge --app=${url} || start ${url}`);
    } else {
        exec(`xdg-open ${url}`);
    }
};

const server = http.createServer((req, res) => {
    // Enable CORS for potential development
    res.setHeader('Access-Control-Allow-Origin', '*');
    res.setHeader('Access-Control-Allow-Methods', 'GET, POST');
    res.setHeader('Access-Control-Allow-Headers', 'Content-Type');

    if (req.method === 'OPTIONS') { res.writeHead(200); res.end(); return; }

    const url = new URL(req.url, `http://${req.headers.host}`);
    const pathname = url.pathname;

    // API: Get Config
    if (pathname === '/api/config' && req.method === 'GET') {
        if (fs.existsSync(CONFIG_FILE)) {
            try {
                const config = fs.readFileSync(CONFIG_FILE, 'utf8');
                res.writeHead(200, { 'Content-Type': 'application/json' });
                res.end(config);
            } catch (e) {
                // Return default if error
                res.writeHead(200, { 'Content-Type': 'application/json' });
                res.end(JSON.stringify(getDefaultConfig()));
            }
        } else {
            res.writeHead(200, { 'Content-Type': 'application/json' });
            res.end(JSON.stringify(getDefaultConfig()));
        }
        return;
    }

    // API: Save Config
    if (pathname === '/api/config' && req.method === 'POST') {
        let body = '';
        req.on('data', chunk => body += chunk);
        req.on('end', () => {
            try {
                const newConfig = JSON.parse(body);
                // Basic validation could happen here
                fs.writeFileSync(CONFIG_FILE, JSON.stringify(newConfig, null, 2));
                res.writeHead(200, { 'Content-Type': 'application/json' });
                res.end(JSON.stringify({ success: true, message: 'Configuration saved!' }));
            } catch (e) {
                res.writeHead(500, { 'Content-Type': 'application/json' });
                res.end(JSON.stringify({ success: false, message: e.message }));
            }
        });
        return;
    }

    // API: Install Schedule
    if (pathname === '/api/install-schedule' && req.method === 'POST') {
        const scriptPath = path.join(__dirname, 'scripts', 'install-schedule.sh');
        // Pass the current Node path to the script
        const nodePath = process.execPath;
        exec(`"${scriptPath}" "${nodePath}"`, (err, stdout, stderr) => {
            if (err) {
                res.writeHead(500, { 'Content-Type': 'application/json' });
                res.end(JSON.stringify({ success: false, message: stderr || err.message }));
            } else {
                res.writeHead(200, { 'Content-Type': 'application/json' });
                res.end(JSON.stringify({ success: true, message: 'Schedule installed successfully!' }));
            }
        });
        return;
    }

    // API: Uninstall Schedule
    if (pathname === '/api/uninstall-schedule' && req.method === 'POST') {
        const scriptPath = path.join(__dirname, 'scripts', 'uninstall-schedule.sh');
        exec(`"${scriptPath}"`, (err, stdout, stderr) => {
            if (err) {
                res.writeHead(500, { 'Content-Type': 'application/json' });
                res.end(JSON.stringify({ success: false, message: stderr || err.message }));
            } else {
                res.writeHead(200, { 'Content-Type': 'application/json' });
                res.end(JSON.stringify({ success: true, message: 'Schedule removed successfully!' }));
            }
        });
        return;
    }

    // API: Backup Now
    if (pathname === '/api/backup-now' && req.method === 'POST') {
        const scriptPath = path.join(__dirname, 'backup.js');
        const projectDir = __dirname;
        const nodePath = process.execPath;

        exec(`"${nodePath}" "${scriptPath}"`, { cwd: projectDir }, (err, stdout, stderr) => {
            if (err) {
                res.writeHead(500, { 'Content-Type': 'application/json' });
                res.end(JSON.stringify({ success: false, message: stderr || err.message }));
            } else {
                res.writeHead(200, { 'Content-Type': 'application/json' });
                res.end(JSON.stringify({ success: true, message: 'Backup created successfully!' }));
            }
        });
        return;
    }

    // API: Browse Folder (Server-side dialog)

    // API: Browse Folder (Server-side dialog)
    if (pathname === '/api/browse' && req.method === 'GET') {
        const script = `osascript -e 'POSIX path of (choose folder with prompt "Select Folder")'`;
        exec(script, (err, stdout, stderr) => {
            if (err) {
                // User cancelled or error
                res.writeHead(200, { 'Content-Type': 'application/json' });
                res.end(JSON.stringify({ path: '' }));
            } else {
                res.writeHead(200, { 'Content-Type': 'application/json' });
                res.end(JSON.stringify({ path: stdout.trim() }));
            }
        });
        return;
    }

    // Serve Static Files
    let filePath = path.join(PUBLIC_DIR, pathname === '/' ? 'setup.html' : pathname);
    fs.readFile(filePath, (err, content) => {
        if (err) {
            if (err.code == 'ENOENT') {
                res.writeHead(404);
                res.end('File not found');
            } else {
                res.writeHead(500);
                res.end(`Server Error: ${err.code}`);
            }
        } else {
            let ext = path.extname(filePath);
            let contentType = 'text/html';
            if (ext === '.js') contentType = 'text/javascript';
            if (ext === '.css') contentType = 'text/css';
            if (ext === '.json') contentType = 'application/json';
            if (ext === '.png') contentType = 'image/png';
            if (ext === '.jpg') contentType = 'image/jpg';
            if (ext === '.ico') contentType = 'image/x-icon';

            res.writeHead(200, { 'Content-Type': contentType });
            res.end(content, 'utf-8');
        }
    });

});

function getDefaultConfig() {
    return {
        projectPath: "",
        backupFolder: "",
        projectName: "MyProject",
        maxBackups: 10,
        winrarPath: "",
        schedule: {
            monday: { enabled: true, time: "18:00" },
            tuesday: { enabled: true, time: "18:00" },
            wednesday: { enabled: true, time: "18:00" },
            thursday: { enabled: true, time: "18:00" },
            friday: { enabled: true, time: "18:00" },
            saturday: { enabled: false, time: "18:00" },
            sunday: { enabled: false, time: "18:00" }
        },
        excludeFolders: ["node_modules", ".git", "dist", "build", ".next", "__pycache__"]
    };
}

// Port retry logic
let currentPort = PORT;
const maxPort = PORT + 10;

function startServer(port) {
    server.once('error', (err) => {
        if (err.code === 'EADDRINUSE') {
            if (port < maxPort) {
                console.log(`Port ${port} in use, trying ${port + 1}...`);
                startServer(port + 1);
            } else {
                console.error(`Unable to find an open port between ${PORT} and ${maxPort}.`);
                process.exit(1);
            }
        } else {
            console.error("Server error:", err);
        }
    });

    server.listen(port, () => {
        console.log(`Setup Server running at http://localhost:${port}/`);
        openBrowser(`http://localhost:${port}/`);
    });
}

startServer(PORT);
