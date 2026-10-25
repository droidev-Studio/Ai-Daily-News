@echo off
chcp 65001 > nul
title 安装 AI 每日日报计划任务

cd /d "%~dp0"
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0install_windows_task.ps1"

echo.
echo 计划任务安装完成。日志位置: combined-daily\logs\daily-news.log
pause

