#!/bin/zsh

# Kill any existing server on port 8080
lsof -ti:8080 | xargs kill -9 2>/dev/null

# Start a simple HTTP server serving the public directory
echo "Starting GrumpyBids at http://localhost:8080"
python3 -m http.server 8080 --directory "$(dirname "$0")/public"
