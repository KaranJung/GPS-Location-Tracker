from typing import Optional, Dict, Any
import threading
import requests
from requests.exceptions import RequestException
import logging

logger = logging.getLogger(__name__)

def send_webhook(url: str, data: Dict[str, Any]) -> None:
    """Send data to webhook URL asynchronously"""
    try:
        response = requests.post(url, json=data, timeout=5)
        response.raise_for_status()
        logger.info(f"Webhook sent successfully to {url}")
    except RequestException as e:
        logger.error(f"Webhook failed: {str(e)}")

def send_telegram(token: str, chat_id: str, event: Dict[str, Any]) -> None:
    """Send event notification to Telegram"""
    try:
        url = f"https://api.telegram.org/bot{token}/sendMessage"
        lat = event.get('geo', {}).get('lat')
        lng = event.get('geo', {}).get('lng')
        acc = event.get('geo', {}).get('acc')
        
        message = (
            f"🌍 New Location Event\n"
            f"Lat: {lat}\n"
            f"Lng: {lng}\n"
            f"Accuracy: {acc}m\n"
            f"Google Maps: https://www.google.com/maps?q={lat},{lng}"
        )
        
        response = requests.post(url, json={
            'chat_id': chat_id,
            'text': message,
            'parse_mode': 'HTML'
        }, timeout=5)
        response.raise_for_status()
        logger.info("Telegram notification sent successfully")
    except RequestException as e:
        logger.error(f"Telegram notification failed: {str(e)}")

def forward_event(event: Dict[str, Any], webhook_url: Optional[str] = None, 
                 telegram_config: Optional[str] = None) -> None:
    """Forward event to configured services"""
    if webhook_url:
        thread = threading.Thread(target=send_webhook, args=(webhook_url, event))
        thread.daemon = True
        thread.start()
    
    if telegram_config and ':' in telegram_config:
        token, chat_id = telegram_config.split(':', 1)
        thread = threading.Thread(target=send_telegram, args=(token, chat_id, event))
        thread.daemon = True
        thread.start()
