<template>
  <div id="app">
    <nav class="navbar" v-if="authStore.token">
      <div class="nav-content">
        <router-link to="/dashboard" class="nav-logo"><svg viewBox="0 0 24 24" style="width:1.15em;height:1.15em;vertical-align:-0.15em" fill="none" stroke="#059669" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="9" cy="5" r="2.4" fill="#059669" stroke="none"/><path d="M10 8 L13 16"/><path d="M13 16 L17 20"/><path d="M13 16 L9 20"/><path d="M11 10 L16 12"/><rect x="15" y="11" width="5.5" height="4" rx="1" fill="#ecfdf5"/></svg> 赴职</router-link>
        <div class="nav-links">
          <router-link to="/dashboard">面试记录</router-link>
          <router-link to="/resume/upload">上传简历</router-link>
          <router-link to="/position-match"><svg viewBox="0 0 24 24" style="width:1.15em;height:1.15em;vertical-align:-0.15em" fill="none" stroke="#059669" stroke-width="1.6"><circle cx="12" cy="12" r="9"/><circle cx="12" cy="12" r="5.8"/><circle cx="12" cy="12" r="2.8"/><path d="M12 1.5 L12 7 M12 17 L12 22.5 M1.5 12 L7 12 M17 12 L22.5 12" stroke-width="1.3"/><circle cx="12" cy="12" r="1.2" fill="#059669" stroke="none"/></svg> 岗位匹配</router-link>
          <router-link to="/profile" class="nav-user-link">
            <img v-if="authStore.userAvatar && !avatarError" :src="authStore.userAvatar" class="nav-avatar" alt="avatar" @error="avatarError = true" />
            <span v-else class="nav-avatar-placeholder">👤</span>
            <span>{{ authStore.userName || '个人中心' }}</span>
          </router-link>
          <button class="btn-secondary" @click="logout" style="padding:6px 14px;font-size:13px">退出</button>
        </div>
      </div>
    </nav>
    <router-view />
  </div>
</template>

<script setup>
import { onMounted, ref } from 'vue'
import { useAuthStore } from './stores/auth'
import { useRouter } from 'vue-router'
import { getProfile } from './api/user'

const authStore = useAuthStore()
const router = useRouter()
const avatarError = ref(false)

onMounted(async () => {
  if (authStore.token) {
    try {
      const data = await getProfile()
      authStore.setUserInfo(data)
      avatarError.value = false
    } catch (e) {
      // 忽略
    }
  }
})

function logout() {
  authStore.logout()
  router.push('/login')
}
</script>

<style scoped>
.navbar {
  background: white;
  border-bottom: 1px solid #e5e7eb;
  padding: 0 20px;
  position: sticky;
  top: 0;
  z-index: 100;
}
.nav-content {
  max-width: 960px;
  margin: 0 auto;
  display: flex;
  align-items: center;
  justify-content: space-between;
  height: 56px;
}
.nav-logo {
  font-size: 18px;
  font-weight: 700;
  color: #059669;
}
.nav-links {
  display: flex;
  align-items: center;
  gap: 20px;
  font-size: 14px;
}
.nav-links a.router-link-active {
  color: #059669;
  font-weight: 600;
}
.nav-user {
  color: #6b7280;
  font-size: 13px;
}
.nav-user-link {
  color: #6b7280;
  font-size: 13px;
  transition: color 0.2s;
  display: flex;
  align-items: center;
  gap: 6px;
}
.nav-user-link:hover {
  color: #059669;
}
.nav-avatar {
  width: 28px;
  height: 28px;
  border-radius: 50%;
  object-fit: cover;
}
.nav-avatar-placeholder {
  width: 28px;
  height: 28px;
  border-radius: 50%;
  background: #e5e7eb;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 14px;
}
</style>
