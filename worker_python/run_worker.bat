@echo off
title DataGate Remote Live - Worker Python (Computador Corporativo)
cd /d "%~dp0"
echo ========================================================
echo   Iniciando Worker Python (Captura & Controle Remoto)
echo ========================================================
echo.

if not exist ".env" (
    if exist ".env.example" (
        echo [AVISO] Arquivo .env nao encontrado. Copiando .env.example para .env...
        copy .env.example .env >nul
        echo [INFO] Edite o arquivo .env com a RELAY_URL e WORKER_SECRET da sua VPS.
        echo.
    )
)

if exist ".\.venv\Scripts\python.exe" (
    echo [INFO] Utilizando ambiente virtual local (.venv)...
    ".\.venv\Scripts\python.exe" worker.py
) else if exist "..\..\worker_python_project\app\.venv\Scripts\python.exe" (
    echo [INFO] Utilizando ambiente virtual do projeto...
    "..\..\worker_python_project\app\.venv\Scripts\python.exe" worker.py
) else (
    echo [INFO] Utilizando python global do sistema...
    python worker.py
)

pause
