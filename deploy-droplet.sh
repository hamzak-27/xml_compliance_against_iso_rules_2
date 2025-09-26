#!/bin/bash

# DigitalOcean Droplet Deployment Script
# This script automates the deployment of the XML Compliance Checker to a DigitalOcean droplet

echo "🚀 Starting DigitalOcean Droplet Deployment..."

# Check if .env file exists
if [ ! -f .env ]; then
    echo "❌ Error: .env file not found!"
    echo "Please copy .env.example to .env and update with your values:"
    echo "  cp .env.example .env"
    echo "  nano .env  # Update OPENAI_API_KEY and other values"
    exit 1
fi

# Check if required environment variables are set
source .env
if [ -z "$OPENAI_API_KEY" ] || [ "$OPENAI_API_KEY" = "your_openai_api_key_here" ]; then
    echo "❌ Error: OPENAI_API_KEY not set in .env file!"
    echo "Please update .env with your actual OpenAI API key"
    exit 1
fi

echo "✅ Environment file validated"

# Update system packages
echo "📦 Updating system packages..."
sudo apt update && sudo apt upgrade -y

# Install Docker and Docker Compose if not already installed
if ! command -v docker &> /dev/null; then
    echo "🐳 Installing Docker..."
    sudo apt install docker.io docker-compose -y
    sudo systemctl start docker
    sudo systemctl enable docker
    sudo usermod -aG docker $USER
    echo "Docker installed successfully!"
else
    echo "✅ Docker already installed"
fi

# Pull latest changes (if this is a git repository)
if [ -d .git ]; then
    echo "🔄 Pulling latest changes..."
    git pull origin main
fi

# Build and start services
echo "🏗️  Building Docker containers..."
sudo docker-compose build --no-cache

echo "🚀 Starting services..."
sudo docker-compose up -d

# Wait for services to start
echo "⏳ Waiting for services to start..."
sleep 30

# Check if services are running
echo "🔍 Checking service status..."
sudo docker-compose ps

# Test backend health
echo "🏥 Testing backend health..."
if curl -f http://localhost:5000/api/health > /dev/null 2>&1; then
    echo "✅ Backend is healthy!"
else
    echo "❌ Backend health check failed!"
    echo "Check logs with: sudo docker-compose logs backend"
fi

# Test frontend
echo "🌐 Testing frontend..."
if curl -f http://localhost/ > /dev/null 2>&1; then
    echo "✅ Frontend is accessible!"
else
    echo "❌ Frontend is not accessible!"
    echo "Check logs with: sudo docker-compose logs frontend"
fi

# Configure firewall
echo "🔥 Configuring firewall..."
sudo ufw allow 22      # SSH
sudo ufw allow 80      # HTTP
sudo ufw allow 443     # HTTPS
sudo ufw --force enable

# Display deployment information
echo "🎉 Deployment completed!"
echo ""
echo "📊 Service Information:"
echo "  - Frontend: http://$(curl -s http://checkip.amazonaws.com/)/"
echo "  - Backend API: http://$(curl -s http://checkip.amazonaws.com/):5000/api"
echo "  - Health Check: http://$(curl -s http://checkip.amazonaws.com/):5000/api/health"
echo ""
echo "📋 Useful Commands:"
echo "  - View logs: sudo docker-compose logs -f"
echo "  - Restart services: sudo docker-compose restart"
echo "  - Stop services: sudo docker-compose down"
echo "  - Update app: git pull && sudo docker-compose up -d --build"
echo ""
echo "🔒 Security Notes:"
echo "  - Consider setting up SSL with Let's Encrypt"
echo "  - Regular security updates are recommended"
echo "  - Monitor logs for suspicious activity"