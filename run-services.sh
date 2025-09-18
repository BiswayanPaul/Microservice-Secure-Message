#!/bin/bash

# Script to run all microservices
echo "Starting microservices..."

# Function to kill background processes on exit
cleanup() {
    echo "Stopping services..."
    pkill -f "spring-boot:run"
    exit
}

# Set trap to cleanup on script exit
trap cleanup EXIT

# Start auth service
echo "Starting Auth Service on port 8080..."
cd auth-service
mvn spring-boot:run &
AUTH_PID=$!

# Wait a bit for auth service to start
sleep 10

# Start encryption service
echo "Starting Encryption Service on port 8081..."
cd ../encryption-service
mvn spring-boot:run &
ENCRYPTION_PID=$!

# Wait a bit for encryption service to start
sleep 10

# Start message service
echo "Starting Message Service on port 8082..."
cd ../message-service
mvn spring-boot:run &
MESSAGE_PID=$!

echo "All services started!"
echo "Auth Service: http://localhost:8080"
echo "Encryption Service: http://localhost:8081" 
echo "Message Service: http://localhost:8082"
echo ""
echo "Press Ctrl+C to stop all services"

# Wait for all background processes
wait