#!/bin/bash

# NetRun Docker Build Script
# Usage: ./build.sh [OPTIONS]

set -e

# Default values
BUILD_WEB=true
BUILD_RUNNER=true
START_CONTAINERS=true
REBUILD=false

show_help() {
    cat << EOF
NetRun Docker Build Script

Usage: $0 [OPTIONS]

OPTIONS:
    -h, --help          Show this help message
    -w, --web-only      Build web server container only
    -r, --runner-only   Build code runner container only
    -n, --no-start      Build containers but don't start them
    --rebuild           Force rebuild without cache
    --clean             Remove all containers and volumes first

EXAMPLES:
    $0                  # Build and start all containers
    $0 --web-only       # Build only web server
    $0 --rebuild        # Force rebuild all containers
    $0 --clean          # Clean environment and rebuild

EOF
}

clean_environment() {
    echo "🧹 Cleaning existing NetRun containers and volumes..."
    docker compose down -v 2>/dev/null || true
    docker rmi netrun-web netrun-runner 2>/dev/null || true
    docker system prune -f
    echo "✅ Environment cleaned"
}

build_containers() {
    local cache_flag=""
    if [ "$REBUILD" = true ]; then
        cache_flag="--no-cache"
    fi

    echo "🔨 Building NetRun containers..."
    
    if [ "$BUILD_WEB" = true ]; then
        echo "🌐 Building web server container..."
        docker build $cache_flag -f Dockerfile.webserver -t netrun-web .
        echo "✅ Web server container built"
    fi
    
    if [ "$BUILD_RUNNER" = true ]; then
        echo "⚙️  Building code runner container..."
        docker build $cache_flag -f Dockerfile.runner -t netrun-runner .
        echo "✅ Code runner container built"
    fi
}

start_containers() {
    if [ "$START_CONTAINERS" = true ]; then
        echo "🚀 Starting NetRun containers..."
        docker compose up -d
        
        echo "⏳ Waiting for containers to be ready..."
        sleep 10
        
        # Check if containers are running
        if docker compose ps | grep -q "running"; then
            echo "✅ NetRun is running!"
            echo ""
            echo "🌐 Access NetRun at: http://localhost:8080/netrun/run.cgi"
            echo ""
            echo "📊 Container status:"
            docker compose ps
        else
            echo "❌ Failed to start containers"
            echo "📋 Logs:"
            docker compose logs
            exit 1
        fi
    fi
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            show_help
            exit 0
            ;;
        -w|--web-only)
            BUILD_WEB=true
            BUILD_RUNNER=false
            ;;
        -r|--runner-only)
            BUILD_WEB=false
            BUILD_RUNNER=true
            ;;
        -n|--no-start)
            START_CONTAINERS=false
            ;;
        --rebuild)
            REBUILD=true
            ;;
        --clean)
            clean_environment
            ;;
        *)
            echo "Unknown option: $1"
            show_help
            exit 1
            ;;
    esac
    shift
done

# Main execution
echo "🎯 NetRun Docker Build Script"
echo "==============================="

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker is not running. Please start Docker first."
    exit 1
fi

# Check if docker compose is available
if ! docker compose version > /dev/null 2>&1; then
    echo "❌ docker compose is not available."
    exit 1
fi

build_containers
start_containers

echo ""
echo "🎉 NetRun deployment complete!"
echo ""
echo "📚 For more information, see DOCKER.md"