package com.example.mylogin.service;

import com.example.mylogin.dto.LoginRequest;
import com.example.mylogin.dto.LoginResponse;
import com.example.mylogin.model.User;
import com.example.mylogin.util.JwtUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class AuthService {
    
    @Autowired
    private UserService userService;
    
    @Autowired
    private JwtUtil jwtUtil;
    
    public LoginResponse authenticate(LoginRequest loginRequest) {
        String username = loginRequest.getUsername();
        String password = loginRequest.getPassword();
        
        // 验证用户
        if (!userService.validateCredentials(username, password)) {
            return LoginResponse.failure("用户名或密码错误");
        }
        
        // 获取用户信息
        User user = userService.findByUsername(username);
        
        // 生成 JWT token
        String token = jwtUtil.generateToken(username, user.getRole());
        
        return LoginResponse.success(token, username, user.getRole());
    }
    
    public boolean validateToken(String token) {
        try {
            String username = jwtUtil.extractUsername(token);
            return jwtUtil.validateToken(token, username);
        } catch (Exception e) {
            return false;
        }
    }
}
