<template>
  <div class="login-container">
    <div class="login-card">
      <div class="login-header">
        <h1><el-icon><User /></el-icon> My Login</h1>
        <p class="subtitle">基于 Vue 3 + Spring Boot 的登录系统</p>
      </div>

      <el-form
        ref="loginFormRef"
        :model="loginForm"
        :rules="loginRules"
        class="login-form"
        @submit.prevent="handleLogin"
      >
        <el-form-item prop="username">
          <el-input
            v-model="loginForm.username"
            placeholder="请输入用户名"
            size="large"
            :prefix-icon="User"
            autocomplete="username"
          />
        </el-form-item>

        <el-form-item prop="password">
          <el-input
            v-model="loginForm.password"
            type="password"
            placeholder="请输入密码"
            size="large"
            :prefix-icon="Lock"
            autocomplete="current-password"
            show-password
          />
        </el-form-item>

        <el-form-item>
          <el-button
            type="primary"
            size="large"
            :loading="isLoading"
            @click="handleLogin"
            class="login-button"
          >
            {{ isLoading ? '登录中...' : '登录' }}
          </el-button>
        </el-form-item>

        <div v-if="error" class="error-message">
          <el-alert :title="error" type="error" :closable="false" />
        </div>

        <div class="test-accounts">
          <h3><el-icon><InfoFilled /></el-icon> 测试账户</h3>
          <div class="account-list">
            <div class="account-item">
              <span class="username">admin</span>
              <span class="password">admin123</span>
              <span class="role">管理员</span>
            </div>
            <div class="account-item">
              <span class="username">user</span>
              <span class="password">user123</span>
              <span class="role">普通用户</span>
            </div>
            <div class="account-item">
              <span class="username">test</span>
              <span class="password">test123</span>
              <span class="role">测试用户</span>
            </div>
          </div>
        </div>
      </el-form>

      <div class="login-footer">
        <p>© 2023 My Login 项目 | Vue 3 + Spring Boot</p>
        <p class="tech-stack">
          <el-tag size="small" type="info">Vue 3</el-tag>
          <el-tag size="small" type="info">Element Plus</el-tag>
          <el-tag size="small" type="info">Spring Boot</el-tag>
          <el-tag size="small" type="info">JWT</el-tag>
        </p>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { User, Lock, InfoFilled } from '@element-plus/icons-vue'
import { useAuthStore } from '@/store/auth'

const router = useRouter()
const authStore = useAuthStore()

const loginFormRef = ref()
const isLoading = ref(false)

const loginForm = reactive({
  username: '',
  password: ''
})

const loginRules = {
  username: [
    { required: true, message: '请输入用户名', trigger: 'blur' },
    { min: 3, max: 20, message: '用户名长度在 3 到 20 个字符', trigger: 'blur' }
  ],
  password: [
    { required: true, message: '请输入密码', trigger: 'blur' },
    { min: 6, max: 20, message: '密码长度在 6 到 20 个字符', trigger: 'blur' }
  ]
}

const error = ref('')

const handleLogin = async () => {
  if (!loginFormRef.value) return
  
  try {
    await loginFormRef.value.validate()
    
    isLoading.value = true
    error.value = ''
    
    const result = await authStore.login(loginForm.username, loginForm.password)
    
    if (result.success) {
      ElMessage.success('登录成功！')
      router.push('/dashboard')
    } else {
      error.value = result.message
    }
  } catch (validationError) {
    console.log('表单验证失败:', validationError)
  } finally {
    isLoading.value = false
  }
}

// 自动填充测试账户
const fillTestAccount = (username, password) => {
  loginForm.username = username
  loginForm.password = password
}
</script>

<style scoped>
.login-container {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 20px;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
}

.login-card {
  width: 100%;
  max-width: 420px;
  background: white;
  border-radius: 16px;
  padding: 40px;
  box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
}

.login-header {
  text-align: center;
  margin-bottom: 40px;
}

.login-header h1 {
  color: #2c3e50;
  font-size: 28px;
  margin-bottom: 8px;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 10px;
}

.subtitle {
  color: #7f8c8d;
  font-size: 14px;
  margin: 0;
}

.login-form {
  margin-bottom: 30px;
}

.login-button {
  width: 100%;
  height: 48px;
  font-size: 16px;
  font-weight: 500;
}

.error-message {
  margin-top: 20px;
}

.test-accounts {
  margin-top: 30px;
  padding: 20px;
  background: #f8f9fa;
  border-radius: 8px;
}

.test-accounts h3 {
  color: #2c3e50;
  margin-bottom: 15px;
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 16px;
}

.account-list {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.account-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 10px;
  background: white;
  border-radius: 6px;
  border: 1px solid #e9ecef;
  cursor: pointer;
  transition: all 0.3s;
}

.account-item:hover {
  background: #f8f9fa;
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
}

.username {
  font-weight: 600;
  color: #2c3e50;
  min-width: 80px;
}

.password {
  color: #e74c3c;
  font-family: monospace;
  min-width: 80px;
}

.role {
  color: #3498db;
  font-size: 12px;
  padding: 4px 8px;
  background: #e3f2fd;
  border-radius: 12px;
}

.login-footer {
  text-align: center;
  margin-top: 30px;
  padding-top: 20px;
  border-top: 1px solid #eee;
}

.login-footer p {
  color: #7f8c8d;
  margin: 8px 0;
  font-size: 14px;
}

.tech-stack {
  display: flex;
  justify-content: center;
  gap: 8px;
  flex-wrap: wrap;
}

@media (max-width: 480px) {
  .login-card {
    padding: 30px 20px;
  }
  
  .account-item {
    flex-direction: column;
    align-items: flex-start;
    gap: 8px;
  }
  
  .username, .password, .role {
    min-width: auto;
  }
}
</style>
