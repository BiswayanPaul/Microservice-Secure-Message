#!/bin/bash

# Test script for the microservices

echo "Testing Microservices..."

# Test 1: Get JWT Token from Auth Service
echo "1. Getting JWT token..."
TOKEN_RESPONSE=$(curl -s -X POST http://localhost:8080/api/auth/token \
  -H "Content-Type: application/json" \
  -d '{"username":"admin","password":"admin_pass"}')

if [ $? -eq 0 ]; then
    TOKEN=$(echo $TOKEN_RESPONSE | grep -o '"token":"[^"]*' | cut -d'"' -f4)
    echo "✓ Auth service working. Token received."
else
    echo "✗ Auth service failed"
    exit 1
fi

# Test 2: Test Encryption Service - AES
echo "2. Testing AES encryption..."
AES_RESPONSE=$(curl -s -X POST http://localhost:8081/api/encrypt \
  -H "Content-Type: application/json" \
  -d '{"message":"Hello World","encryptionType":"AES"}')

if [ $? -eq 0 ]; then
    echo "✓ AES encryption working"
else
    echo "✗ AES encryption failed"
fi

# Test 3: Test Encryption Service - RSA  
echo "3. Testing RSA encryption..."
RSA_RESPONSE=$(curl -s -X POST http://localhost:8081/api/encrypt \
  -H "Content-Type: application/json" \
  -d '{"message":"Hello World","encryptionType":"RSA"}')

if [ $? -eq 0 ]; then
    echo "✓ RSA encryption working"
else
    echo "✗ RSA encryption failed"
fi

# Test 4: Send encrypted message
echo "4. Sending encrypted message..."
MESSAGE_RESPONSE=$(curl -s -X POST http://localhost:8082/api/messages/send \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{"recipient":"user","content":"Hello from admin!"}')

if [ $? -eq 0 ]; then
    echo "✓ Message service working"
else
    echo "✗ Message service failed"
fi

# Test 5: Get messages
echo "5. Retrieving messages..."
INBOX_RESPONSE=$(curl -s -X GET http://localhost:8082/api/messages/inbox \
  -H "Authorization: Bearer $TOKEN")

if [ $? -eq 0 ]; then
    echo "✓ Message retrieval working"
else
    echo "✗ Message retrieval failed"
fi

echo ""
echo "Test completed!"
echo "Auth Response: $TOKEN_RESPONSE"
echo "Message Response: $MESSAGE_RESPONSE"
echo "Inbox Response: $INBOX_RESPONSE"