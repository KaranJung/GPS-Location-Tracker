from typing import Dict
import user_agents

def parse_user_agent(ua_string: str) -> Dict[str, str]:
    """Parse User-Agent string into components"""
    ua = user_agents.parse(ua_string)
    return {
        'browser': f"{ua.browser.family} {ua.browser.version_string}",
        'os': f"{ua.os.family} {ua.os.version_string}",
        'device': ua.device.family,
        'is_mobile': ua.is_mobile,
        'is_tablet': ua.is_tablet,
        'is_pc': ua.is_pc
    }
