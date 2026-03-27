#!/bin/bash
echo "🚀 启动简易模拟后端"
echo "=================="

# 设置Java路径
export PATH="/opt/homebrew/opt/openjdk@17/bin:$PATH"

# 检查Java
if ! command -v java &> /dev/null; then
    echo "❌ Java 未安装"
    exit 1
fi

# 创建临时目录
TEMP_DIR="/tmp/my-login-backend"
mkdir -p $TEMP_DIR

# 创建简单的Java HTTP服务器
cat > $TEMP_DIR/SimpleServer.java << 'EOF'
import com.sun.net.httpserver.HttpServer;
import com.sun.net.httpserver.HttpHandler;
import com.sun.net.httpserver.HttpExchange;
import java.io.IOException;
import java.io.OutputStream;
import java.net.InetSocketAddress;
import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.Map;

public class SimpleServer {
    public static void main(String[] args) throws IOException {
        HttpServer server = HttpServer.create(new InetSocketAddress(8081), 0);
        
        // 健康检查端点
        server.createContext("/api/auth/health", exchange -> {
            String response = "{\"status\": \"UP\", \"message\": \"简易后端服务运行中\"}";
            sendResponse(exchange, 200, response);
        });
        
        // 登录端点
        server.createContext("/api/auth/login", exchange -> {
            if ("POST".equals(exchange.getRequestMethod())) {
                // 模拟登录逻辑
                String response = "{\"success\": true, \"message\": \"登录成功\", \"token\": \"simulated-jwt-token\", \"username\": \"admin\", \"role\": \"ADMIN\"}";
                sendResponse(exchange, 200, response);
            } else {
                sendResponse(exchange, 405, "{\"error\": \"Method not allowed\"}");
            }
        });
        
        // 验证token端点
        server.createContext("/api/auth/validate", exchange -> {
            String response = "{\"valid\": true, \"username\": \"admin\", \"role\": \"ADMIN\"}";
            sendResponse(exchange, 200, response);
        });
        
        server.setExecutor(null);
        server.start();
        System.out.println("✅ 简易后端服务已启动: http://localhost:8081");
        System.out.println("📡 可用端点:");
        System.out.println("  - GET  /api/auth/health   健康检查");
        System.out.println("  - POST /api/auth/login    用户登录");
        System.out.println("  - GET  /api/auth/validate 验证token");
        System.out.println("");
        System.out.println("按 Ctrl+C 停止服务");
    }
    
    private static void sendResponse(HttpExchange exchange, int statusCode, String response) throws IOException {
        exchange.getResponseHeaders().set("Content-Type", "application/json");
        exchange.getResponseHeaders().set("Access-Control-Allow-Origin", "*");
        exchange.getResponseHeaders().set("Access-Control-Allow-Methods", "GET, POST, OPTIONS");
        exchange.getResponseHeaders().set("Access-Control-Allow-Headers", "Content-Type, Authorization");
        
        exchange.sendResponseHeaders(statusCode, response.getBytes().length);
        try (OutputStream os = exchange.getResponseBody()) {
            os.write(response.getBytes(StandardCharsets.UTF_8));
        }
    }
}
EOF

echo "编译Java服务器..."
cd $TEMP_DIR
javac SimpleServer.java

if [ $? -eq 0 ]; then
    echo "✅ 编译成功"
    echo "启动服务器..."
    java SimpleServer
else
    echo "❌ 编译失败"
    echo "尝试使用系统Java..."
    /usr/bin/javac SimpleServer.java 2>/dev/null && {
        echo "✅ 使用系统Java编译成功"
        echo "启动服务器..."
        /usr/bin/java SimpleServer
    } || {
        echo "❌ 所有编译尝试都失败"
        exit 1
    }
fi