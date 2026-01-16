import request from '@/utils/request'

// Login Method
export function login(username, password, code, uuid) {
  const data = {
    username,
    password,
    code,
    uuid
  }
  return request({
    url: '/login',
    headers: {
      isToken: false,
      repeatSubmit: false
    },
    method: 'post',
    data: data
  })
}

// Register Method
export function register(data) {
  return request({
    url: '/register',
    headers: {
      isToken: false
    },
    method: 'post',
    data: data
  })
}

// Get User Details
export function getInfo() {
  return request({
    url: '/getInfo',
    method: 'get'
  })
}

// Logout Method
export function logout() {
  return request({
    url: '/logout',
    method: 'post'
  })
}

// Get Verification Code
export function getCodeImg() {
  return request({
    url: '/captchaImage',
    headers: {
      isToken: false
    },
    method: 'get',
    timeout: 20000
  })
}

//login by phone
export function mobileLogin(phone,code){
  const data={
    phone,
    code
  }
  return request({
    url:'/mobile/login',
    headers:{
      isToken: false,
      repeatSubmit: false
    },
    method:'post',
    data:data
  })
}

//send Sms Verification Code
export function sendSmsCode(phone){
  return request({
    url:'/mobile/sendCode',
    headers:{
      isToken: false
    },
    method:'post',
    data:{phone}
  })
}
