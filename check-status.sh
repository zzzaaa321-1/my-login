#!/bin/bash

echo "🔍 检查 My Login 系统状态..."
echo "========================================"

# 检查后端
echo "📦 后端服务 (Spring Boot):"
if curl -s http://localhost:8082/api/auth/health > /dev/null; then
    echo "   ✅ 运行中 - http://localhost:8082"
    echo "   健康检查: $(curl -s http://localhost:8082/api/auth/health)"
else
    echo "   ❌ 未运行"
fi

echo ""
echo "🎨 前端服务 (Vue 3):"
if curl -s -o /dev/null -w "%{http_code}" http://localhost:8083 | grep -q "200"; then
    echo "   ✅ 运行中 - http://localhost:8083"
else
    echo "   ❌ 未运行"
fi

echo ""
echo "🔐 登录功能测试:"
if curl -s http://localhost:8082/api/auth/health > /dev/null; then
    RESPONSE=$(curl -s -X POST http://localhost:8082/api/auth/login \
        -H "Content-Type: application/json" \
        -d '{"username":"admin","password":"admin123"}')
    
    SUCCESS=$(echo $RESPONSE | grep -o '"success":true' || echo "")
    if [ -n "$SUCCESS" ]; then
        USERNAME=$(echo $RESPONSE | grep -o '"username":"[^"]*"' | cut -d'"' -f4)
        ROLE=$(echo $RESPONSE | grep -o '"role":"[^"]*"' | cut -d'"' -f4)
        echo "   ✅ 登录成功 - 用户: $USERNAME, 角色: $ROLE"
    else
        echo "   ❌ 登录失败"
    fi
else
    echo "   ⚠️  后端未运行，无法测试登录"
fi

echo ""
echo "========================================"
echo "📋 快速命令:"
echo "   启动系统: ./start-all.sh"
echo "   测试页面: open test-full-system.html"
echo "   访问前端: open http://localhost:8083"
echo "   访问后端: open http://localhost:8082/api/auth/health"
echo "========================================"