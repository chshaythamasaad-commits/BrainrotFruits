@echo off
cd /d "%~dp0"
powershell.exe -NoLogo -ExecutionPolicy Bypass -NoExit -File "%~dp0start-rojo.ps1"
