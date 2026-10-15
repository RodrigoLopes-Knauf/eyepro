@echo off
title DataGate Remote Live - Servidor Node
cd /d "%~dp0"
echo ========================================================
echo   Iniciando Servidor Node (Relay & Web Viewer)
echo ========================================================
echo.
node server.js
pause
