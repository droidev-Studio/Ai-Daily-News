param(
  [string]$TaskName = "Daily AI News",
  [string]$RunAt = "09:00"
)

$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$runner = Join-Path $repoRoot "combined-daily\run_daily_news.ps1"
$workingDirectory = Split-Path -Parent $runner
$powershell = Join-Path $env:SystemRoot "System32\WindowsPowerShell\v1.0\powershell.exe"

if (!(Test-Path $runner)) {
  throw "Runner script not found: $runner"
}

$runTime = [datetime]::ParseExact($RunAt, "HH:mm", [Globalization.CultureInfo]::InvariantCulture)
$action = New-ScheduledTaskAction `
  -Execute $powershell `
  -Argument "-NoProfile -ExecutionPolicy Bypass -File `"$runner`"" `
  -WorkingDirectory $workingDirectory

$trigger = New-ScheduledTaskTrigger -Daily -At $runTime
$settings = New-ScheduledTaskSettingsSet `
  -StartWhenAvailable `
  -AllowStartIfOnBatteries `
  -DontStopIfGoingOnBatteries `
  -ExecutionTimeLimit (New-TimeSpan -Hours 2)

$principal = New-ScheduledTaskPrincipal `
  -UserId $env:USERNAME `
  -LogonType Interactive `
  -RunLevel Limited

Register-ScheduledTask `
  -TaskName $TaskName `
  -Action $action `
  -Trigger $trigger `
  -Settings $settings `
  -Principal $principal `
  -Description "Generate the daily AI news digest from $repoRoot" `
  -Force | Out-Null

Write-Host "Installed scheduled task '$TaskName' to run every day at $RunAt."
Write-Host "Runner: $runner"
Write-Host "Log: $(Join-Path $workingDirectory 'logs\daily-news.log')"
