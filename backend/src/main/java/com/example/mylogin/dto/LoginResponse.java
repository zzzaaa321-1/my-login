package com.example.mylogin.dto;

public class LoginResponse {
    private boolean success;
    private String message;
    private String token;
    private String username;
    private String role;
    
    // 构造器
    public LoginResponse() {}
    
    public LoginResponse(boolean success, String message, String token, String username, String role) {
        this.success = success;
        this.message = message;
        this.token = token;
        this.username = username;
        this.role = role;
    }
    
    public static LoginResponse success(String token, String username, String role) {
        return new LoginResponse(true, "登录成功", token, username, role);
    }
    
    public static LoginResponse failure(String message) {
        return new LoginResponse(false, message, null, null, null);
    }
    
    // Getter和Setter
    public boolean isSuccess() {
        return success;
    }
    
    public void setSuccess(boolean success) {
        this.success = success;
    }
    
    public String getMessage() {
        return message;
    }
    
    public void setMessage(String message) {
        this.message = message;
    }
    
    public String getToken() {
        return token;
    }
    
    public void setToken(String token) {
        this.token = token;
    }
    
    public String getUsername() {
        return username;
    }
    
    public void setUsername(String username) {
        this.username = username;
    }
    
    public String getRole() {
        return role;
    }
    
    public void setRole(String role) {
        this.role = role;
    }
}
