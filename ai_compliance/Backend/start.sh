#!/bin/bash
echo "Starting XML Compliance Checker..."
echo "Port: $PORT"
echo "Environment: $FLASK_ENV"

# Start the application using gunicorn
exec gunicorn --bind 0.0.0.0:$PORT --workers 2 --timeout 120 --preload main:app