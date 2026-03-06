<template>
  <div class="dashboard-container">
    <el-container class="dashboard-layout">
      <!-- 侧边栏 -->
      <el-aside width="250px" class="sidebar">
        <div class="sidebar-header">
          <h2><el-icon><Monitor /></el-icon> My Login</h2>
          <p class="user-info">
            <el-avatar :size="40" :src="userAvatar" />
            <span class="user-details">
              <strong>{{ user?.username }}</strong>
              <span class="user-role">{{ user?.role }}</span>
            </span>
          </p>
        </div>

        <el-menu
          :default-active="activeMenu"
          class="sidebar-menu"
          @select="handleMenuSelect"
        >
          <el-menu-item index="dashboard">
            <el-icon><DataLine /></el-icon>
            <span>仪表板</span>
          </el-menu-item>
          <el-menu-item index="profile">
            <el-icon><User /></el-icon>
            <span>个人资料</span>
          </el-menu-item>
          <el-menu-item index="settings">
            <el-icon><Setting /></el-icon>
            <span>系统设置</span>
          </el-menu-item>
          <el-menu-item index="help">
            <el-icon><QuestionFilled /></el-icon>
            <span>帮助中心</span>
          </el-menu-item>
        </el-menu>

        <div class="sidebar-footer">
          <el-button
            type="danger"
            plain
            @click="handleLogout"
            class="logout-button"
          >
            <el-icon><SwitchButton /></el-icon>
            退出登录
          </el-button>
        </div>
      </el-aside>

      <!-- 主内容区 -->
      <el-container class="main-content">
        <el-header class="main-header">
          <div class="header-left">
            <h1>欢迎回来，{{ user?.username }}！</h1>
            <p class="welcome-text">今天是 {{ currentDate }}，祝您有美好的一天！</p>
          </div>
          <div class="header-right">
            <el-badge :value="3" class="notification-badge">
              <el-button circle>
                <el-icon><Bell /></el-icon>
              </el-button>
            </el-badge>
            <el-dropdown @command="handleCommand">
              <span class="user-dropdown">
                {{ user?.username }}
                <el-icon><ArrowDown /></el-icon>
              </span>
              <template #dropdown>
                <el-dropdown-menu>
                  <el-dropdown-item command="profile">
                    <el-icon><User /></el-icon>个人资料
                  </el-dropdown-item>
                  <el-dropdown-item command="settings">
                    <el-icon><Setting /></el-icon>设置
                  </el-dropdown-item>
                  <el-dropdown-item divided command="logout">
                    <el-icon><SwitchButton /></el-icon>退出登录
                  </el-dropdown-item>
                </el-dropdown-menu>
              </template>
            </el-dropdown>
          </div>
        </el-header>

        <el-main class="main-body">
          <!-- 欢迎卡片 -->
          <el-card class="welcome-card">
            <template #header>
              <div class="card-header">
                <h3><el-icon><Star /></el-icon> 登录成功！</h3>
                <el-tag :type="user?.role === 'ADMIN' ? 'danger' : 'success'">
                  {{ user?.role === 'ADMIN' ? '管理员' : '普通用户' }}
                </el-tag>
              </div>
            </template>
            
            <div class="welcome-content">
              <el-result
                icon="success"
                title="认证成功"
                :sub-title="`欢迎 ${user?.username}，您已成功登录系统`"
              >
                <template #extra>
                  <div class="result-extra">
                    <p>您的登录信息：</p>
                    <el-descriptions :column="2" border>
                      <el-descriptions-item label="用户名">
                        {{ user?.username }}
                      </el-descriptions-item>
                      <el-descriptions-item label="角色">
                        <el-tag :type="user?.role === 'ADMIN' ? 'danger' : 'success'">
                          {{ user?.role }}
                        </el-tag>
                      </el-descriptions-item>
                      <el-descriptions-item label="登录时间">
                        {{ loginTime }}
                      </el-descriptions-item>
                      <el-descriptions-item label="Token状态">
                        <el-tag type="success">有效</el-tag>
                      </el-descriptions-item>
                    </el-descriptions>
                  </div>
                </template>
              </el-result>
            </div>
          </el-card>

          <!-- 功能卡片 -->
          <div class="feature-cards">
            <el-card class="feature-card">
              <template #header>
                <div class="card-header">
                  <h4><el-icon><User /></el-icon> 用户管理</h4>
                </div>
              </template>
              <p>管理用户账户和权限</p>
              <el-button type="primary" plain>进入管理</el-button>
            </el-card>

            <el-card class="feature-card">
              <template #header>
                <div class="card-header">
                  <h4><el-icon><Lock /></el-icon> 安全设置</h4>
                </div>
              </template>
              <p>修改密码和安全设置</p>
              <el-button type="warning" plain>安全设置</el-button>
            </el-card>

            <el-card class="feature-card">
              <template #header>
                <div class="card-header">
                  <h4><el-icon><Histogram /></el-icon> 系统统计</h4>
                </div>
              </template>
              <p>查看系统使用统计</p>
              <el-button type="info" plain>查看统计</el-button>
            </el-card>
          </div>

          <!-- 系统信息 -->
          <el-card class="system-info">
            <template #header>
              <h3><el-icon><InfoFilled /></el-icon> 系统信息</h3>
            </template>
            <el-descriptions :column="2">
              <el-descriptions-item label="前端版本">Vue 3.3.0</el-descriptions-item>
              <el-descriptions-item label="后端版本">Spring Boot 3.2.0</el-descriptions-item>
              <el-descriptions-item label="认证方式">JWT Token</el-descriptions-item>
              <el-descriptions-item label="当前环境">开发环境</el-descriptions-item>
              <el-descriptions-item label="登录IP">127.0.0.1</el-descriptions-item>
              <el-descriptions-item label="会话时长">刚刚登录</el-descriptions-item>
            </el-descriptions>
          </el-card>
        </el-main>

        <el-footer class="main-footer">
          <p>My Login 系统 © 2023 | 基于 Vue 3 + Spring Boot 构建</p>
          <p class="footer-links">
            <el-link type="primary">文档</el-link>
            <el-divider direction="vertical" />
            <el-link type="primary">GitHub</el-link>
            <el-divider direction="vertical" />
            <el-link type="primary">问题反馈</el-link>
          </p>
        </el-footer>
      </el-container>
    </el-container>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage, ElMessageBox } from 'element-plus'
