$ErrorActionPreference = "Stop"

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $scriptDir

$logDir = Join-Path $scriptDir "logs"
New-Item -ItemType Directory -Force -Path $logDir | Out-Null

$logFile = Join-Path $logDir "daily-news.log"
$startedAt = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
Add-Content -Path $logFile -Encoding UTF8 -Value "[$startedAt] Starting daily AI news generation"

try {
  $node = (Get-Command node -ErrorAction Stop).Source
  $previousErrorActionPreference = $ErrorActionPreference
  try {
    $ErrorActionPreference = "Continue"
    $output = & $node "daily_news.js" 2>&1
    $exitCode = $LASTEXITCODE
  }
  finally {
    $ErrorActionPreference = $previousErrorActionPreference
  }

  foreach ($line in $output) {
    Add-Content -Path $logFile -Encoding UTF8 -Value $line.ToString()
  }

  if ($exitCode -ne 0) {
    throw "node daily_news.js exited with code $exitCode"
  }

  $finishedAt = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
  Add-Content -Path $logFile -Encoding UTF8 -Value "[$finishedAt] Finished successfully"
}
catch {
  $failedAt = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
  Add-Content -Path $logFile -Encoding UTF8 -Value "[$failedAt] Failed: $($_.Exception.Message)"
  throw
}
