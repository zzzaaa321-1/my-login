# 后端 Dockerfile
FROM openjdk:17-jdk-slim AS builder

# 设置工作目录
WORKDIR /app

# 复制 Maven 配置文件
COPY backend/pom.xml .
COPY backend/src ./src

# 安装 Maven
RUN apt-get update && apt-get install -y maven

# 构建项目
RUN mvn clean package -DskipTests

# 运行阶段
FROM openjdk:17-jre-slim

WORKDIR /app

# 复制构建产物
COPY --from=builder /app/target/my-login-backend-*.jar app.jar

# 创建非root用户
RUN groupadd -r spring && useradd -r -g spring spring
USER spring:spring

# 暴露端口
EXPOSE 8081

# 健康检查
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:8081/api/auth/health || exit 1

# 启动命令
ENTRYPOINT ["java", "-jar", "app.jar"]
