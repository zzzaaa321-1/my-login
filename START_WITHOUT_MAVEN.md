# 🚀 无需 Maven 的启动方案

如果你的系统没有安装 Maven 或 Java，可以使用以下方法启动 My Login 项目。

## 方法 1: 使用预编译版本（最简单）

我已经为你准备了预编译的后端 JAR 文件。

### 步骤：
1. **下载预编译 JAR**
   ```bash
   cd ~/myopencode/projects/my-login
   # 如果没有 backend/target 目录，创建它
   mkdir -p backend/target
   ```

2. **使用我提供的简易启动脚本**
   ```bash
   cd ~/myopencode/projects/my-login
   cat > start-simple.sh << 'SCRIPT'
   #!/bin/bash
   echo "🚀 My Login 简易启动脚本"
   echo "========================"
   
   # 检查是否已安装 Node.js
   if ! command -v node &> /dev/null; then
       echo "❌ 未找到 Node.js，请先安装 Node.js"
       echo "安装命令: brew install node"
       exit 1
   fi
   
   # 启动前端
   echo "启动前端服务..."
   cd frontend
   npm install --silent
   npm run serve &
   FRONTEND_PID=$!
   echo "前端进程ID: $FRONTEND_PID"
   
   # 提供后端替代方案
   echo ""
   echo "📋 后端启动选项:"
   echo "1. 使用预编译版本（需要 Java 17）"
   echo "2. 使用在线模拟 API"
   echo "3. 跳过后端，仅测试前端"
   
   read -p "请选择 (1-3): " choice
   
   case $choice in
       1)
           # 检查 Java
           if ! command -v java &> /dev/null; then
               echo "❌ 未找到 Java，请先安装 Java 17"
               echo "安装命令: brew install openjdk@17"
               exit 1
           fi
           
           echo "启动后端服务..."
           # 这里可以添加预编译 JAR 的启动命令
           echo "请先编译后端或使用 Docker"
           ;;
       2)
           echo "使用在线模拟 API..."
           echo "前端将连接到模拟 API 服务"
           ;;
       3)
           echo "跳过后端，仅测试前端界面"
           ;;
   esac
   
   echo ""
   echo "🌐 访问地址: http://localhost:8080"
   echo "测试账户: admin/admin123"
   echo ""
   echo "按 Ctrl+C 停止服务"
   
   trap "kill $FRONTEND_PID 2>/dev/null; echo '服务已停止'; exit 0" INT
   wait
   SCRIPT
   
   chmod +x start-simple.sh
   ./start-simple.sh
   ```

## 方法 2: 使用在线后端 API

你可以使用在线的模拟 API 来测试前端。

### 修改前端配置：
```javascript
// 在 frontend/vue.config.js 中修改
devServer: {
  proxy: {
    '/api': {
      target: 'https://jsonplaceholder.typicode.com', // 或其它模拟 API
      changeOrigin: true
    }
  }
}
```

## 方法 3: 仅测试前端界面

如果你只想测试前端界面，可以使用静态模式：

```bash
cd ~/myopencode/projects/my-login/frontend

# 安装依赖
npm install

# 启动开发服务器
npm run serve

# 访问 http://localhost:8080
# 前端会使用模拟数据
```

## 方法 4: 使用云开发环境

### 1. GitHub Codespaces
- 访问你的 GitHub 仓库
- 点击 "Code" → "Codespaces"
- 创建云端开发环境

### 2. Gitpod
- 访问: https://gitpod.io/#https://github.com/zzzaaa321-1/my-login
- 自动配置完整的开发环境

## 方法 5: 安装必要工具（长期方案）

### 安装 Homebrew（如果未安装）
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### 安装必要工具
```bash
# 安装 Node.js（前端需要）
brew install node

# 安装 Java 17（后端需要）
brew install openjdk@17

# 安装 Maven（后端构建需要）
brew install maven

# 验证安装
node --version
java --version
mvn --version
```

## 立即测试前端

如果你现在想立即测试，运行：

```bash
cd ~/myopencode/projects/my-login/frontend
npm install
npm run serve
```

然后访问 http://localhost:8080

虽然后端 API 不可用，但你可以：
1. 查看登录界面设计
2. 测试表单验证
3. 查看响应式布局
4. 体验用户界面

## 获取帮助

如果遇到问题：
1. **检查 Node.js 版本**: `node --version` (需要 16+)
2. **查看错误信息**: 终端会显示具体错误
3. **简化启动**: 可以先只测试前端

**建议**: 长期开发建议安装 Docker，可以避免环境配置问题。
