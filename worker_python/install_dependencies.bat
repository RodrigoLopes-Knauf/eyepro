@echo off
title DataGate Remote Live - Instalar Dependencias do Worker
cd /d "%~dp0"
echo ========================================================
echo   Instalando Dependencias do Worker no Computador
echo ========================================================
echo.

if not exist ".venv" (
    echo [INFO] Criando ambiente virtual Python (.venv)...
    python -m venv .venv
)

echo [INFO] Instalando pacotes necessarios (mss, pillow, pyautogui, websockets)...
.\.venv\Scripts\python.exe -m pip install --upgrade pip
.\.venv\Scripts\python.exe -m pip install -r requirements.txt

echo.
echo ========================================================
echo   Instalacao concluida com sucesso!
echo   Agora configure o arquivo .env e execute run_worker.bat
echo ========================================================
pause
