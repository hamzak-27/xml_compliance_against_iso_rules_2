# Multi-stage build
FROM node:18-alpine as frontend-build

# Build frontend
WORKDIR /frontend
COPY ../Frontend/package*.json ./
RUN npm ci
COPY ../Frontend/ ./
RUN npm run build

# Python backend stage
FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Copy requirements first for better Docker layer caching
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy backend code
COPY . .

# Copy built frontend from previous stage
COPY --from=frontend-build /frontend/dist ./Frontend/dist

# Expose the port that Flask runs on
EXPOSE 5000

# Set environment variables
ENV FLASK_ENV=production
ENV PYTHONUNBUFFERED=1
ENV PORT=5000

# Create non-root user for security
RUN adduser --disabled-password --gecos '' --shell /bin/bash user && chown -R user:user /app
USER user

# Run the Flask application with Gunicorn for production
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "--workers", "4", "--timeout", "120", "main:app"]
