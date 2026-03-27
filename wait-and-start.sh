#!/bin/bash
# 等待 Java/Maven 安装完成并启动应用

echo "⏳ 等待 Java 和 Maven 安装完成..."
echo "================================="

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

wait_for_java() {
    echo -n "等待 Java 安装完成..."
    local attempts=0
    local max_attempts=30  # 最多等待5分钟
    
    while [ $attempts -lt $max_attempts ]; do
        if command -v java &> /dev/null && java -version 2>&1 | grep -q "version"; then
            JAVA_VERSION=$(java -version 2>&1 | head -1 | awk -F '"' '{print $2}')
            echo -e "\r${GREEN}✅ Java 已安装: $JAVA_VERSION${NC}          "
            return 0
        fi
        
        attempts=$((attempts + 1))
        echo -n "."
        sleep 10  # 每10秒检查一次
    done
    
    echo -e "\r${RED}❌ Java 安装超时${NC}          "
    return 1
}

wait_for_maven() {
    echo -n "等待 Maven 安装完成..."
    local attempts=0
    local max_attempts=30  # 最多等待5分钟
    
    while [ $attempts -lt $max_attempts ]; do
        if command -v mvn &> /dev/null; then
            MAVEN_VERSION=$(mvn --version 2>&1 | head -1)
            echo -e "\r${GREEN}✅ Maven 已安装: $MAVEN_VERSION${NC}          "
            return 0
        fi
        
        attempts=$((attempts + 1))
        echo -n "."
        sleep 10  # 每10秒检查一次
    done
    
    echo -e "\r${RED}❌ Maven 安装超时${NC}          "
    return 1
}

compile_backend() {
    echo -e "\n${YELLOW}编译 Spring Boot 后端...${NC}"
    
    cd backend
    
    echo "清理项目..."
    mvn clean -q
    
    echo "编译项目..."
    mvn compile -q
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ 后端编译成功${NC}"
        return 0
    else
        echo -e "${RED}❌ 后端编译失败${NC}"
        return 1
    fi
}

start_backend() {
    echo -e "\n${YELLOW}启动 Spring Boot 后端...${NC}"
    
    cd backend
    
    echo "启动服务..."
    # 在后台启动
    mvn spring-boot:run > /tmp/my-login-backend.log 2>&1 &
    BACKEND_PID=$!
    
    echo "进程ID: $BACKEND_PID"
    echo $BACKEND_PID > ../backend.pid
    
    # 等待启动
    echo -n "等待后端启动..."
    local attempts=0
    while [ $attempts -lt 12 ]; do  # 最多等待2分钟
        if curl -s http://localhost:8081/api/auth/health > /dev/null 2>&1; then
            echo -e "\r${GREEN}✅ 后端启动成功${NC}          "
            echo "日志: /tmp/my-login-backend.log"
            return 0
        fi
        
        attempts=$((attempts + 1))
        echo -n "."
        sleep 10
    done
    
    echo -e "\r${RED}❌ 后端启动超时${NC}          "
    echo "查看日志: tail -f /tmp/my-login-backend.log"
    return 1
}

start_frontend() {
    echo -e "\n${YELLOW}启动 Vue 前端...${NC}"
    
    cd frontend
    
    # 检查依赖
    if [ ! -d "node_modules" ]; then
        echo "安装前端依赖..."
        npm install --silent
        if [ $? -ne 0 ]; then
            echo -e "${RED}❌ 前端依赖安装失败${NC}"
            return 1
        fi
        echo -e "${GREEN}✅ 前端依赖安装完成${NC}"
    fi
    
    echo "启动开发服务器..."
    # 在后台启动
    npm run serve > /tmp/my-login-frontend.log 2>&1 &
    FRONTEND_PID=$!
    
    echo "进程ID: $FRONTEND_PID"
    echo $FRONTEND_PID > ../frontend.pid
    
    # 等待启动
    echo -n "等待前端启动..."
    local attempts=0
    while [ $attempts -lt 12 ]; do  # 最多等待2分钟
        if curl -s http://localhost:8080 > /dev/null 2>&1; then
            echo -e "\r${GREEN}✅ 前端启动成功${NC}          "
            echo "日志: /tmp/my-login-frontend.log"
            return 0
        fi
        
        attempts=$((attempts + 1))
        echo -n "."
        sleep 10
    done
    
    echo -e "\r${RED}❌ 前端启动超时${NC}          "
    echo "查看日志: tail -f /tmp/my-login-frontend.log"
    return 1
}

show_info() {
    echo -e "\n${GREEN}🎉 My Login 应用启动完成！${NC}"
    echo "======================================"
    echo ""
    echo "${YELLOW}🌐 访问地址:${NC}"
    echo "前端应用: http://localhost:8080"
    echo "后端API: http://localhost:8081"
    echo "健康检查: http://localhost:8081/api/auth/health"
    echo ""
    echo "${YELLOW}🔐 测试账户:${NC}"
    echo "管理员: admin / admin123"
    echo "普通用户: user / user123"
    echo "测试用户: test / test123"
    echo ""
    echo "${YELLOW}📁 项目信息:${NC}"
    echo "项目目录: ~/myopencode/projects/my-login"
    echo "GitHub仓库: https://github.com/zzzaaa321-1/my-login"
    echo ""
    echo "${YELLOW}📊 日志文件:${NC}"
    echo "后端日志: /tmp/my-login-backend.log"
    echo "前端日志: /tmp/my-login-frontend.log"
    echo "查看日志: tail -f /tmp/my-login-*.log"
    echo ""
    echo "${YELLOW}🛑 停止服务:${NC}"
    echo "停止后端: kill $(cat backend.pid 2>/dev/null) 2>/dev/null"
    echo "停止前端: kill $(cat frontend.pid 2>/dev/null) 2>/dev/null"
    echo ""
    echo "${GREEN}现在打开浏览器访问 http://localhost:8080 开始体验吧！${NC}"
}

# 主流程
echo "${YELLOW}步骤 1: 等待 Java 安装完成${NC}"
if wait_for_java; then
    echo "${YELLOW}步骤 2: 等待 Maven 安装完成${NC}"
    if wait_for_maven; then
        echo "${YELLOW}步骤 3: 编译后端${NC}"
        if compile_backend; then
            echo "${YELLOW}步骤 4: 启动后端${NC}"
            if start_backend; then
                echo "${YELLOW}步骤 5: 启动前端${NC}"
                if start_frontend; then
                    show_info
                    
                    # 保持脚本运行
                    echo ""
                    echo "${YELLOW}按 Ctrl+C 停止所有服务${NC}"
                    
                    # 捕获中断信号
                    trap 'echo "停止服务..."; kill $(cat backend.pid 2>/dev/null) $(cat frontend.pid 2>/dev/null) 2>/dev/null; echo "服务已停止"; exit 0' INT
                    
                    # 等待
                    wait
                else
                    echo "${RED}前端启动失败${NC}"
                fi
            else
                echo "${RED}后端启动失败${NC}"
            fi
        else
            echo "${RED}后端编译失败${NC}"
        fi
    else
        echo "${RED}Maven 安装失败${NC}"
    fi
else
    echo "${RED}Java 安装失败${NC}"
fi

echo ""
echo "${YELLOW}💡 如果安装遇到问题，可以尝试:${NC}"
echo "1. 手动安装: brew install openjdk@17 maven"
echo "2. 使用 Docker: docker-compose -f docker/docker-compose.yml up -d"
echo "3. 仅测试前端: cd frontend && npm run serve"
