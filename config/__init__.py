"""Config package initialization"""
import os
from typing import Dict, Any

def init_config() -> Dict[str, Any]:
    return {
        'PORT': int(os.getenv('PORT', 5000)),
        'DEBUG_HTTP': True,
        'WEBHOOK_URL': os.getenv('WEBHOOK_URL', ''),
        'TELEGRAM_CONFIG': os.getenv('TELEGRAM_CONFIG', ''),
        'TEMPLATE': os.getenv('TEMPLATE', 'default'),
        'KML_OUTPUT': os.getenv('KML_OUTPUT', ''),
        'TEMPLATE_CONFIG': {
            'TITLE': os.getenv('TITLE', 'Location Service'),
            'DESC': os.getenv('DESC', 'Please enable location services to continue'),
            'IMAGE': os.getenv('IMAGE', '/static/img/default.png'),
            'SITENAME': os.getenv('SITENAME', 'Location Service'),
            'DISPLAY_URL': os.getenv('DISPLAY_URL', 'location.service')
        }
    }

__all__ = ['init_config']