import {
  Monitor, DataLine, User, Setting, QuestionFilled,
  SwitchButton, Bell, ArrowDown, Star, Lock,
  Histogram, InfoFilled
} from '@element-plus/icons-vue'
import { useAuthStore } from '@/store/auth'

const router = useRouter()
const authStore = useAuthStore()

const activeMenu = ref('dashboard')
const currentDate = ref('')
const loginTime = ref('')

const user = computed(() => authStore.user)
const userAvatar = computed(() => {
  return `https://api.dicebear.com/7.x/avataaars/svg?seed=${user.value?.username}`
})

onMounted(() => {
  // 设置当前日期
  const now = new Date()
  currentDate.value = now.toLocaleDateString('zh-CN', {
    year: 'numeric',
    month: 'long',
    day: 'numeric',
    weekday: 'long'
  })
  
  // 设置登录时间
  loginTime.value = now.toLocaleTimeString('zh-CN')
  
  // 验证 token
  authStore.validateToken()
})

const handleMenuSelect = (index) => {
  activeMenu.value = index
  ElMessage.info(`切换到 ${index}`)
}

const handleCommand = (command) => {
  if (command === 'logout') {
    handleLogout()
  } else {
    ElMessage.info(`选择: ${command}`)
  }
}

const handleLogout = () => {
  ElMessageBox.confirm(
    '确定要退出登录吗？',
    '确认退出',
    {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning'
    }
  ).then(() => {
    authStore.logout()
    ElMessage.success('已退出登录')
    router.push('/')
  }).catch(() => {
    // 用户取消
  })
}
</script>

