<# : batch part - this file is both a Windows batch file and a PowerShell script
@echo off
set "PROC_MODEL=%~1"
if "%PROC_MODEL%"=="" set "PROC_MODEL=auto"
powershell -NoProfile -ExecutionPolicy Bypass -Command "iex ([IO.File]::ReadAllText('%~f0'))"
exit /b
#>
# Procedure - local AI setup (source: https://github.com/kefirman9000/Procedure/blob/main/setup/Setup-Local-AI.cmd)
$ErrorActionPreference = "Continue"
$Model = $env:PROC_MODEL
if (-not $Model) { $Model = "auto" }
$Host.UI.RawUI.WindowTitle = "Procedure - Local AI setup"
function Step($n, $t) { Write-Host ""; Write-Host "[$n/4] $t" -ForegroundColor Cyan }
function Done-Fail($msg) { Write-Host ""; Write-Host $msg -ForegroundColor Red; Read-Host "Press Enter to close" | Out-Null; exit 1 }
Write-Host "Procedure - local AI setup" -ForegroundColor Green
Write-Host "This installs Ollama (free, from ollama.com), lets Procedure use it, and downloads an AI model."
Write-Host "Everything runs on this computer. Your documents never leave it."
Write-Host ""
Read-Host "Press Enter to start (or close this window to cancel)" | Out-Null

function Find-Ollama {
  $c = Get-Command ollama.exe -ErrorAction SilentlyContinue
  if ($c) { return $c.Source }
  foreach ($p in @("$env:LOCALAPPDATA\Programs\Ollama\ollama.exe", "$env:ProgramFiles\Ollama\ollama.exe")) { if (Test-Path $p) { return $p } }
  return $null
}

Step 1 "Installing Ollama"
$exe = Find-Ollama
if ($exe) { Write-Host "Ollama is already installed." }
else {
  if (Get-Command winget -ErrorAction SilentlyContinue) {
    winget install --id Ollama.Ollama -e --silent --accept-source-agreements --accept-package-agreements
    $exe = Find-Ollama
  }
  if (-not $exe) {
    $tmp = Join-Path $env:TEMP "OllamaSetup.exe"
    Write-Host "Downloading the installer from ollama.com (about 1 GB)..."
    try {
      [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
      $ProgressPreference = "SilentlyContinue"
      Invoke-WebRequest "https://ollama.com/download/OllamaSetup.exe" -OutFile $tmp -UseBasicParsing
      Start-Process $tmp -ArgumentList "/VERYSILENT", "/NORESTART" -Wait
    } catch { Write-Host "Download failed: $_" -ForegroundColor Red }
    $exe = Find-Ollama
  }
  if (-not $exe) { Done-Fail "Couldn't install Ollama automatically. Install it from https://ollama.com/download and run this again." }
  Write-Host "Ollama installed."
}

Step 2 "Allowing Procedure (and only Procedure) to use Ollama"
$allow = "https://kefirman9000.github.io,file://*,null"
$cur = [Environment]::GetEnvironmentVariable("OLLAMA_ORIGINS", "User")
if ($cur -match "kefirman9000") { $allow = $cur } elseif ($cur) { $allow = "$cur,$allow" }
[Environment]::SetEnvironmentVariable("OLLAMA_ORIGINS", $allow, "User")
$env:OLLAMA_ORIGINS = $allow
Write-Host "Allowed: the Procedure website, the Procedure desktop app, and Procedure opened as a file on this PC. Other websites can't use it."

Step 3 "Starting Ollama"
Get-Process -Name "ollama", "ollama app" -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
Start-Sleep -Seconds 2
$app = Join-Path (Split-Path $exe) "ollama app.exe"
if (Test-Path $app) { Start-Process $app } else { Start-Process $exe -ArgumentList "serve" -WindowStyle Hidden }
$up = $false
for ($i = 0; $i -lt 60; $i++) {
  try { Invoke-RestMethod "http://localhost:11434/api/version" -TimeoutSec 2 | Out-Null; $up = $true; break } catch { Start-Sleep -Seconds 1 }
}
if (-not $up) { Done-Fail "Ollama didn't start. Restart your computer, then run this again." }
Write-Host "Ollama is running."

Step 4 "Downloading the AI model"
if ($Model -eq "auto") {
  $gb = [math]::Round((Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory / 1GB)
  if ($gb -ge 16) { $Model = "llama3.1:8b" } elseif ($gb -ge 8) { $Model = "llama3.2:3b" } else { $Model = "llama3.2:1b" }
  Write-Host "This PC has $gb GB of memory, so using $Model."
}
& $exe pull $Model
if ($LASTEXITCODE -ne 0) { Done-Fail "The model download didn't finish. Check your internet connection and run this again." }

Write-Host ""
Write-Host "All set! Local AI is ready ($Model)." -ForegroundColor Green
Write-Host "Go back to Procedure - it connects by itself within a few seconds."
Write-Host "(Or open Answer engine and click 'Detect & connect'.)"
Read-Host "Press Enter to close" | Out-Null
