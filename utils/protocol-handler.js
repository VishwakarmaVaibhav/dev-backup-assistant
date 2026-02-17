const path = require('path');
const fs = require('fs');
const { exec } = require('child_process');
const licenseManager = require('./license-manager');

// Protocol format: backuppro://activate?key=LICENSE_KEY

async function handleProtocol() {
    const args = process.argv.slice(2);
    const uri = args.find(arg => arg.startsWith('backuppro://'));

    if (!uri) {
        console.error("No URI provided.");
        return;
    }

    try {
        const url = new URL(uri);
        const action = url.hostname; // 'activate'
        const key = url.searchParams.get('key');

        if (action === 'activate' && key) {
            console.log(`Activating with key: ${key}...`);
            const success = await licenseManager.activate(key);
            
            if (success) {
                showMessage("Backup Pro Activated!", "License activated successfully. You can now use Backup Pro.");
            } else {
                showMessage("Activation Failed", "Invalid or expired license key.");
            }
        } else {
            console.error("Unknown action or missing key.");
        }
    } catch (e) {
        console.error("Error parsing URI:", e.message);
        showMessage("Error", "Failed to process activation link.");
    }
}

function showMessage(title, message) {
    // Show a native message box using PowerShell (since we are on Windows)
    const psScript = `
    Add-Type -AssemblyName System.Windows.Forms
    [System.Windows.Forms.MessageBox]::Show('${message.replace(/'/g, "''")}', '${title.replace(/'/g, "''")}')
    `;
    const command = `powershell -Command "${psScript.replace(/\n/g, ' ')}"`;
    exec(command);
}

handleProtocol();
