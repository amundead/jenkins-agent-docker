#!/bin/bash
set -e

# Start Docker daemon
dockerd &

# Wait for Docker to start (optional)
timeout 20 sh -c 'until docker info; do echo .; sleep 1; done'

# Start Jenkins agent as the main process
exec "$@"
