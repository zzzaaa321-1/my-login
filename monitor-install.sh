#!/bin/bash
# Java 和 Maven 安装监控脚本

echo "🔧 Java 和 Maven 安装监控"
echo "========================="

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

check_java() {
    echo -n "检查 Java... "
    if command -v java &> /dev/null && java -version 2>&1 | grep -q "version"; then
        JAVA_VERSION=$(java -version 2>&1 | head -1 | awk -F '"' '{print $2}')
        echo -e "${GREEN}✅ 已安装: $JAVA_VERSION${NC}"
        return 0
    else
        echo -e "${YELLOW}⏳ 未安装或安装中${NC}"
        return 1
    fi
}

check_maven() {
    echo -n "检查 Maven... "
    if command -v mvn &> /dev/null; then
        MAVEN_VERSION=$(mvn --version 2>&1 | head -1)
        echo -e "${GREEN}✅ 已安装: $MAVEN_VERSION${NC}"
        return 0
    else
        echo -e "${YELLOW}⏳ 未安装或安装中${NC}"
        return 1
    fi
}

check_frontend() {
    echo -n "检查前端... "
    if curl -s http://localhost:8080 > /dev/null 2>&1; then
        echo -e "${GREEN}✅ 正在运行${NC}"
        return 0
    else
        echo -e "${YELLOW}⏳ 未运行${NC}"
        return 1
    fi
}

install_java_maven() {
    echo -e "\n${YELLOW}安装 Java 17 和 Maven...${NC}"
    
    # 检查是否使用 Homebrew
    if command -v brew &> /dev/null; then
        echo "使用 Homebrew 安装..."
        
        # 安装 Java 17
        echo "安装 Java 17..."
        brew install openjdk@17
        
        # 设置环境变量
        echo 'export PATH="/opt/homebrew/opt/openjdk@17/bin:$PATH"' >> ~/.zshrc
        source ~/.zshrc
        
        # 安装 Maven
        echo "安装 Maven..."
        brew install maven
        
        echo -e "${GREEN}✅ 安装命令已执行${NC}"
        echo "请等待安装完成..."
    else
        echo -e "${RED}❌ 未找到 Homebrew${NC}"
        echo "请手动安装:"
        echo "1. Java 17: https://www.oracle.com/java/technologies/downloads/#java17"
        echo "2. Maven: https://maven.apache.org/download.cgi"
    fi
}

start_backend() {
    echo -e "\n${YELLOW}启动 Spring Boot 后端...${NC}"
    
    cd backend
    
    # 检查是否需要编译
    if [ ! -f "target/my-login-backend-1.0.0.jar" ]; then
        echo "编译项目..."
        mvn clean compile
        if [ $? -ne 0 ]; then
            echo -e "${RED}❌ 编译失败${NC}"
            return 1
        fi
        echo -e "${GREEN}✅ 编译完成${NC}"
    fi
    
    # 启动后端
    echo "启动服务..."
    mvn spring-boot:run &
    BACKEND_PID=$!
    
    # 等待启动
    sleep 10
    
    # 检查是否启动成功
    if curl -s http://localhost:8081/api/auth/health > /dev/null 2>&1; then
        echo -e "${GREEN}✅ 后端启动成功${NC}"
        echo "进程ID: $BACKEND_PID"
        echo $BACKEND_PID > ../backend.pid
        return 0
    else
        echo -e "${RED}❌ 后端启动失败${NC}"
        return 1
    fi
}

start_frontend() {
    echo -e "\n${YELLOW}启动 Vue 前端...${NC}"
    
    cd frontend
    
    # 检查依赖
    if [ ! -d "node_modules" ]; then
        echo "安装前端依赖..."
        npm install --silent
        if [ $? -ne 0 ]; then
            echo -e "${RED}❌ 依赖安装失败${NC}"
            return 1
        fi
        echo -e "${GREEN}✅ 依赖安装完成${NC}"
    fi
    
    # 启动前端
    echo "启动开发服务器..."
    npm run serve &
    FRONTEND_PID=$!
    
    # 等待启动
    sleep 10
    
    # 检查是否启动成功
    if curl -s http://localhost:8080 > /dev/null 2>&1; then
        echo -e "${GREEN}✅ 前端启动成功${NC}"
        echo "进程ID: $FRONTEND_PID"
        echo $FRONTEND_PID > ../frontend.pid
        return 0
    else
        echo -e "${RED}❌ 前端启动失败${NC}"
        return 1
    fi
}

show_status() {
    echo -e "\n${YELLOW}📊 当前状态:${NC}"
    
    check_java
    check_maven
    check_frontend
    
    echo ""
    echo "项目目录: ~/myopencode/projects/my-login"
    echo "GitHub仓库: https://github.com/zzzaaa321-1/my-login"
}

main_menu() {
    while true; do
        echo -e "\n${YELLOW}📋 主菜单:${NC}"
        echo "1. 检查安装状态"
        echo "2. 安装 Java 和 Maven"
        echo "3. 启动后端服务"
        echo "4. 启动前端服务"
        echo "5. 启动完整应用"
        echo "6. 查看访问信息"
        echo "7. 退出"
        
        read -p "请选择 (1-7): " choice
        
        case $choice in
            1)
                show_status
                ;;
            2)
                install_java_maven
                ;;
            3)
                if check_java && check_maven; then
                    start_backend
                else
                    echo -e "${RED}❌ 请先安装 Java 和 Maven${NC}"
                fi
                ;;
            4)
                start_frontend
                ;;
            5)
                echo -e "\n${YELLOW}启动完整应用...${NC}"
                if check_java && check_maven; then
                    start_backend
                    if [ $? -eq 0 ]; then
                        sleep 5
                        start_frontend
                    fi
                else
                    echo -e "${RED}❌ 请先安装 Java 和 Maven${NC}"
                fi
                ;;
            6)
                echo -e "\n${GREEN}🌐 访问信息:${NC}"
                echo "前端: http://localhost:8080"
                echo "后端: http://localhost:8081"
                echo "健康检查: http://localhost:8081/api/auth/health"
                echo ""
                echo "${YELLOW}测试账户:${NC}"
                echo "管理员: admin / admin123"
                echo "普通用户: user / user123"
                echo "测试用户: test / test123"
                ;;
            7)
                echo "退出"
                exit 0
                ;;
            *)
                echo "无效选择"
                ;;
        esac
        
        echo ""
        read -p "按回车键继续..." -n 1
        echo ""
    done
}

# 显示欢迎信息
echo -e "${GREEN}欢迎使用 My Login 安装监控${NC}"
echo "项目位置: ~/myopencode/projects/my-login"

# 运行主菜单
main_menu
