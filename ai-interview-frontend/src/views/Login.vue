<template>
  <div class="auth-page">
    <div class="auth-card">
      <h2><svg viewBox="0 0 24 24" style="width:1.15em;height:1.15em;vertical-align:-0.15em" fill="none" stroke="#059669" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="9" cy="5" r="2.4" fill="#059669" stroke="none"/><path d="M10 8 L13 16"/><path d="M13 16 L17 20"/><path d="M13 16 L9 20"/><path d="M11 10 L16 12"/><rect x="15" y="11" width="5.5" height="4" rx="1" fill="#ecfdf5"/></svg> 赴职</h2>
      <p class="subtitle">赴职 · AI求职面试实战平台</p>
      <form @submit.prevent="handleLogin">
        <div class="form-group">
          <label>邮箱</label>
          <input v-model="email" type="email" placeholder="请输入邮箱" required />
        </div>
        <div class="form-group">
          <label>密码</label>
          <input v-model="password" type="password" placeholder="请输入密码" required />
        </div>
        <p v-if="error" class="error">{{ error }}</p>
        <button type="submit" class="btn-glow" :disabled="loading">
          {{ loading ? '登录中...' : '登录' }}
        </button>
      </form>
      <p class="auth-link">还没有账号？<router-link to="/register">立即注册</router-link></p>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '../stores/auth'
import { login } from '../api/auth'
import { getProfile } from '../api/user'

const router = useRouter()
const authStore = useAuthStore()
const email = ref('')
const password = ref('')
const error = ref('')
const loading = ref(false)

async function handleLogin() {
  error.value = ''
  loading.value = true
  try {
    const data = await login(email.value, password.value)
    authStore.setAuth(data)
    // 登录后立刻获取完整用户信息（含头像）
    try {
      const profile = await getProfile()
      authStore.setUserInfo(profile)
    } catch (_) {}
    router.push('/dashboard')
  } catch (e) {
    error.value = e.message
  } finally {
    loading.value = false
  }
}
</script>

<style scoped>
.auth-page {
  display: flex;
  align-items: center;
  justify-content: center;
  min-height: 100vh;
  background: linear-gradient(135deg, #f5f7fa 0%, #e4e8f0 100%);
}
.auth-card {
  width: 400px;
  background: white;
  border-radius: 16px;
  padding: 40px 36px;
  text-align: center;
  box-shadow: 0 4px 24px rgba(0, 0, 0, 0.08);
}
.auth-card h2 {
  font-size: 28px;
  color: #059669;
  margin-bottom: 4px;
}
.subtitle {
  color: #6b7280;
  margin-bottom: 28px;
  font-size: 14px;
}
.form-group {
  margin-bottom: 18px;
  text-align: left;
}
.form-group label {
  display: block;
  margin-bottom: 6px;
  font-size: 14px;
  font-weight: 500;
  color: #374151;
}
.form-group input {
  width: 100%;
  padding: 11px 14px;
  border: 1px solid #e5e7eb;
  border-radius: 10px;
  font-size: 14px;
  outline: none;
  transition: all 0.3s;
  background: #f9fafb;
}
.form-group input:focus {
  border-color: #059669;
  box-shadow: 0 0 0 3px rgba(5, 150, 105, 0.1);
  background: white;
}
.error {
  color: #ef4444;
  font-size: 13px;
  margin-bottom: 12px;
}
.btn-glow {
  width: 100%;
  padding: 12px;
  border: none;
  border-radius: 10px;
  font-size: 15px;
  font-weight: 600;
  color: white;
  background: linear-gradient(135deg, #059669, #10b981, #34d399);
  background-size: 200% 200%;
  animation: gradientShift 3s ease infinite;
  cursor: pointer;
  transition: all 0.3s;
  box-shadow: 0 4px 15px rgba(5, 150, 105, 0.4);
}
.btn-glow:hover {
  transform: translateY(-1px);
  box-shadow: 0 6px 25px rgba(5, 150, 105, 0.5);
}
.btn-glow:disabled {
  opacity: 0.6;
  cursor: not-allowed;
  transform: none;
}
@keyframes gradientShift {
  0% { background-position: 0% 50%; }
  50% { background-position: 100% 50%; }
  100% { background-position: 0% 50%; }
}
.auth-link {
  margin-top: 18px;
  font-size: 14px;
  color: #6b7280;
}
.auth-link a {
  color: #059669;
  font-weight: 500;
}
</style>
