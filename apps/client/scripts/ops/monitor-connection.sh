#!/bin/bash

echo "🔍 QUICK CONNECTION CHECK"
echo "========================"

# Check if app is accessible
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:3000/ 2>/dev/null)

if [ "$HTTP_CODE" = "200" ]; then
    echo "✅ Site is UP (HTTP $HTTP_CODE)"
    echo "🌐 Access: http://localhost:3000"
    echo "🔑 Sign-in: http://localhost:3000/auth/signin/"
else
    echo "❌ Site is DOWN (HTTP $HTTP_CODE)"
    echo "🔄 Restarting connection..."
    
    # Kill existing port-forward
    pkill -f "kubectl port-forward.*3000" 2>/dev/null || true
    sleep 2
    
    # Start new port-forward
    kubectl port-forward service/ecommerce-frontend-service 3000:80 -n ecommerce-production &
    sleep 3
    
    # Test again
    NEW_HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:3000/ 2>/dev/null)
    if [ "$NEW_HTTP_CODE" = "200" ]; then
        echo "✅ Connection restored!"
    else
        echo "❌ Still down. Check Minikube: minikube status"
    fi
fi
