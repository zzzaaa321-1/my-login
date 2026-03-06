# My Login - Spring Boot 后端

这是一个基于 Spring Boot 的登录认证后端系统。

## 功能特性

- ✅ 用户登录认证
- ✅ JWT Token 生成和验证
- ✅ 跨域支持 (CORS)
- ✅ 输入验证
- ✅ 模拟用户数据库
- ✅ RESTful API

## 技术栈

- **Spring Boot 3.2.0**
- **Spring Security** - 安全认证
- **JWT (JSON Web Token)** - 令牌认证
- **Lombok** - 代码简化
- **Maven** - 依赖管理

## API 文档

### 认证接口

#### 1. 用户登录
```
POST /api/auth/login
Content-Type: application/json

请求体:
{
  "username": "admin",
  "password": "admin123"
}

响应:
{
  "success": true,
  "message": "登录成功",
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "username": "admin",
  "role": "ADMIN"
}
```

#### 2. 验证 Token
```
POST /api/auth/validate?token={token}

响应: true/false
```

#### 3. 健康检查
```
GET /api/auth/health

响应: "Auth service is running"
```

## 测试用户

系统预置了以下测试用户：

| 用户名 | 密码 | 角色 | 邮箱 |
|--------|------|------|------|
| admin | admin123 | ADMIN | admin@example.com |
| user | user123 | USER | user@example.com |
| test | test123 | USER | test@example.com |

## 快速开始

### 1. 环境要求
- Java 17+
- Maven 3.6+

### 2. 编译项目
```bash
mvn clean compile
```

### 3. 运行项目
```bash
mvn spring-boot:run
```

或者直接运行：
```bash
java -jar target/my-login-backend-1.0.0.jar
```

### 4. 访问应用
- 后端服务: http://localhost:8081
- 健康检查: http://localhost:8081/api/auth/health

## 项目结构

```
src/main/java/com/example/mylogin/
├── MyLoginApplication.java      # 主应用类
├── config/
│   └── SecurityConfig.java     # 安全配置
├── controller/
│   └── AuthController.java     # 认证控制器
├── dto/
│   ├── LoginRequest.java       # 登录请求DTO
│   └── LoginResponse.java      # 登录响应DTO
├── model/
│   └── User.java              # 用户实体
├── service/
│   ├── AuthService.java       # 认证服务
│   └── UserService.java       # 用户服务
└── util/
    └── JwtUtil.java           # JWT工具类
```

## 配置说明

### 应用配置 (application.yml)
- 服务端口: 8081
- JWT 密钥: 可自定义
- JWT 过期时间: 24小时

### 自定义配置
在 `application.yml` 中可以修改：
```yaml
jwt:
  secret: your-secret-key-here
  expiration: 3600000  # 1小时
```

## 开发指南

### 添加新功能
1. 创建实体类在 `model` 包
2. 创建服务类在 `service` 包
3. 创建控制器在 `controller` 包
4. 更新安全配置（如果需要）

### 测试 API
使用 curl 测试：
```bash
# 登录测试
curl -X POST http://localhost:8081/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"admin","password":"admin123"}'

# 健康检查
curl http://localhost:8081/api/auth/health
```

## 部署

### 打包为 JAR
```bash
mvn clean package
```

### Docker 部署
```dockerfile
FROM openjdk:17-jdk-slim
COPY target/my-login-backend-1.0.0.jar app.jar
EXPOSE 8081
ENTRYPOINT ["java", "-jar", "app.jar"]
```

## 故障排除

### 常见问题
1. **端口冲突**: 修改 `application.yml` 中的 `server.port`
2. **CORS 错误**: 检查前端地址是否在允许列表中
3. **JWT 验证失败**: 确保使用相同的密钥

### 日志查看
日志文件位于 `logs/application.log`

## 安全建议

1. **生产环境**:
   - 使用强密码和密钥
   - 启用 HTTPS
   - 限制访问 IP
   - 定期轮换密钥

2. **数据库**:
   - 使用真实数据库替换模拟数据
   - 密码加密存储
   - 添加用户锁定机制

## 许可证

MIT License
