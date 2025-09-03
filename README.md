<p align="center">
  <img src="https://images-wixmp-ed30a86b8c4ca887773594c2.wixmp.com/i/f0d862b3-1479-4b52-ada5-c1be455a97cd/d7l7w5e-5ff824b4-cf8c-4df7-8565-52fefc813e84.png/v1/fill/w_503,h_497,strp/hydra_logo_3_by_silver2012_d7l7w5e-fullview.png" 
       alt="Hydra Logo" width="150" />
</p>

# 🌍 GPS Location Tracker

[![Python](https://img.shields.io/badge/Python-3.10%2B-blue.svg)](https://www.python.org/)
[![Flask](https://img.shields.io/badge/Flask-2.3.3-green.svg)](https://flask.palletsprojects.com/)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Stars](https://img.shields.io/github/stars/KaranJung/GPS-Location-Tracker.svg)](https://github.com/KaranJung/GPS-Location-Tracker/stargazers)
[![Issues](https://img.shields.io/github/issues/KaranJung/GPS-Location-Tracker.svg)](https://github.com/KaranJung/GPS-Location-Tracker/issues)
[![Last Commit](https://img.shields.io/github/last-commit/KaranJung/GPS-Location-Tracker.svg)](https://github.com/KaranJung/GPS-Location-Tracker/commits/main)

**Real-time GPS tracking with admin dashboard and location analytics — for educational and consented testing purposes only.**


> ⚠️ **Educational Use Only**: This project is designed for consented demonstrations, security education, and authorized testing. Never deploy without explicit user consent or in violation of local laws.

## ✨ Features

- **🗺️ Real-time Map Dashboard** — Live tracking with auto-refresh
- **📊 Location Analytics** — GPS accuracy, device metadata, browser fingerprinting
- **📤 Export Options** — KML format for mapping tools
- **🔔 Notifications** — Webhook and Telegram integration
- **🖥️ Cross-Platform Setup** — One-command installation for Linux/macOS/Windows
- **🎨 Customizable Templates** — Multiple UI themes available

## 🚀 Quick Start

### One-Command Setup (Recommended)

**Linux/macOS:**
```bash
chmod +x scripts/setup_and_run.sh
./scripts/setup_and_run.sh
```

**Windows:**
```cmd
scripts\setup_and_run.bat
```

### Manual Setup

```bash
# Create virtual environment
python3 -m venv .venv

# Linux/macOS
source .venv/bin/activate

# Windows
.venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt

# Configure environment (optional)
cp .env.example .env
# Edit .env with your settings

# Run application
python app.py
```

## 🌐 Access URLs

- **Target Page**: `http://localhost:5000/`
- **Admin Dashboard**: `http://localhost:5000/admin_893b4de8f1` (configurable)

## ⚙️ Configuration

Create a `.env` file or use environment variables:

| Variable | Description | Default |
|----------|-------------|---------|
| `PORT` | Server port | `5000` |
| `TEMPLATE` | HTML template theme | `default` |
| `DEBUG_HTTP` | Disable HTTPS enforcement | `false` |
| `WEBHOOK` | Webhook URL for logs | `None` |
| `TELEGRAM` | Bot token:chat_id format | `None` |
| `KML_OUTPUT` | KML export file path | `None` |
| `ADMIN_PASSWORD` | Admin dashboard password | **Required** |
| `ADMIN_PATH` | Admin URL path | `admin_893b4de8f1` |

### Command Line Options

```bash
python app.py --port 8080 --template news --debug-http --webhook https://example.com/hook
```

## 🎯 How It Works

1. **Permission Request** → User visits target page and grants location access
2. **Data Collection** → JavaScript captures GPS coordinates, accuracy, and device info
3. **Server Logging** → Data stored and processed on Flask backend  
4. **Live Dashboard** → Admin panel displays real-time location updates on interactive map

## 📱 Collected Data

- **Location**: GPS coordinates with accuracy radius
- **Device**: Hardware specs, screen resolution, timezone
- **Browser**: User agent, canvas fingerprint, installed plugins
- **Network**: IP address and basic connection info

## 🎨 Available Templates

- **Default** — Clean permission prompt interface
- **News** — Article-style layout requiring location for content access

### Adding Custom Templates

1. Create folder under `templates/your-template/`
2. Add `index.html` extending `base.html`
3. Include `capture.js` for location functionality
4. Set via `--template your-template` or `TEMPLATE=your-template`

## 🌍 External Access

For testing beyond localhost, use tunneling services:

```bash
# ngrok
ngrok http 5000

# localtunnel  
lt --port 5000

# serveo
ssh -R 80:localhost:5000 serveo.net
```

> **Important**: Only use external access with explicit user consent and in compliance with applicable laws.

## 🛠️ Development

### Project Structure
```
gps_tracker/
├── app.py                 # Main Flask application
├── config/               # Configuration files
├── static/               # CSS, JS, assets  
├── templates/            # HTML templates
├── utils/                # Helper utilities
├── scripts/              # Setup scripts
└── requirements.txt      # Dependencies
```

### Dependencies

**Core:**
- Flask 2.3.3 — Web framework
- user-agents 2.2.0 — User agent parsing  
- requests 2.31.0 — HTTP client
- Werkzeug 2.3.7 — WSGI utilities

**Optional:**
- Flask-CORS — Cross-origin requests
- python-dotenv — Environment management
- gunicorn — Production server
- cryptography — Security features

## 🔒 Security & Privacy

- **Consent First**: Always obtain explicit user permission
- **Secure Defaults**: No hardcoded credentials or predictable paths
- **Local Only**: Designed for controlled, local testing environments
- **Data Handling**: Implement appropriate data retention and deletion policies

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)  
5. Open a Pull Request


## 🐛 Troubleshooting

**Location permission denied:**
- Reset site permissions in browser settings
- Ensure HTTPS is enabled (or use `DEBUG_HTTP=true` for local testing)

**Dashboard not updating:**
- Check browser console for JavaScript errors
- Verify auto-refresh is enabled
- Confirm server is receiving location data in logs

**Setup script fails:**
- Ensure Python 3.10+ is installed
- Try manual installation steps
- Check for antivirus blocking script execution

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## ⚖️ Legal Notice

This software is provided for educational and research purposes only. Users are responsible for ensuring compliance with all applicable laws and regulations regarding location tracking and data collection. The authors assume no liability for misuse.

---

**"Cut off one head, two more shall take its place."**

Made with ❤️ for educational purposes




