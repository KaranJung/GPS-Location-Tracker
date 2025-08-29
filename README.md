<p align="center">
  <img src="https://images-wixmp-ed30a86b8c4ca887773594c2.wixmp.com/i/f0d862b3-1479-4b52-ada5-c1be455a97cd/d7l7w5e-5ff824b4-cf8c-4df7-8565-52fefc813e84.png/v1/fill/w_503,h_497,strp/hydra_logo_3_by_silver2012_d7l7w5e-fullview.png" 
       alt="Hydra Logo" width="150" />
</p>

<h1 align="center" style="color:red;">🟥 HYDRA GPS Location Tracker 🟥</h1>
<p align="center">
  <b>Real-time location and device tracking system with admin dashboard — for <i>educational purposes only</i>.</b>
</p>

---

## 🚀 Quick Start

### Automated Setup (Recommended)

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
cp .env.example .env
# Edit .env file with your preferred settings
```

4. **Run the application:**
```bash
python app.py
```

---

## 📋 Requirements

### Core Dependencies
- **Flask 2.3.3** – Web framework  
- **user-agents 2.2.0** – User agent parsing  
- **requests 2.31.0** – HTTP requests  
- **Werkzeug 2.3.7** – WSGI utilities  
- **Jinja2 3.1.2** – Templating engine  

### Additional Features
- **Flask-CORS** – Cross-origin sharing  
- **python-dotenv** – Env variable management  
- **gunicorn** – Production WSGI server  
- **cryptography** – Security features  

### Development Tools
- **pytest** – Testing  
- **flake8, black, isort** – Code quality  
- **mypy** – Type checking  
- **bandit, safety** – Security scanning  

---

## 📂 Project Structure

```
gps_tracker_auto/
├── app.py               # Main Flask application
├── config/              # Configuration settings
├── static/              # CSS, JS assets
├── templates/           # HTML templates
└── utils/               # Helpers (UA parsing, webhooks)
```

---

## 🌐 Features

1. **Target Page** (`http://localhost:5000/`)  
   - Mimics news article (Nepal corruption topic)  
   - Collects **GPS + device data** stealthily  
   - No obvious indicators  

2. **Admin Dashboard** (`http://localhost:5000/admin_893b4de8f1`)  
   - Password protected (default: `admin123`)  
   - Real-time **map tracking + logs**  
   - Auto-refresh capability  

3. **Collected Data**  
   - GPS + accuracy  
   - Device hardware + browser  
   - IP + Canvas fingerprint  

---

## ⚙️ Configuration

Environment variables or CLI args:

- `PORT` / `--port` – Server port (default: 5000)  
- `TEMPLATE` / `--template` – HTML template (default: `default`)  
- `DEBUG_HTTP` / `--debug-http` – Disable HTTPS enforcement  
- `WEBHOOK` / `--webhook` – Webhook URL for logs  
- `TELEGRAM` / `--telegram` – Bot `token:chat_id`  
- `KML_OUTPUT` / `--kml` – Export path for KML  

---

## 🎨 Templates

- **Default** – Basic permission prompt  
- **News** – Article layout, requires location for access  

### Adding Custom Templates
1. Create folder under `templates/`  
2. Add `index.html` extending `base.html`  
3. Include `capture.js` + location trigger  
4. Select via `--template` or `TEMPLATE` env var  

---

## 🌍 External Access

```bash
# ngrok
ngrok http 5000

# localtunnel
lt --port 5000

# serveo
ssh -R 80:localhost:5000 serveo.net
```

---

## 🔒 Privacy & Ethics

- Uses **standard browser prompts** (no exploits)  
- **No bypasses or dark patterns**  
- Data stored in **memory only** (no DB persistence)  
- Strictly for **educational & research purposes**  

---

## 📜 License
This project is licensed under the **MIT License** – see [LICENSE](LICENSE).  

---

<p align="center">
  <img src="https://upload.wikimedia.org/wikipedia/en/9/9b/Hydra_symbol.png" alt="Hydra Symbol" width="100" />
  <br>
  <i>“Cut off one head, two more shall take its place.”</i>
</p>
