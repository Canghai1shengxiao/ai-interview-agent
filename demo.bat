@echo off
set "ROOT=%~dp0"
echo ========================================
echo   AI Interview Agent - Demo Start
echo ========================================
echo.

echo [1/2] Starting backend containers...
cd /d "%ROOT%ai-interview-backend"
docker compose -f docker-compose.yml -f docker-compose.dev.yml up -d
if errorlevel 1 (
    echo.
    echo [ERROR] Backend start failed. Check Docker Desktop is running.
    pause
    exit /b 1
)

echo.
echo [2/2] Starting frontend dev server in new window...
start "AI-Interview Frontend" /D "%ROOT%ai-interview-frontend" cmd /k "npm run dev"

echo       Waiting 6 seconds for frontend...
timeout /t 6 /nobreak >nul

echo.
echo ========================================
echo   Demo started
echo ========================================
echo.
echo   NOTE: Backend needs ~30s to be ready. If login fails, wait and retry.
echo.
echo   URL:       http://localhost:3000
echo   API docs:  http://localhost:8006/client/docs
echo.
echo   Stop frontend: close the "AI-Interview Frontend" window
echo   Stop backend:  docker compose down  (run in ai-interview-backend dir)
echo.
pause
