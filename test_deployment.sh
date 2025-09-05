#!/bin/bash

# Test script for Railway deployment
# Replace these URLs with your actual Railway service URLs

RAILS_URL="https://your-rails-service.up.railway.app"
PHASH_URL="https://your-phash-service.up.railway.app"
VGG16_URL="https://your-vgg16-service.up.railway.app"

echo "🧪 Testing Railway Deployment"
echo "=============================="

# Test Rails health
echo "1. Testing Rails health endpoint..."
curl -s "$RAILS_URL/up" && echo " ✅ Rails is healthy" || echo " ❌ Rails health check failed"

# Test pHash service
echo "2. Testing pHash service..."
curl -s "$PHASH_URL/ping" && echo " ✅ pHash service is healthy" || echo " ❌ pHash service failed"

# Test VGG16 service
echo "3. Testing VGG16 service..."
curl -s "$VGG16_URL/ping" && echo " ✅ VGG16 service is healthy" || echo " ❌ VGG16 service failed"

echo ""
echo "🎉 Deployment test complete!"
echo "Visit your Rails app at: $RAILS_URL"
