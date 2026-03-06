package com.example.mylogin.service;

import com.example.mylogin.model.User;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.Map;

@Service
public class UserService {
    
    // 模拟用户数据库
    private final Map<String, User> users = new HashMap<>();
    
    public UserService() {
        // 初始化一些测试用户
        users.put("admin", new User("admin", "admin123", "admin@example.com", "ADMIN"));
        users.put("user", new User("user", "user123", "user@example.com", "USER"));
        users.put("test", new User("test", "test123", "test@example.com", "USER"));
    }
    
    public User findByUsername(String username) {
        return users.get(username);
    }
    
    public boolean validateCredentials(String username, String password) {
        User user = findByUsername(username);
        return user != null && user.getPassword().equals(password);
    }
    
    public User registerUser(String username, String password, String email) {
        if (users.containsKey(username)) {
            return null;
        }
        User user = new User(username, password, email, "USER");
        users.put(username, user);
        return user;
    }
}
