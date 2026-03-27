import axios from 'axios'

const API_URL = process.env.NODE_ENV === 'production' 
  ? '/api' 
  : 'http://localhost:8082/api'

const api = axios.create({
  baseURL: API_URL,
  headers: {
    'Content-Type': 'application/json'
  }
})

// 请求拦截器 - 添加 token
api.interceptors.request.use(
  config => {
    const token = localStorage.getItem('token')
    if (token) {
      config.headers.Authorization = `Bearer ${token}`
    }
    return config
  },
  error => {
    return Promise.reject(error)
  }
)

// 响应拦截器 - 处理错误
api.interceptors.response.use(
  response => response,
  error => {
    if (error.response?.status === 401) {
      // Token 过期或无效
      localStorage.removeItem('token')
      localStorage.removeItem('user')
      window.location.href = '/'
    }
    return Promise.reject(error)
  }
)

const authService = {
  login(username, password) {
    return api.post('/auth/login', { username, password })
  },
  
  validateToken(token) {
    return api.post('/auth/validate', null, {
      params: { token }
    })
  },
  
  getHealth() {
    return api.get('/auth/health')
  }
}

export default authService
