# Procédure

Ask questions of your **SOPs** (Standard Operating Procedures) and **MOPs** (Methods of Procedure) and get answers that come from your own documents, with links to the exact section they came from.

It's one HTML file. You can run it locally (double-click `index.html`) or host it on GitHub Pages. Your documents stay in your browser and are never uploaded.

## Features
- Drop in **PDF, Word (.docx), TXT, Markdown, HTML, CSV** files, or paste text
- Tags each document as SOP or MOP automatically; click the tag to change it
- Ask across all documents, SOPs only, MOPs only, or a single document
- **Search-only mode** works fully offline: it ranks the matching sections and pulls out the best lines
- **Optional AI answers** with numbered citations you can click:
  - **Ollama** (local AI on your PC)
  - **LM Studio** or any OpenAI-compatible local server
  - **Claude API** with your own key
- Built-in document viewer with find-in-document
- Export and import your library as a `.json` file, to back it up or move it to another PC
- In-app updater: it checks GitHub for a new version and only updates if you say yes

## Run locally (Windows)
1. Download `index.html` (you can rename it `Procedure.html`).
2. Double-click it to open it in Edge or Chrome.
3. Your library is saved in that browser, so keep opening the same file from the same place.

The PDF and Word readers load from a CDN the first time you add one of those files, so you need internet for that step. After that, text files and search work offline.

## Local AI with Ollama
1. Install Ollama from https://ollama.com, then run `ollama pull llama3.1`.
2. Let the browser talk to it: set the Windows environment variable `OLLAMA_ORIGINS` to `*`, then restart Ollama.
3. In the app, open **⚙ Answer engine**, choose Ollama, then click **Test**.

## Host on GitHub Pages
Push `index.html` and `version.json` to `kefirman9000/procedure`, then go to Settings → Pages → Deploy from branch `main`, folder `/root`.

## Releasing an update
Bump `VERSION` in `index.html` and `version` in `version.json` to the same number, then push. Users click **Check for updates** to get it.

## Support
Procédure is free and open source. If it saves you time, please consider [sponsoring me on GitHub](https://github.com/sponsors/kefirman9000) ♥
