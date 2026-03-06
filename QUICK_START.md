# ⚡ My Login 快速启动指南

## 🚀 一键启动 (最简单)

```bash
# 进入项目目录
cd ~/myopencode/projects/my-login

# 运行部署脚本
./scripts/deploy.sh

# 选择模式 1 (开发模式)
# 输入: 1
```

## 🔧 分步启动

### 1. 启动后端 (Spring Boot)
```bash
cd backend
mvn spring-boot:run
```
后端将在 http://localhost:8081 启动

### 2. 启动前端 (Vue 3)
```bash
cd frontend
npm install
npm run serve
```
前端将在 http://localhost:8080 启动

## 🌐 访问应用

- **登录页面**: http://localhost:8080
- **后端API**: http://localhost:8081
- **健康检查**: http://localhost:8081/api/auth/health

## 🔐 测试账户

| 用户名 | 密码 | 角色 | 快捷方式 |
|--------|------|------|----------|
| **admin** | admin123 | ADMIN | 点击测试账户卡片 |
| **user** | user123 | USER | 点击测试账户卡片 |
| **test** | test123 | USER | 点击测试账户卡片 |

## 📁 项目结构

```
my-login/
├── backend/     # Spring Boot 后端
├── frontend/    # Vue 3 前端
├── scripts/     # 部署脚本
├── docker/      # Docker 配置
└── docs/        # 项目文档
```

## 🐳 Docker 启动

```bash
# 使用 Docker Compose
cd ~/myopencode/projects/my-login
docker-compose -f docker/docker-compose.yml up -d

# 访问
# 前端: http://localhost:8080
# 后端: http://localhost:8081
```

## 🔗 GitHub 仓库

- **仓库地址**: https://github.com/zzzaaa321-1/my-login
- **克隆项目**:
  ```bash
  git clone git@github.com:zzzaaa321-1/my-login.git
  cd my-login
  ```

## 🛠️ 开发工具

### 推荐工具
1. **后端开发**: IntelliJ IDEA 或 VS Code + Java 扩展
2. **前端开发**: VS Code + Vue 扩展
3. **API测试**: Postman 或 curl

### 常用命令
```bash
# 后端测试
cd backend
mvn test

# 前端构建
cd frontend
npm run build

# API 测试
curl -X POST http://localhost:8081/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"admin","password":"admin123"}'
```

## ⚠️ 常见问题

### 1. 端口冲突
```bash
# 修改后端端口 (application.yml)
server.port: 8082

# 修改前端端口 (vue.config.js)
devServer.port: 8083
```

### 2. 依赖安装失败
```bash
# 清理缓存
cd frontend
rm -rf node_modules package-lock.json
npm cache clean --force
npm install
```

### 3. Maven 构建失败
```bash
cd backend
mvn clean
mvn compile
```

## 📞 支持

- **问题报告**: GitHub Issues
- **文档查看**: README.md
- **详细指南**: 查看项目文档

## 🎯 立即开始

1. **打开终端**
2. **运行**: `cd ~/myopencode/projects/my-login && ./scripts/deploy.sh`
3. **选择模式 1**
4. **打开浏览器访问**: http://localhost:8080

**现在就开始体验你的全栈登录系统吧！** 🚀
