<template>
  <div class="login">
    <el-form ref="loginForm" :model="loginForm" :rules="loginRules" class="login-form">
      <h3 class="title">Phone Number Login</h3>
      <el-form-item prop="phone">
        <el-input
          v-model="loginForm.phone"
          type="text"
          auto-complete="off"
          placeholder="Enter phone number"
          maxlength="11"
        >
          <svg-icon slot="prefix" icon-class="user" class="el-input__icon input-icon" />
        </el-input>
      </el-form-item>
      <el-form-item prop="code">
        <el-input
          v-model="loginForm.code"
          auto-complete="off"
          placeholder="Enter verification code"
          style="width: 60%"
          @keyup.enter.native="handleLogin"
        >
          <svg-icon slot="prefix" icon-class="validCode" class="el-input__icon input-icon" />
        </el-input>
        <el-button
          :disabled="codeButtonDisabled"
          :loading="codeLoading"
          @click="sendCode"
          style="width: 38%; float: right;"
          size="medium"
        >
          <span v-if="!codeButtonDisabled && !codeLoading">Get Code</span>
          <span v-else-if="codeLoading">Sending...</span>
          <span v-else>{{ countdown }}s later</span>
        </el-button>
      </el-form-item>
      <el-form-item style="width:100%;">
        <el-button
          :loading="loading"
          size="medium"
          type="primary"
          style="width:100%;"
          @click.native.prevent="handleLogin"
        >
          <span v-if="!loading">Log In</span>
          <span v-else>Logging in...</span>
        </el-button>
        <div style="float: right; margin-top: 10px;">
          <router-link class="link-type" :to="'/login'">Login with Password</router-link>
        </div>
      </el-form-item>
    </el-form>
    <div class="el-login-footer">
      <span>Copyright © 2018-2025 ruoyi.vip All Rights Reserved.</span>
    </div>
  </div>
</template>

<script>
import { mobileLogin, sendSmsCode } from "@/api/login"
import Cookies from "js-cookie"

export default {
  name: "MobileLogin",
  data() {
    // Phone number validation rules
    const validatePhone = (rule, value, callback) => {
      if (!value) {
        callback(new Error("Please enter your phone number"))
      } else if (!/^1[3-9]\d{9}$/.test(value)) {
        callback(new Error("Please enter a valid phone number"))
      } else {
        callback()
      }
    }

    return {
      title: process.env.VUE_APP_TITLE,
      loginForm: {
        phone: "",
        code: ""
      },
      loginRules: {
        phone: [
          { required: true, trigger: "blur", validator: validatePhone }
        ],
        code: [
          { required: true, trigger: "blur", message: "Please enter the verification code" },
          { min: 4, max: 6, message: "Code must be 4-6 digits", trigger: "blur" }
        ]
      },
      loading: false,
      codeLoading: false,
      codeButtonDisabled: false,
      countdown: 60,
      countdownTimer: null,
      redirect: undefined
    }
  },
  watch: {
    $route: {
      handler: function(route) {
        this.redirect = route.query && route.query.redirect
      },
      immediate: true
    }
  },
  beforeDestroy() {
    // Clear the countdown timer before component destruction
    if (this.countdownTimer) {
      clearInterval(this.countdownTimer)
    }
  },
  methods: {
    // Send verification code
    sendCode() {
      this.$refs.loginForm.validateField('phone', (valid) => {
        if (!valid) {
          this.codeLoading = true
          sendSmsCode(this.loginForm.phone).then(() => {
            this.$modal.msgSuccess("Verification code sent successfully")
            this.codeLoading = false
            this.startCountdown()
          }).catch(() => {
            this.codeLoading = false
          })
        }
      })
    },/**
     * Start the countdown timer for resending the verification code
     */
    startCountdown() {
      this.codeButtonDisabled = true
      this.countdown = 60
      this.countdownTimer = setInterval(() => {
        this.countdown--
        if (this.countdown <= 0) {
          this.codeButtonDisabled = false
          clearInterval(this.countdownTimer)
        }
      }, 1000)
    },

    /**
     * Handle the login process using mobile phone and SMS code
     */
    handleLogin() {
      this.$refs.loginForm.validate(valid => {
        if (valid) {
          this.loading = true
          // Dispatch the mobile login action to the store
          this.$store.dispatch("MobileLogin", this.loginForm).then(() => {
            // Redirect to the target path or home page on success
            this.$router.push({ path: this.redirect || "/" }).catch(()=>{})
          }).catch(() => {
            this.loading = false
          })
        }
      })
    }

  }
}
</script>
<style rel="stylesheet/scss" lang="scss">
.login {
  display: flex;
  justify-content: center;
  align-items: center;
  height: 100%;
  background-image: url("../assets/images/login-background.jpg");
  background-size: cover;
}
.title {
  margin: 0px auto 30px auto;
  text-align: center;
  color: #707070;
}

.login-form {
  border-radius: 6px;
  background: #ffffff;
  width: 400px;
  padding: 25px 25px 5px 25px;
  z-index: 1;
  .el-input {
    height: 38px;
    input {
      height: 38px;
    }
  }
  .input-icon {
    height: 39px;
    width: 14px;
    margin-left: 2px;
  }
}
.login-tip {
  font-size: 13px;
  text-align: center;
  color: #bfbfbf;
}
.el-login-footer {
  height: 40px;
  line-height: 40px;
  position: fixed;
  bottom: 0;
  width: 100%;
  text-align: center;
  color: #fff;
  font-family: Arial;
  font-size: 12px;
  letter-spacing: 1px;
}
.link-type {
  color: #409EFF;
  cursor: pointer;
  text-decoration: none;
  &:hover {
    text-decoration: underline;
  }
}
</style>
