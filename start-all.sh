#!/bin/bash

# My Login 全栈系统启动脚本
# 一键启动 Spring Boot 后端 + Vue 3 前端

echo "🚀 启动 My Login 全栈系统..."
echo "========================================"

# 设置 Java 路径
export PATH="/opt/homebrew/opt/openjdk@17/bin:$PATH"

# 检查端口占用
check_port() {
    if curl -s http://localhost:$1 > /dev/null 2>&1; then
        echo "❌ 端口 $1 已被占用"
        return 1
    else
        echo "✅ 端口 $1 可用"
        return 0
    fi
}

echo "🔍 检查端口..."
check_port 8082 || exit 1
check_port 8083 || exit 1

echo ""
echo "📦 启动 Spring Boot 后端..."
cd backend
echo "   编译项目..."
mvn clean compile -DskipTests > /tmp/backend-compile.log 2>&1
if [ $? -eq 0 ]; then
    echo "   ✅ 编译成功"
else
    echo "   ❌ 编译失败，查看日志: /tmp/backend-compile.log"
    exit 1
fi

echo "   启动服务 (端口 8082)..."
mvn spring-boot:run > /tmp/backend-run.log 2>&1 &
BACKEND_PID=$!
sleep 5

# 检查后端是否启动成功
if curl -s http://localhost:8082/api/auth/health > /dev/null; then
    echo "   ✅ 后端启动成功: http://localhost:8082"
else
    echo "   ❌ 后端启动失败，查看日志: /tmp/backend-run.log"
    kill $BACKEND_PID 2>/dev/null
    exit 1
fi

echo ""
echo "🎨 启动 Vue 3 前端..."
cd ../frontend
echo "   安装依赖 (如果需要)..."
npm install --silent > /tmp/frontend-install.log 2>&1

echo "   启动开发服务器 (端口 8083)..."
npm run serve -- --port 8083 > /tmp/frontend-run.log 2>&1 &
FRONTEND_PID=$!
sleep 10

# 检查前端是否启动成功
if curl -s -o /dev/null -w "%{http_code}" http://localhost:8083 | grep -q "200"; then
    echo "   ✅ 前端启动成功: http://localhost:8083"
else
    echo "   ❌ 前端启动失败，查看日志: /tmp/frontend-run.log"
    kill $BACKEND_PID $FRONTEND_PID 2>/dev/null
    exit 1
fi

echo ""
echo "========================================"
echo "🎉 My Login 全栈系统启动完成！"
echo ""
echo "🔗 访问地址:"
echo "   - 前端界面: http://localhost:8083"
echo "   - 后端 API: http://localhost:8082"
echo ""
echo "🔐 测试账户:"
echo "   1. admin / admin123 (管理员)"
echo "   2. user / user123 (普通用户)"
echo "   3. test / test123 (测试用户)"
echo ""
echo "📊 系统测试:"
echo "   打开 test-full-system.html 进行完整测试"
echo ""
echo "🛑 停止服务:"
echo "   按 Ctrl+C 停止所有服务"
echo "   或运行: kill $BACKEND_PID $FRONTEND_PID"
echo "========================================"

# 等待用户中断
trap "echo ''; echo '🛑 停止服务...'; kill $BACKEND_PID $FRONTEND_PID 2>/dev/null; exit 0" INT
wait