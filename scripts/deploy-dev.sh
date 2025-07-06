#!/bin/bash
# Quick deployment script for development
# Usage: ./scripts/deploy-dev.sh [target]
# Targets: rpi5 (staging), rpi-zero (production)

set -e

TARGET=${1:-rpi5}
BRANCH=${2:-$(git branch --show-current)}

echo "🚀 Deploying Trimix Analyzer to $TARGET"
echo "📝 Branch: $BRANCH"

case $TARGET in
  rpi5|staging)
    echo "🏗️  Building and deploying to RPi 5 (staging)..."
    HOST=${RPI5_HOST:-"raspberrypi5.local"}
    USER=${RPI5_USER:-"pi"}
    ;;
  rpi-zero|production)
    echo "🏗️  Building and deploying to RPi Zero 2W (production)..."
    HOST=${RPI_ZERO_HOST:-"trimix-analyzer.local"}
    USER=${RPI_ZERO_USER:-"pi"}
    ;;
  *)
    echo "❌ Unknown target: $TARGET"
    echo "Available targets: rpi5, rpi-zero"
    exit 1
    ;;
esac

# Build and push image
echo "📦 Building Docker image..."
docker buildx build --platform linux/arm64,linux/arm/v7 -t trimix-analyzer:$BRANCH --target production .

# Deploy to target
echo "🚢 Deploying to $HOST..."
rsync -av --exclude='.git' --exclude='__pycache__' . $USER@$HOST:/opt/trimix-analyzer/

ssh $USER@$HOST << EOF
  cd /opt/trimix-analyzer
  docker-compose down
  docker-compose pull || echo "Pull failed, using local build"
  docker-compose up -d
  docker system prune -f
  echo "✅ Deployment complete!"
  echo "📊 Container status:"
  docker-compose ps
  echo "📝 Logs (last 20 lines):"
  docker-compose logs --tail=20 trimix-analyzer
EOF

echo "🎉 Deployment to $TARGET completed successfully!"
echo "🌐 Access your device at: http://$HOST"
