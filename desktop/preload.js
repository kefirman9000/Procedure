const { contextBridge, ipcRenderer } = require("electron");
contextBridge.exposeInMainWorld("procedureDesktop", {
  saveUpdate: html => ipcRenderer.invoke("save-update", html),
  openData: () => ipcRenderer.invoke("open-data")
});
