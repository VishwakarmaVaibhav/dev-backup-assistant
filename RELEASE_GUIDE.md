# 🚀 How to Create a Release

Follow these steps to package and release a new version of **Backup Pro**.

## 1. Create the Release Zip

We have a script to automatically package the application for you.

1. Open your terminal in VS Code.
2. Run the build script:
   ```powershell
   .\scripts\build_release.ps1
   ```
3. This will create a **`backup-pro.zip`** file in your project folder.

## 2. Publish on GitHub

1. Go to your GitHub repository: [https://github.com/VishwakarmaVaibhav/dev-backup-assistant](https://github.com/VishwakarmaVaibhav/dev-backup-assistant)
2. Click on **Releases** (on the right sidebar) or go to `/releases`.
3. Click **Draft a new release**.
4. **Choose a tag**: Create a new tag (e.g., `v1.0.0`).
5. **Release title**: Enter a title (e.g., `Backup Pro v1.0.0`).
6. **Describe the release**: List the features or changes.
7. **Attach binaries**:
   - Drag and drop the **`backup-pro.zip`** file you just created into the "Attach binaries" box.
8. Click **Publish release**.

## 3. Verify

- Copy the link address of the uploaded `backup-pro.zip`.
- It should match the link in your `README.md` and `website/index.html` (which is currently set to `.../releases/latest/download/backup-pro.zip`). Note that `latest` automatically points to the most recent release, so you don't need to update the code for every version!
