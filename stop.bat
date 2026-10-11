@echo off
set "ROOT=%~dp0"
echo ========================================
echo   AI Interview Agent - Demo Stop
echo ========================================
echo.

echo [1/2] Stopping frontend dev server...
taskkill /FI "WINDOWTITLE eq AI-Interview Frontend*" /F >nul 2>&1
echo       Closing frontend window...

REM Release port 3000 - kill process listening on 3000 by PID
for /f "tokens=5" %%a in ('netstat -ano ^| findstr ":3000 " ^| findstr LISTENING') do (
    taskkill /PID %%a /F >nul 2>&1
    echo       Killed PID %%a (was holding port 3000)
)
echo       Frontend stopped, port 3000 released

echo.
echo [2/2] Stopping backend containers...
cd /d "%ROOT%ai-interview-backend"
docker compose -f docker-compose.yml -f docker-compose.dev.yml down

echo.
echo ========================================
echo   Demo stopped
echo ========================================
echo.
pause
