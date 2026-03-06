package com.example.mylogin.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class LoginResponse {
    private boolean success;
    private String message;
    private String token;
    private String username;
    private String role;
    
    public static LoginResponse success(String token, String username, String role) {
        return new LoginResponse(true, "登录成功", token, username, role);
    }
    
    public static LoginResponse failure(String message) {
        return new LoginResponse(false, message, null, null, null);
    }
}
