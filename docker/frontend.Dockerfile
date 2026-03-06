# 前端 Dockerfile
FROM node:18-alpine AS builder

WORKDIR /app

# 复制前端文件
COPY frontend/package*.json ./
COPY frontend/ ./

# 安装依赖并构建
RUN npm ci --only=production
RUN npm run build

# 运行阶段
FROM nginx:alpine

# 复制 nginx 配置
COPY docker/nginx.conf /etc/nginx/nginx.conf

# 复制构建产物
COPY --from=builder /app/dist /usr/share/nginx/html

# 暴露端口
EXPOSE 80

# 健康检查
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:80/ || exit 1

# 启动 nginx
CMD ["nginx", "-g", "daemon off;"]
