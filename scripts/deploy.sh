#!/bin/bash
# My Login 项目部署脚本

set -e  # 遇到错误退出

echo "🚀 My Login 项目部署脚本"
echo "========================"

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 检查命令是否存在
check_command() {
    if ! command -v $1 &> /dev/null; then
        echo -e "${RED}错误: 未找到 $1 命令${NC}"
        echo "请安装 $1 后重试"
        exit 1
    fi
}

# 显示步骤
step() {
    echo -e "\n${GREEN}步骤 $1: $2${NC}"
}

# 检查环境
step "1" "检查环境依赖"
check_command java
check_command mvn
check_command node
check_command npm

echo "✅ 环境检查通过"
echo "   Java版本: $(java -version 2>&1 | head -1)"
echo "   Maven版本: $(mvn --version | head -1)"
echo "   Node版本: $(node --version)"
echo "   npm版本: $(npm --version)"

# 选择部署模式
echo -e "\n${YELLOW}选择部署模式:${NC}"
echo "1. 开发模式 (前后端分别启动)"
echo "2. 生产模式 (打包部署)"
echo "3. Docker 部署"
echo "4. 仅启动后端"
echo "5. 仅启动前端"

read -p "请选择 (1-5): " mode

case $mode in
    1)
        # 开发模式
        step "2" "启动开发模式"
        
        echo -e "\n${YELLOW}启动后端服务...${NC}"
        cd backend
        mvn clean compile
        echo "✅ 后端编译完成"
        
        # 在后端启动
        (mvn spring-boot:run &)
        BACKEND_PID=$!
        echo "后端进程ID: $BACKEND_PID"
        
        echo -e "\n${YELLOW}启动前端服务...${NC}"
        cd ../frontend
        npm install
        echo "✅ 前端依赖安装完成"
        
        # 在前端启动
        (npm run serve &)
        FRONTEND_PID=$!
        echo "前端进程ID: $FRONTEND_PID"
        
        echo -e "\n${GREEN}🎉 开发环境启动成功！${NC}"
        echo "后端地址: http://localhost:8081"
        echo "前端地址: http://localhost:8080"
        echo "测试账户: admin/admin123"
        
        # 保存进程ID
        echo $BACKEND_PID > ../backend.pid
        echo $FRONTEND_PID > ../frontend.pid
        
        echo -e "\n${YELLOW}按 Ctrl+C 停止服务${NC}"
        
        # 等待用户中断
        trap "kill $BACKEND_PID $FRONTEND_PID 2>/dev/null; echo '服务已停止'; exit 0" INT
        wait
        ;;
        
    2)
        # 生产模式
        step "2" "生产模式打包"
        
        echo -e "\n${YELLOW}打包后端...${NC}"
        cd backend
        mvn clean package -DskipTests
        echo "✅ 后端打包完成: target/my-login-backend-1.0.0.jar"
        
        echo -e "\n${YELLOW}打包前端...${NC}"
        cd ../frontend
        npm install
        npm run build
        echo "✅ 前端打包完成: dist/"
        
        echo -e "\n${GREEN}🎉 生产包构建完成！${NC}"
        echo "后端JAR: backend/target/my-login-backend-1.0.0.jar"
        echo "前端静态文件: frontend/dist/"
        
        # 创建部署目录
        DEPLOY_DIR="../deploy-$(date +%Y%m%d-%H%M%S)"
        mkdir -p $DEPLOY_DIR
        
        cp ../backend/target/my-login-backend-1.0.0.jar $DEPLOY_DIR/
        cp -r dist $DEPLOY_DIR/frontend-dist
        
        echo "部署文件已复制到: $DEPLOY_DIR"
        
        # 生成启动脚本
        cat > $DEPLOY_DIR/start.sh << 'START'
#!/bin/bash
# My Login 生产环境启动脚本

# 启动后端
java -jar my-login-backend-1.0.0.jar &

# 启动前端静态服务器 (如果需要)
# npx serve -s frontend-dist -l 8080 &

echo "My Login 服务已启动"
echo "后端: http://localhost:8081"
echo "前端静态文件: frontend-dist/"
START
        
        chmod +x $DEPLOY_DIR/start.sh
        echo "启动脚本: $DEPLOY_DIR/start.sh"
        ;;
        
    3)
        # Docker 部署
        step "2" "Docker 部署"
        
        if ! command -v docker &> /dev/null; then
            echo -e "${RED}错误: 未找到 Docker 命令${NC}"
            echo "请安装 Docker 后重试"
            exit 1
        fi
        
        echo -e "\n${YELLOW}构建 Docker 镜像...${NC}"
        
        # 创建 Dockerfile
        cat > Dockerfile.backend << 'DOCKER_BACKEND'
FROM openjdk:17-jdk-slim
WORKDIR /app
COPY backend/target/my-login-backend-1.0.0.jar app.jar
EXPOSE 8081
ENTRYPOINT ["java", "-jar", "app.jar"]
DOCKER_BACKEND
        
        cat > Dockerfile.frontend << 'DOCKER_FRONTEND'
FROM nginx:alpine
WORKDIR /usr/share/nginx/html
COPY frontend/dist/ .
COPY nginx.conf /etc/nginx/nginx.conf
EXPOSE 80
DOCKER_FRONTEND
        
        # 构建镜像
        docker build -t my-login-backend -f Dockerfile.backend .
        docker build -t my-login-frontend -f Dockerfile.frontend .
        
        echo -e "\n${GREEN}🎉 Docker 镜像构建完成！${NC}"
        echo "后端镜像: my-login-backend"
        echo "前端镜像: my-login-frontend"
        
        # 生成 docker-compose.yml
        cat > docker-compose.yml << 'COMPOSE'
version: '3.8'
services:
  backend:
    image: my-login-backend
    ports:
      - "8081:8081"
    environment:
      - SPRING_PROFILES_ACTIVE=prod
    restart: unless-stopped
  
  frontend:
    image: my-login-frontend
    ports:
      - "8080:80"
    depends_on:
      - backend
    restart: unless-stopped
COMPOSE
        
        echo "docker-compose.yml 已生成"
        echo "启动命令: docker-compose up -d"
        ;;
        
    4)
        # 仅启动后端
        step "2" "启动后端服务"
        cd backend
        mvn clean compile
        mvn spring-boot:run
        ;;
        
    5)
        # 仅启动前端
        step "2" "启动前端服务"
        cd frontend
        npm install
        npm run serve
        ;;
        
    *)
        echo -e "${RED}无效选择${NC}"
        exit 1
        ;;
esac

echo -e "\n${GREEN}✅ 部署脚本执行完成${NC}"
