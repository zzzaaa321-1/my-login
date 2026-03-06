# 🚀 My Login 项目推送到 GitHub 指南

## 步骤 1: 在 GitHub 创建仓库

1. **访问**: https://github.com/new
2. **填写信息**:
   - Repository name: `my-login`
   - Description: `Spring Boot + Vue 全栈登录系统`
   - Visibility: `Public` (推荐) 或 `Private`
   - **重要**: 不要初始化 README、.gitignore 或 license
3. **点击**: "Create repository"

## 步骤 2: 获取仓库 URL

创建后你会看到两种 URL:

### SSH (推荐，已配置)
```
git@github.com:zzzaaa321-1/my-login.git
```

### HTTPS
```
https://github.com/zzzaaa321-1/my-login.git
```

## 步骤 3: 推送代码

### 使用 SSH (推荐)
```bash
# 进入项目目录
cd ~/myopencode/projects/my-login

# 添加远程仓库
git remote add origin git@github.com:zzzaaa321-1/my-login.git

# 推送代码
git push -u origin main
```

### 使用 HTTPS
```bash
# 添加远程仓库
git remote add origin https://github.com/zzzaaa321-1/my-login.git

# 推送代码
git push -u origin main
```

## 步骤 4: 验证推送

### 检查远程配置
```bash
git remote -v
```

### 查看提交历史
```bash
git log --oneline --graph --all
```

### 访问 GitHub 仓库
- https://github.com/zzzaaa321-1/my-login

## 步骤 5: 启用 GitHub Pages (可选)

如果你想展示项目文档:

1. **访问**: https://github.com/zzzaaa321-1/my-login/settings/pages
2. **配置**:
   - Source: `Deploy from a branch`
   - Branch: `main`
   - Folder: `/docs` (如果存在) 或 `/` (根目录)
3. **点击**: Save
4. **访问**: https://zzzaaa321-1.github.io/my-login/

## 项目快速启动

### 开发模式
```bash
# 运行部署脚本
./scripts/deploy.sh
# 选择模式 1 (开发模式)
```

### 直接启动
```bash
# 后端
cd backend
mvn spring-boot:run

# 前端 (新终端)
cd frontend
npm install
npm run serve
```

## 访问应用

- **前端**: http://localhost:8080
- **后端**: http://localhost:8081
- **API 文档**: 查看 README.md

## 测试账户

| 用户名 | 密码 | 角色 |
|--------|------|------|
| admin | admin123 | ADMIN |
| user | user123 | USER |
| test | test123 | USER |

## 故障排除

### 问题: 推送被拒绝
```bash
# 强制推送 (谨慎使用)
git push -u origin main --force
```

### 问题: SSH 认证失败
```bash
# 测试 SSH 连接
ssh -T git@github.com

# 如果失败，检查 SSH 密钥
ls -la ~/.ssh/
```

### 问题: 仓库已存在
```bash
# 检查是否已存在
curl -I https://github.com/zzzaaa321-1/my-login

# 如果存在，可以:
# 1. 使用不同名称
# 2. 删除现有仓库 (Settings → Danger Zone)
```

## 项目信息

### 文件统计
- 后端 Java 文件: 9 个
- 前端 Vue 文件: 3 个
- 配置文件: 7 个
- 总提交: 1 次初始提交

### 技术栈
- **后端**: Spring Boot 3.2.0, Spring Security, JWT
- **前端**: Vue 3, Element Plus, Pinia, Vue Router
- **部署**: Docker, Maven, npm

## 下一步

1. **推送代码**到 GitHub
2. **测试应用**功能
3. **分享链接**给他人
4. **继续开发**新功能

现在就去创建仓库并推送代码吧！ 🚀
