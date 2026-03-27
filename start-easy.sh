#!/bin/bash
# My Login 简易启动脚本 - 无需 Maven

echo "🚀 My Login 简易启动脚本"
echo "========================"
echo "无需 Maven 和 Java，快速启动前端测试"

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 检查 Node.js
check_node() {
    if ! command -v node &> /dev/null; then
        echo -e "${RED}❌ 未找到 Node.js${NC}"
        echo "请先安装 Node.js:"
        echo "  1. 访问 https://nodejs.org/ 下载安装"
        echo "  2. 或使用 Homebrew: brew install node"
        return 1
    fi
    echo -e "${GREEN}✅ Node.js 已安装: $(node --version)${NC}"
    return 0
}

# 检查 npm
check_npm() {
    if ! command -v npm &> /dev/null; then
        echo -e "${RED}❌ 未找到 npm${NC}"
        return 1
    fi
    echo -e "${GREEN}✅ npm 已安装: $(npm --version)${NC}"
    return 0
}

# 启动前端
start_frontend() {
    echo -e "\n${YELLOW}启动前端服务...${NC}"
    
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
    
    # 启动开发服务器
    echo "启动开发服务器..."
    npm run serve &
    FRONTEND_PID=$!
    
    # 等待服务器启动
    sleep 5
    
    # 检查是否启动成功
    if ps -p $FRONTEND_PID > /dev/null; then
        echo -e "${GREEN}✅ 前端服务启动成功${NC}"
        echo "进程ID: $FRONTEND_PID"
        return 0
    else
        echo -e "${RED}❌ 前端服务启动失败${NC}"
        return 1
    fi
}

# 模拟后端响应
setup_mock_backend() {
    echo -e "\n${YELLOW}设置模拟后端响应...${NC}"
    
    # 创建模拟数据文件
    cat > mock-api.html << 'MOCK'
<!DOCTYPE html>
<html>
<head>
    <title>My Login - 模拟 API</title>
    <style>
        body { font-family: Arial, sans-serif; max-width: 800px; margin: 40px auto; padding: 20px; }
        h1 { color: #333; }
        .endpoint { background: #f5f5f5; padding: 15px; margin: 10px 0; border-radius: 5px; }
        code { background: #e8e8e8; padding: 2px 5px; border-radius: 3px; }
    </style>
</head>
<body>
    <h1>My Login - 模拟 API 服务器</h1>
    <p>由于没有安装 Java 和 Maven，后端服务无法启动。</p>
    <p>前端可以正常启动，但 API 调用会失败。</p>
    
    <h2>解决方案：</h2>
    <ol>
        <li><strong>安装 Docker</strong> - 使用容器运行完整应用</li>
        <li><strong>安装 Java + Maven</strong> - 编译运行后端</li>
        <li><strong>仅测试前端</strong> - 查看界面和交互</li>
    </ol>
    
    <h2>模拟 API 端点：</h2>
    <div class="endpoint">
        <h3>POST /api/auth/login</h3>
        <p>请求体：</p>
        <code>{"username": "admin", "password": "admin123"}</code>
        <p>模拟响应：</p>
        <code>{"success": true, "message": "登录成功", "token": "mock-jwt-token", "username": "admin", "role": "ADMIN"}</code>
    </div>
    
    <h2>立即操作：</h2>
    <ul>
        <li><a href="http://localhost:8080" target="_blank">访问前端应用</a></li>
        <li><a href="https://github.com/zzzaaa321-1/my-login" target="_blank">查看 GitHub 仓库</a></li>
    </ul>
</body>
</html>
MOCK
    
    echo -e "${GREEN}✅ 模拟 API 页面已创建${NC}"
    echo "访问: file://$(pwd)/mock-api.html"
}

# 显示帮助信息
show_help() {
    echo -e "\n${YELLOW}📋 启动选项：${NC}"
    echo "1. 仅启动前端（推荐）"
    echo "2. 安装必要工具"
    echo "3. 使用 Docker 启动"
    echo "4. 查看项目文档"
    echo "5. 退出"
}

# 主函数
main() {
    # 检查环境
    if ! check_node; then
        exit 1
    fi
    
    if ! check_npm; then
        exit 1
    fi
    
    echo -e "\n${GREEN}✅ 环境检查通过${NC}"
    
    # 显示选项
    while true; do
        show_help
        read -p "请选择 (1-5): " choice
        
        case $choice in
            1)
                # 启动前端
                if start_frontend; then
                    setup_mock_backend
                    echo -e "\n${GREEN}🎉 前端启动成功！${NC}"
                    echo "访问: http://localhost:8080"
                    echo "测试账户: admin/admin123"
                    echo ""
                    echo "注意：后端 API 不可用，仅测试前端界面"
                    echo "按 Ctrl+C 停止服务"
                    
                    # 保存进程ID
                    echo $FRONTEND_PID > ../frontend.pid
                    
                    # 等待用户中断
                    wait $FRONTEND_PID
                fi
                ;;
                
            2)
                echo -e "\n${YELLOW}安装必要工具：${NC}"
                echo "1. 安装 Docker（推荐）"
                echo "   brew install --cask docker"
                echo ""
                echo "2. 安装 Java 17 + Maven"
                echo "   brew install openjdk@17 maven"
                echo ""
                echo "3. 返回主菜单"
                read -p "选择安装方式: " install_choice
                ;;
                
            3)
                echo -e "\n${YELLOW}使用 Docker 启动：${NC}"
                if command -v docker &> /dev/null; then
                    echo "Docker 已安装，可以运行："
                    echo "  docker-compose -f docker/docker-compose.yml up -d"
                    echo ""
                    read -p "是否立即启动？(y/n): " -n 1 -r
                    echo
                    if [[ $REPLY =~ ^[Yy]$ ]]; then
                        docker-compose -f docker/docker-compose.yml up -d
                        echo "访问: http://localhost:8080"
                    fi
                else
                    echo "Docker 未安装，请先安装 Docker"
                fi
                ;;
                
            4)
                echo -e "\n${YELLOW}项目文档：${NC}"
                echo "1. README.md - 完整项目说明"
                echo "2. QUICK_START.md - 快速启动指南"
                echo "3. PUSH_TO_GITHUB.md - GitHub 推送指南"
                echo "4. START_WITHOUT_MAVEN.md - 无 Maven 启动方案"
                echo ""
                echo "GitHub 仓库: https://github.com/zzzaaa321-1/my-login"
                ;;
                
            5)
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

# 运行主函数
main
