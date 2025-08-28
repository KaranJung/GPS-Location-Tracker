@echo off
setlocal enabledelayedexpansion

REM GPS Tracker Setup and Run Script for Windows
REM Educational Location Tracking Demo

echo ==================================================================
echo EDUCATIONAL PURPOSES ONLY - Consent-Based Location Collection Demo
echo ==================================================================
echo WARNING: This tool is for educational and research purposes only.
echo Always obtain proper consent before collecting location data.
echo.

REM Check if Python is installed
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Python is not installed. Please install Python 3.7+ first.
    pause
    exit /b 1
)

echo [INFO] Python found, checking version...
for /f \"tokens=2\" %%i in ('python --version 2^>^&1') do set PYTHON_VERSION=%%i
echo [INFO] Python version: %PYTHON_VERSION%

REM Create virtual environment if it doesn't exist
if not exist \".venv\" (
    if not exist \"venv\" (
        echo [INFO] Creating virtual environment...
        python -m venv .venv
    )
)

REM Activate virtual environment
if exist \".venv\" (
    echo [INFO] Activating virtual environment (.venv)...
    call .venv\\Scripts\\activate.bat
) else if exist \"venv\" (
    echo [INFO] Activating virtual environment (venv)...
    call venv\\Scripts\\activate.bat
) else (
    echo [ERROR] Failed to create virtual environment
    pause
    exit /b 1
)

REM Upgrade pip
echo [INFO] Upgrading pip...
python -m pip install --upgrade pip

REM Install requirements
echo [INFO] Installing Python dependencies...
pip install -r requirements.txt

REM Set environment variables
set FLASK_APP=app.py
set FLASK_ENV=development
if not defined SECRET_KEY (
    for /f %%i in ('python -c \"import secrets; print(secrets.token_hex(32))\"') do set SECRET_KEY=%%i
)
if not defined ADMIN_PASSWORD set ADMIN_PASSWORD=admin123
if not defined PORT set PORT=5000

REM Create .env file if it doesn't exist
if not exist \".env\" (
    echo [INFO] Creating .env file with default settings...
    (
        echo # Flask Configuration
        echo FLASK_APP=app.py
        echo FLASK_ENV=development
        echo SECRET_KEY=%SECRET_KEY%
        echo.
        echo # Admin Configuration
        echo ADMIN_PASSWORD=%ADMIN_PASSWORD%
        echo.
        echo # Server Configuration
        echo PORT=%PORT%
        echo DEBUG_HTTP=true
        echo.
        echo # Optional: Webhook Configuration
        echo # WEBHOOK_URL=https://your-webhook-url.com/webhook
        echo # TELEGRAM_CONFIG=bot_token:chat_id
    ) > .env
    echo [INFO] Created .env file with default configuration
) else (
    echo [INFO] Using existing .env file
)

REM Check if port is available
netstat -an | find \":%PORT%\" | find \"LISTENING\" >nul 2>&1
if %errorlevel% equ 0 (
    echo [WARNING] Port %PORT% is already in use. The server might already be running.
    echo To stop existing server: taskkill /f /im python.exe
    set /p continue=\"Continue anyway? (y/N): \"
    if /i not \"!continue!\"==\"y\" exit /b 1
)

echo ==================================================================
echo Starting GPS Tracker Server
echo ==================================================================
echo [INFO] Starting server on port %PORT%...
echo [INFO] Admin password: %ADMIN_PASSWORD%
echo [INFO] Press Ctrl+C to stop the server
echo.

echo ==================================================================
echo Server Information
echo ==================================================================
echo [INFO] Local access: http://localhost:%PORT%
echo [INFO] Admin dashboard: http://localhost:%PORT%/admin_893b4de8f1
echo [INFO] Admin password: %ADMIN_PASSWORD%
echo.

REM Get local IP address
for /f \"tokens=2 delims=:\" %%i in ('ipconfig ^| find \"IPv4\"') do (
    set LOCAL_IP=%%i
    set LOCAL_IP=!LOCAL_IP: =!
    echo [INFO] Network access: http://!LOCAL_IP!:%PORT%
    goto :found_ip
)
:found_ip

echo.
echo ==================================================================
echo External Access Options
echo ==================================================================
echo [INFO] For external/mobile device testing, use one of these:
echo • ngrok: ngrok http %PORT%
echo • localtunnel: npx localtunnel --port %PORT%
echo • cloudflared: cloudflared tunnel --url localhost:%PORT%
echo.

echo ==================================================================
echo Usage Instructions
echo ==================================================================
echo [INFO] 1. Visit the main page to start location tracking
echo [INFO] 2. Access admin dashboard with password: %ADMIN_PASSWORD%
echo [INFO] 3. Monitor real-time location events in the admin interface
echo.

echo [WARNING] Remember: This is for educational purposes only!
echo [WARNING] Always obtain proper consent before collecting location data.
echo.

echo [INFO] Starting server...
python app.py

pause