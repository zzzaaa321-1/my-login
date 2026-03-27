# ⚡ 立即启动 My Login 前端

## 最简单的方法

打开终端，依次执行以下命令：

### 1. 进入项目目录
```bash
cd ~/myopencode/projects/my-login/frontend
```

### 2. 安装依赖（第一次需要）
```bash
npm install
```
如果已经安装过，可以跳过这一步。

### 3. 启动服务
```bash
npm run serve
```

### 4. 访问应用
打开浏览器访问：http://localhost:8080

## 测试账户
在登录页面点击测试账户卡片自动填充：
- **管理员**: admin / admin123
- **普通用户**: user / user123  
- **测试用户**: test / test123

## 注意事项

### 前端可以正常启动：
- ✅ 登录界面
- ✅ 表单验证
- ✅ 响应式设计
- ✅ 用户交互
- ✅ 路由跳转

### 后端 API 不可用（因为没有 Java/Maven）：
- ❌ 登录认证会失败
- ❌ 数据无法保存
- ❌ Token 无法生成

## 替代方案

### 方案 A: 安装 Docker（推荐）
```bash
# 安装 Docker Desktop
# 下载: https://www.docker.com/products/docker-desktop

# 启动完整应用
cd ~/myopencode/projects/my-login
docker-compose -f docker/docker-compose.yml up -d
```

### 方案 B: 安装 Java + Maven
```bash
# 使用 Homebrew 安装
brew install openjdk@17 maven

# 验证安装
java --version
mvn --version
```

### 方案 C: 仅查看代码
访问 GitHub 仓库查看完整代码：
https://github.com/zzzaaa321-1/my-login

## 立即行动

复制并执行以下命令：
```bash
cd ~/myopencode/projects/my-login/frontend && npm install && npm run serve
```

然后访问：http://localhost:8080

**现在就开始体验你的 Vue 3 前端吧！** 🎨
