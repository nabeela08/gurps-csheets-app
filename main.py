#!/usr/bin/env python3
"""
WORDIAMO English Learning Platform
Main entry point for the Flask application
"""

import os
import sys

# Add the current directory to Python path
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

from app.app import create_app

# Create the Flask application
app = create_app()

if __name__ == '__main__':
    print("Starting WORDIAMO English Learning Platform...")
    print("Backend API Server")
    print("Frontend URL: http://127.0.0.1:5000")
    print("API Base URL: http://127.0.0.1:5000")
    print("Health Check: http://127.0.0.1:5000/health")
    print("-" * 50)
    
    # Run the Flask development server
    app.run(
        host='127.0.0.1',
        port=5000,
        debug=True,
        threaded=True
    )