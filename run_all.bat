@echo off
title DataGate Remote Live - Iniciar Tudo
cd /d "%~dp0"
echo ========================================================
echo   Iniciando Prototipo Remoto (Node Server + Python Worker)
echo ========================================================
echo.

start "DataGate Node Server" cmd /k "cd server_node && node server.js"
timeout /t 2 /nobreak >nul

set VENV_PY=..\worker_python_project\app\.venv\Scripts\python.exe
if exist "%VENV_PY%" (
    start "DataGate Python Worker" cmd /k "cd worker_python && \"%VENV_PY%\" worker.py"
) else (
    start "DataGate Python Worker" cmd /k "cd worker_python && python worker.py"
)

echo.
echo Tudo iniciado! Abrindo navegador em http://localhost:8080 ...
start http://localhost:8080
