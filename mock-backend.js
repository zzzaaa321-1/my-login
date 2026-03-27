const http = require('http');
const url = require('url');

const server = http.createServer((req, res) => {
    const parsedUrl = url.parse(req.url, true);
    
    // 设置CORS头
    res.setHeader('Access-Control-Allow-Origin', '*');
    res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS');
    res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization');
    
    // 处理预检请求
    if (req.method === 'OPTIONS') {
        res.writeHead(200);
        res.end();
        return;
    }
    
    // 路由处理
    if (parsedUrl.pathname === '/api/auth/health' && req.method === 'GET') {
        res.writeHead(200, { 'Content-Type': 'application/json' });
        res.end(JSON.stringify({
            status: 'UP',
            message: '模拟后端服务运行中',
            timestamp: new Date().toISOString()
        }));
    } 
    else if (parsedUrl.pathname === '/api/auth/login' && req.method === 'POST') {
        let body = '';
        req.on('data', chunk => {
            body += chunk.toString();
        });
        
        req.on('end', () => {
            try {
                const data = JSON.parse(body);
                const { username, password } = data;
                
                // 模拟用户验证
                const users = {
                    'admin': { password: 'admin123', role: 'ADMIN' },
                    'user': { password: 'user123', role: 'USER' },
                    'test': { password: 'test123', role: 'USER' }
                };
                
                if (users[username] && users[username].password === password) {
                    res.writeHead(200, { 'Content-Type': 'application/json' });
                    res.end(JSON.stringify({
                        success: true,
                        message: '登录成功',
                        token: 'mock-jwt-token-' + Date.now(),
                        username: username,
                        role: users[username].role
                    }));
                } else {
                    res.writeHead(401, { 'Content-Type': 'application/json' });
                    res.end(JSON.stringify({
                        success: false,
                        message: '用户名或密码错误'
                    }));
                }
            } catch (error) {
                res.writeHead(400, { 'Content-Type': 'application/json' });
                res.end(JSON.stringify({
                    success: false,
                    message: '请求格式错误'
                }));
            }
        });
    }
    else if (parsedUrl.pathname === '/api/auth/validate' && req.method === 'GET') {
        res.writeHead(200, { 'Content-Type': 'application/json' });
        res.end(JSON.stringify({
            valid: true,
            username: 'admin',
            role: 'ADMIN'
        }));
    }
    else if (parsedUrl.pathname === '/' && req.method === 'GET') {
        res.writeHead(200, { 'Content-Type': 'application/json' });
        res.end(JSON.stringify({
            name: 'My Login API',
            version: '1.0.0',
            description: '模拟登录后端服务',
            endpoints: [
                { path: '/api/auth/health', method: 'GET', description: '健康检查' },
                { path: '/api/auth/login', method: 'POST', description: '用户登录' },
                { path: '/api/auth/validate', method: 'GET', description: '验证Token' }
            ],
            testAccounts: [
                { username: 'admin', password: 'admin123', role: 'ADMIN' },
                { username: 'user', password: 'user123', role: 'USER' },
                { username: 'test', password: 'test123', role: 'USER' }
            ]
        }));
    }
    else {
        res.writeHead(404, { 'Content-Type': 'application/json; charset=utf-8' });
        res.end(JSON.stringify({
            error: '端点未找到',
            path: parsedUrl.pathname,
            availableEndpoints: [
                '/api/auth/health',
                '/api/auth/login',
                '/api/auth/validate'
            ]
        }));
    }
});

const PORT = 8081;
server.listen(PORT, () => {
    console.log(`🚀 模拟后端服务已启动`);
    console.log(`📡 地址: http://localhost:${PORT}`);
    console.log('');
    console.log(`📋 可用端点:`);
    console.log(`  - GET  /api/auth/health   健康检查`);
    console.log(`  - POST /api/auth/login    用户登录`);
    console.log(`  - GET  /api/auth/validate 验证token`);
    console.log('');
    console.log(`🔐 测试账户:`);
    console.log(`  - admin / admin123 (管理员)`);
    console.log(`  - user  / user123  (普通用户)`);
    console.log(`  - test  / test123  (测试用户)`);
    console.log('');
    console.log(`按 Ctrl+C 停止服务`);
});