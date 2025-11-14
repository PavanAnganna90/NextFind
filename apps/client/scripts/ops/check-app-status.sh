#!/bin/bash

echo "🔍 E-COMMERCE APP STATUS CHECK"
echo "=============================="
echo ""

# Check Kubernetes pods
echo "1. Kubernetes Pods:"
kubectl get pods -n ecommerce-production | grep frontend
echo ""

# Check port-forward
echo "2. Port-Forward Status:"
if ps aux | grep "kubectl port-forward.*3000" | grep -v grep > /dev/null; then
    echo "✅ Port-forward is running"
else
    echo "❌ Port-forward is NOT running"
fi
echo ""

# Check app accessibility
echo "3. App Accessibility:"
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:3000/ 2>/dev/null)
if [ "$HTTP_CODE" = "200" ]; then
    echo "✅ App is accessible (HTTP $HTTP_CODE)"
else
    echo "❌ App is NOT accessible (HTTP $HTTP_CODE)"
fi
echo ""

# Check port-forward log
echo "4. Recent Port-Forward Activity:"
if [ -f "port-forward.log" ]; then
    echo "Last 3 lines from port-forward.log:"
    tail -3 port-forward.log
else
    echo "No port-forward log found"
fi
echo ""

echo "💡 To restart port-forward manually:"
echo "   pkill -f 'kubectl port-forward.*3000'"
echo "   kubectl port-forward service/ecommerce-frontend-service 3000:80 -n ecommerce-production &"
echo ""
echo "💡 To check persistent service:"
echo "   ps aux | grep keep-port-forward"
