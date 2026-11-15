// Procédure desktop — wraps index.html in a window. Your library is stored in this app's data folder.
const { app, BrowserWindow, ipcMain, shell } = require("electron");
const path = require("path");
const fs = require("fs");

const updatedFile = () => path.join(app.getPath("userData"), "app", "index.html");
const bundledFile = path.join(__dirname, "index.html");
function versionOf(file) {
  try { const m = fs.readFileSync(file, "utf8").match(/const VERSION = "([\d.]+)"/); return m ? m[1] : "0"; } catch { return "0"; }
}
function newer(a, b) {
  const x = a.split(".").map(Number), y = b.split(".").map(Number);
  for (let i = 0; i < 3; i++) { if ((x[i] || 0) > (y[i] || 0)) return true; if ((x[i] || 0) < (y[i] || 0)) return false; }
  return false;
}
// Use an in-app update if one was accepted and it is newer than the installed version.
const entry = () => (fs.existsSync(updatedFile()) && newer(versionOf(updatedFile()), versionOf(bundledFile))) ? updatedFile() : bundledFile;

let win;
function createWindow() {
  win = new BrowserWindow({
    width: 1320, height: 880, minWidth: 820, minHeight: 560, backgroundColor: "#0f1216", title: "Procédure",
    webPreferences: { preload: path.join(__dirname, "preload.js"), contextIsolation: true }
  });
  win.setMenuBarVisibility(false);
  win.webContents.setWindowOpenHandler(({ url }) => {
    if (/^https?:/.test(url)) { shell.openExternal(url); return { action: "deny" }; }
    return { action: "allow" }; // blank windows are used for printing checklists
  });
  win.loadFile(entry());
}

ipcMain.handle("save-update", async (_e, html) => {
  fs.mkdirSync(path.dirname(updatedFile()), { recursive: true });
  fs.writeFileSync(updatedFile(), html, "utf8");
  win.loadFile(updatedFile());
  return true;
});
ipcMain.handle("open-data", () => shell.openPath(app.getPath("userData")));

app.whenReady().then(createWindow);
app.on("window-all-closed", () => app.quit());
