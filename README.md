# Procédure

Ask questions of your **SOPs** (Standard Operating Procedures) and **MOPs** (Methods of Procedure) and get answers from your own documents, with links to the exact section each answer came from.

**Use it on the web:** https://kefirman9000.github.io/procedure/
**Windows desktop app:** [latest release](https://github.com/kefirman9000/procedure/releases/latest) (installer or portable .exe)

Your documents stay on your computer and are never uploaded.

## Features
- **Add any procedure file:** PDF, Word (.docx), TXT, Markdown, HTML, CSV, or pasted text. Scanned PDFs and photos are read with built-in text recognition (OCR).
- **Ask questions** across everything, SOPs only, MOPs only, one document, or old revisions too.
- **Answers you can check:** every answer links to its source section. In search-only mode it works fully offline.
- **Optional AI answers:** Ollama (local), LM Studio or any OpenAI-compatible server, or the Claude API with your own key.
- **Smart search:** an optional small local model matches by meaning, so "rollback" finds "back-out plan". Common procedure synonyms are built in.
- **Glossary:** add your team's abbreviations (`MW = maintenance window`) and questions in either form will match.
- **Checklist mode:** run any SOP or MOP as a tick-off checklist. Each step is timestamped and can take a note, warnings are highlighted, and you can enter operator, ticket and window details. Print it or save it as a PDF or CSV.
- **Revision tracking:** add a newer version of a file and the old one goes into History. You can compare any two revisions line by line or restore an old one.
- **Audit:** finds MOPs missing rollback, verification, approvals, impact or pre-checks, and SOPs missing purpose, scope, responsibilities and similar sections. You can export the report as CSV.
- **Team library:** sync a shared folder (network drive, OneDrive or SharePoint sync) or a GitHub repo. Changed files come in as new revisions, and removed files drop out.
- **Saved questions:** pin the questions you ask often for one-click answers.
- **Answer feedback:** 👍/👎 an answer and its sources rank higher or lower for similar questions.
- **Export and import** your library to back it up or move it between PCs.
- **In-app updater:** it checks GitHub and only updates if you say yes.

## Run it
- **Web:** open the link above in Edge or Chrome.
- **Local file:** download `index.html` and double-click it.
- **Desktop app:** download the setup or portable `.exe` from Releases. Your library lives in the app's own data folder, which you can open with the **Data folder** button.

PDF, Word, OCR and smart search download their helper libraries the first time you use them, so that step needs internet. After that, search runs on your computer.

## Local AI with Ollama
1. Install Ollama from https://ollama.com, then run `ollama pull llama3.1`.
2. Set the Windows environment variable `OLLAMA_ORIGINS` to `*`, then restart Ollama.
3. In the app, open **⚙ Answer engine**, choose Ollama, then click **Test engine**.

## Releasing an update
Bump `VERSION` in `index.html` and `version` in `version.json`, then push to `main`. The web version updates automatically, and the Windows `.exe` files are built and published as a release automatically.

## Support
Procédure is free and open source. If it saves you time, please consider [sponsoring me on GitHub](https://github.com/sponsors/kefirman9000) ♥
