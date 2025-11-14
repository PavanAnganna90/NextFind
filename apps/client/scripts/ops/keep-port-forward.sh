#!/bin/bash

echo "🔄 Starting persistent port-forward service..."

while true; do
    echo "$(date): Checking port-forward status..."
    
    # Check if port-forward is running
    if ! ps aux | grep "kubectl port-forward.*3000" | grep -v grep > /dev/null; then
        echo "$(date): Port-forward not running, restarting..."
        
        # Kill any existing port-forward processes
        pkill -f "kubectl port-forward.*3000" 2>/dev/null || true
        sleep 2
        
        # Start new port-forward
        kubectl port-forward service/ecommerce-frontend-service 3000:80 -n ecommerce-production &
        sleep 3
        
        # Verify it's working
        if curl -s -o /dev/null -w "%{http_code}" http://localhost:3000/ | grep -q "200"; then
            echo "$(date): ✅ Port-forward restarted successfully"
        else
            echo "$(date): ❌ Port-forward failed to start"
        fi
    else
        echo "$(date): ✅ Port-forward is running"
    fi
    
    # Wait 30 seconds before next check
    sleep 30
done
