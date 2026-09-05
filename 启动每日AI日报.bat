@echo off
chcp 65001 > nul
title AI 每日日报定时任务

echo ========================================
echo     🤖 AI 每日日报自动运行系统
echo ========================================
echo.
echo ⏰ 运行时间: 每天早上 9:00 自动生成
echo 📂 保存位置: combined-daily\digests\
echo 🔢 保留份数: 20份（自动清理旧文件）
echo.
echo [提示] 正在安装 Windows 计划任务，不需要保持窗口开启
echo ========================================
echo.

cd /d "%~dp0"
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0install_windows_task.ps1"

echo.
echo 计划任务安装完成。日志位置: combined-daily\logs\daily-news.log

pause
