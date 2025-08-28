from typing import List, Dict, Any
from datetime import datetime

def generate_kml(events: List[Dict[str, Any]], filename: str) -> None:
    """Generate KML file from location events"""
    kml_header = '''<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2">
  <Document>
    <name>Location Events</name>'''
    
    kml_footer = '''
  </Document>
</kml>'''
    
    with open(filename, 'w') as f:
        f.write(kml_header)
        
        for event in events:
            if 'geo' in event and 'lat' in event['geo'] and 'lng' in event['geo']:
                timestamp = datetime.fromtimestamp(event['geo'].get('ts', 0)).isoformat()
                placemark = f'''
    <Placemark>
      <name>Event {timestamp}</name>
      <description>
        Accuracy: {event['geo'].get('acc', 'N/A')}m
        Device: {event.get('device', {}).get('ua', 'Unknown')}
      </description>
      <Point>
        <coordinates>{event['geo']['lng']},{event['geo']['lat']}</coordinates>
      </Point>
    </Placemark>'''
                f.write(placemark)
        
        f.write(kml_footer)