<style scoped>
.dashboard-container {
  min-height: 100vh;
  background: #f5f7fa;
}

.dashboard-layout {
  min-height: 100vh;
}

/* 侧边栏样式 */
.sidebar {
  background: linear-gradient(180deg, #2c3e50 0%, #34495e 100%);
  color: white;
  box-shadow: 2px 0 8px rgba(0, 0, 0, 0.1);
}

.sidebar-header {
  padding: 30px 20px;
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
}

.sidebar-header h2 {
  margin: 0 0 20px 0;
  font-size: 20px;
  display: flex;
  align-items: center;
  gap: 10px;
}

.user-info {
  display: flex;
  align-items: center;
  gap: 15px;
}

.user-details {
  display: flex;
  flex-direction: column;
}

.user-role {
  font-size: 12px;
  color: #95a5a6;
  margin-top: 4px;
}

.sidebar-menu {
  border-right: none;
  background: transparent;
  color: white;
  margin-top: 20px;
}

.sidebar-menu :deep(.el-menu-item) {
  color: #ecf0f1;
  height: 50px;
  line-height: 50px;
}

.sidebar-menu :deep(.el-menu-item:hover) {
  background: rgba(255, 255, 255, 0.1);
}

.sidebar-menu :deep(.el-menu-item.is-active) {
  background: #3498db;
  color: white;
}

.sidebar-footer {
  padding: 20px;
  position: absolute;
  bottom: 0;
  width: 100%;
  border-top: 1px solid rgba(255, 255, 255, 0.1);
}

.logout-button {
  width: 100%;
}

/* 主内容区样式 */
.main-content {
  display: flex;
  flex-direction: column;
}

.main-header {
  background: white;
  border-bottom: 1px solid #e4e7ed;
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 30px;
  height: 80px;
}

.header-left h1 {
  margin: 0;
  font-size: 24px;
  color: #2c3e50;
}

.welcome-text {
  margin: 5px 0 0 0;
  color: #7f8c8d;
  font-size: 14px;
}

.header-right {
  display: flex;
  align-items: center;
  gap: 20px;
}

.notification-badge {
  margin-right: 10px;
}

.user-dropdown {
  display: flex;
  align-items: center;
  gap: 8px;
  cursor: pointer;
  color: #2c3e50;
  font-weight: 500;
}

/* 主内容区 */
.main-body {
  padding: 30px;
  background: #f5f7fa;
}

.welcome-card {
  margin-bottom: 30px;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.welcome-content {
  padding: 20px 0;
}

.result-extra {
  text-align: left;
  max-width: 600px;
  margin: 0 auto;
}

.result-extra p {
  margin-bottom: 20px;
  color: #7f8c8d;
}

/* 功能卡片 */
.feature-cards {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: 20px;
  margin-bottom: 30px;
}

.feature-card {
  text-align: center;
  transition: transform 0.3s;
}

.feature-card:hover {
  transform: translateY(-5px);
}

.feature-card h4 {
  margin: 0;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 10px;
}

.feature-card p {
  color: #7f8c8d;
  margin: 15px 0;
}

/* 系统信息 */
.system-info {
  margin-top: 30px;
}

/* 页脚 */
.main-footer {
  background: white;
  border-top: 1px solid #e4e7ed;
  text-align: center;
  padding: 20px;
  color: #7f8c8d;
  font-size: 14px;
}

.footer-links {
  margin-top: 10px;
}

@media (max-width: 768px) {
  .sidebar {
    width: 100% !important;
    position: fixed;
    z-index: 1000;
    height: 100vh;
    transform: translateX(-100%);
    transition: transform 0.3s;
  }
  
  .sidebar.show {
    transform: translateX(0);
  }
  
  .main-header {
    flex-direction: column;
    align-items: flex-start;
    height: auto;
    padding: 20px;
  }
  
  .header-right {
    margin-top: 15px;
    width: 100%;
    justify-content: space-between;
  }
  
  .feature-cards {
    grid-template-columns: 1fr;
  }
}
</style>
