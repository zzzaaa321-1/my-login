import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import authService from '@/services/auth.service'

export const useAuthStore = defineStore('auth', () => {
  const token = ref(localStorage.getItem('token') || '')
  const user = ref(JSON.parse(localStorage.getItem('user') || 'null'))
  const isLoading = ref(false)
  const error = ref('')

  const isAuthenticated = computed(() => !!token.value)

  const login = async (username, password) => {
    isLoading.value = true
    error.value = ''
    
    try {
      const response = await authService.login(username, password)
      
      if (response.data.success) {
        token.value = response.data.token
        user.value = {
          username: response.data.username,
          role: response.data.role
        }
        
        // 保存到 localStorage
        localStorage.setItem('token', token.value)
        localStorage.setItem('user', JSON.stringify(user.value))
        
        return { success: true }
      } else {
        error.value = response.data.message
        return { success: false, message: response.data.message }
      }
    } catch (err) {
      error.value = err.response?.data?.message || '登录失败，请检查网络连接'
      return { success: false, message: error.value }
    } finally {
      isLoading.value = false
    }
  }

  const logout = () => {
    token.value = ''
    user.value = null
    localStorage.removeItem('token')
    localStorage.removeItem('user')
  }

  const validateToken = async () => {
    if (!token.value) return false
    
    try {
      const response = await authService.validateToken(token.value)
      return response.data
    } catch {
      logout()
      return false
    }
  }

  return {
    token,
    user,
    isLoading,
    error,
    isAuthenticated,
    login,
    logout,
    validateToken
  }
})
