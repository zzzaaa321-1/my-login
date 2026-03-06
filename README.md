# 🚀 My Login - Spring Boot + Vue 登录系统

一个完整的全栈登录认证系统，包含 Spring Boot 后端和 Vue 3 前端。

## ✨ 功能特性

### 后端 (Spring Boot)
- ✅ 用户登录认证
- ✅ JWT Token 生成和验证
- ✅ Spring Security 安全配置
- ✅ RESTful API 设计
- ✅ 跨域支持 (CORS)
- ✅ 输入验证

### 前端 (Vue 3)
- ✅ 现代化登录界面
- ✅ 响应式设计
- ✅ Token 管理
- ✅ 路由守卫
- ✅ 状态管理 (Pinia)
- ✅ Element Plus UI 组件库

## 🏗️ 技术栈

### 后端技术
- **Spring Boot 3.2.0** - Java 后端框架
- **Spring Security** - 安全认证
- **JWT (JSON Web Token)** - 令牌认证
- **Maven** - 依赖管理
- **Lombok** - 代码简化

### 前端技术
- **Vue 3** - 前端框架
- **Vue Router** - 路由管理
- **Pinia** - 状态管理
- **Element Plus** - UI 组件库
- **Axios** - HTTP 客户端
- **Sass** - CSS 预处理器

## 📁 项目结构

```
my-login/
├── backend/                    # Spring Boot 后端
│   ├── src/main/java/com/example/mylogin/
│   │   ├── config/           # 配置类
│   │   ├── controller/       # 控制器
│   │   ├── dto/             # 数据传输对象
│   │   ├── model/           # 数据模型
│   │   ├── service/         # 业务服务
│   │   └── util/            # 工具类
│   ├── src/main/resources/   # 资源文件
│   └── pom.xml              # Maven 配置
│
├── frontend/                  # Vue 3 前端
│   ├── public/               # 静态资源
│   ├── src/
│   │   ├── assets/          # 样式和图片
│   │   ├── components/      # 组件
│   │   ├── router/          # 路由配置
│   │   ├── services/        # API 服务
│   │   ├── store/           # 状态管理
│   │   ├── utils/           # 工具函数
│   │   ├── views/           # 页面视图
│   │   └── main.js          # 应用入口
│   ├── package.json         # 依赖配置
│   └── vue.config.js        # Vue 配置
│
├── docs/                     # 项目文档
├── docker/                   # Docker 配置
└── scripts/                  # 部署脚本
```

## 🚀 快速开始

### 环境要求
- **Java 17+**
- **Node.js 16+**
- **Maven 3.6+**
- **npm 8+** 或 **yarn**

### 1. 克隆项目
```bash
git clone <repository-url>
cd my-login
```

### 2. 启动后端服务
```bash
cd backend
mvn clean compile
mvn spring-boot:run
```
后端将在 http://localhost:8081 启动

### 3. 启动前端服务
```bash
cd frontend
npm install
npm run serve
```
前端将在 http://localhost:8080 启动

### 4. 访问应用
打开浏览器访问: http://localhost:8080

## 🔐 测试账户

系统预置了以下测试账户：

| 用户名 | 密码 | 角色 | 说明 |
|--------|------|------|------|
| admin | admin123 | ADMIN | 管理员账户 |
| user | user123 | USER | 普通用户 |
| test | test123 | USER | 测试用户 |

## 📡 API 文档

### 认证接口

#### 用户登录
```http
POST /api/auth/login
Content-Type: application/json

{
  "username": "admin",
  "password": "admin123"
}
```

响应:
```json
{
  "success": true,
  "message": "登录成功",
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "username": "admin",
  "role": "ADMIN"
}
```

#### 验证 Token
```http
POST /api/auth/validate?token={token}
```

#### 健康检查
```http
GET /api/auth/health
```

## 🎨 前端功能

### 登录页面
- 现代化登录表单
- 表单验证
- 测试账户快捷填充
- 响应式设计

### 仪表板页面
- 用户信息展示
- 导航菜单
- 功能卡片
- 系统信息展示
- 退出登录功能

## ⚙️ 配置说明

### 后端配置 (application.yml)
```yaml
server:
  port: 8081

jwt:
  secret: your-secret-key-here
  expiration: 86400000  # 24小时
```

### 前端配置 (vue.config.js)
```javascript
devServer: {
  port: 8080,
  proxy: {
    '/api': {
      target: 'http://localhost:8081'
    }
  }
}
```

## 🐳 Docker 部署

### 构建镜像
```bash
# 构建后端镜像
docker build -t my-login-backend -f docker/backend.Dockerfile .

# 构建前端镜像
docker build -t my-login-frontend -f docker/frontend.Dockerfile .
```

### 运行容器
```bash
docker-compose up -d
```

## 🧪 测试

### 后端测试
```bash
cd backend
mvn test
```

### API 测试
```bash
# 使用 curl 测试
curl -X POST http://localhost:8081/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"admin","password":"admin123"}'
```

## 🔧 开发指南

### 添加新功能
1. **后端**: 创建 Controller → Service → Repository
2. **前端**: 创建 View → Component → Service
3. **API**: 更新路由和状态管理

### 代码规范
- 后端: 遵循 Java 编码规范
- 前端: 使用 ESLint + Prettier
- 提交: 使用 Conventional Commits

## 📈 项目状态

### 已完成
- ✅ 基础登录功能
- ✅ JWT 认证
- ✅ 前后端分离架构
- ✅ 响应式界面
- ✅ 测试账户

### 计划中
- 🔄 用户注册功能
- 🔄 密码重置
- 🔄 多语言支持
- 🔄 第三方登录
- 🔄 管理员面板

## 🛡️ 安全考虑

### 生产环境建议
1. **使用 HTTPS**
2. **强密码策略**
3. **定期轮换 JWT 密钥**
4. **启用 CSRF 保护**
5. **限制登录尝试次数**
6. **使用真实数据库**

### 安全配置
- 密码加密存储
- Token 过期机制
- 输入验证和清理
- CORS 配置
- 安全头设置

## 🤝 贡献指南

1. Fork 本仓库
2. 创建功能分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 开启 Pull Request

## 📄 许可证

MIT License - 详见 [LICENSE](LICENSE) 文件

## 📞 支持

- **问题报告**: [GitHub Issues](https://github.com/your-username/my-login/issues)
- **功能请求**: [GitHub Discussions](https://github.com/your-username/my-login/discussions)
- **文档**: 查看 `docs/` 目录

## 🙏 致谢

感谢以下开源项目：
- [Spring Boot](https://spring.io/projects/spring-boot)
- [Vue.js](https://vuejs.org/)
- [Element Plus](https://element-plus.org/)
- [JWT](https://jwt.io/)

---

**Happy Coding!** 🚀
