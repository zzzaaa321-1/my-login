#!/bin/bash
echo "🔍 My Login 服务诊断工具"
echo "========================"
echo ""

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "📊 检查服务状态..."
echo ""

# 检查前端
echo -n "前端服务 (8080): "
if curl -s -o /dev/null -w "%{http_code}" http://localhost:8080 > /dev/null 2>&1; then
    echo -e "${GREEN}✅ 运行正常${NC}"
else
    echo -e "${RED}❌ 无法访问${NC}"
fi

# 检查后端
echo -n "后端服务 (8081): "
if curl -s -o /dev/null -w "%{http_code}" http://localhost:8081/api/auth/health > /dev/null 2>&1; then
    echo -e "${GREEN}✅ 运行正常${NC}"
else
    echo -e "${RED}❌ 无法访问${NC}"
fi

echo ""
echo "🔧 检查进程..."
echo ""

# 检查进程
FRONTEND_PID=$(ps aux | grep "vue-cli-service serve" | grep -v grep | awk '{print $2}')
BACKEND_PID=$(ps aux | grep "node mock-backend.js" | grep -v grep | awk '{print $2}')

if [ -n "$FRONTEND_PID" ]; then
    echo -e "前端进程ID: ${GREEN}$FRONTEND_PID${NC}"
else
    echo -e "前端进程: ${RED}未找到${NC}"
fi

if [ -n "$BACKEND_PID" ]; then
    echo -e "后端进程ID: ${GREEN}$BACKEND_PID${NC}"
else
    echo -e "后端进程: ${RED}未找到${NC}"
fi

echo ""
echo "🌐 网络检查..."
echo ""

# 检查端口监听
echo "监听端口:"
if command -v lsof &> /dev/null; then
    lsof -i :8080 -i :8081 2>/dev/null || echo "需要安装 lsof: brew install lsof"
elif command -v netstat &> /dev/null; then
    netstat -an | grep -E "8080|8081" || echo "未找到监听信息"
else
    echo "使用 ss 检查:"
    ss -tuln | grep -E "8080|8081" 2>/dev/null || echo "无法检查端口状态"
fi

echo ""
echo "🚀 访问信息:"
echo "-----------"
echo "前端应用: http://localhost:8080"
echo "后端API:  http://localhost:8081"
echo ""
echo "🔐 测试账户:"
echo "-----------"
echo "管理员: admin / admin123"
echo "普通用户: user / user123"
echo "测试用户: test / test123"
echo ""
echo "🛠️ 如果无法访问，尝试:"
echo "-------------------"
echo "1. 使用不同浏览器"
echo "2. 清除浏览器缓存"
echo "3. 禁用防火墙临时测试"
echo "4. 使用 IP 地址: http://127.0.0.1:8080"
echo "5. 检查代理设置"
echo ""
echo "📝 服务日志:"
echo "-----------"
echo "前端日志: 查看终端窗口 (PID: ${FRONTEND_PID:-未运行})"
echo "后端日志: 查看终端窗口 (PID: ${BACKEND_PID:-未运行})"