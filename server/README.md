# Backup Pro Licensing Server

This directory contains the backend server for validating Backup Pro licenses.

## Setup

1.  Navigate to this folder: `cd server`
2.  Install dependencies (if not already done): `npm install`
3.  Start the server: `node server.js`

## API Endpoints

-   `POST /api/activate`: Activates a license for a specific device.
-   `POST /api/check`: Checks the license status of a device.
-   `POST /api/admin/generate`: Generates a new license key (Admin only).

## Database

-   `db.json`: Stores all license keys and device bindings. **Backup this file!**

## Deployment

To deploy on a VPS:
1.  Copy the `server` folder to your VPS.
2.  Run `npm install`.
3.  Use `pm2` or similar to keep `node server.js` running.
4.  Update your Client's `Server URL` in the installer setup to point to `http://your-vps-ip:3000`.
