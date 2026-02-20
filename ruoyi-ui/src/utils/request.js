import axios from 'axios'
import { Notification, MessageBox, Message, Loading } from 'element-ui'
import store from '@/store'
import { getToken } from '@/utils/auth'
import errorCode from '@/utils/errorCode'
import { tansParams, blobValidate } from "@/utils/ruoyi"
import cache from '@/plugins/cache'
import { saveAs } from 'file-saver'

let downloadLoadingInstance
// Whether to Show Re-login
export let isRelogin = { show: false }

axios.defaults.headers['Content-Type'] = 'application/json;charset=utf-8'
// Create Axios Instance
const service = axios.create({
  // axios request configuration has baseURL option, representing the common part of request URL
  baseURL: process.env.VUE_APP_BASE_API,
  // Timeout
  timeout: 10000
})

// Request Interceptor
service.interceptors.request.use(config => {
  // Whether to Set Token
  const isToken = (config.headers || {}).isToken === false
  // Whether to Prevent Duplicate Submission
  const isRepeatSubmit = (config.headers || {}).repeatSubmit === false
  // Interval Time (ms), less than this time is considered duplicate submission
  const interval = (config.headers || {}).interval || 1000
  if (getToken() && !isToken) {
    config.headers['Authorization'] = 'Bearer ' + getToken() // Let each request carry custom token, please modify according to actual situation
  }
  // Map GET Request Params Parameters
  if (config.method === 'get' && config.params) {
    let url = config.url + '?' + tansParams(config.params)
    url = url.slice(0, -1)
    config.params = {}
    config.url = url
  }
  if (!isRepeatSubmit && (config.method === 'post' || config.method === 'put')) {
    const requestObj = {
      url: config.url,
      data: typeof config.data === 'object' ? JSON.stringify(config.data) : config.data,
      time: new Date().getTime()
    }
    const requestSize = Object.keys(JSON.stringify(requestObj)).length // Request Data Size
    const limitSize = 5 * 1024 * 1024 // Limit Data Storage to 5M
    if (requestSize >= limitSize) {
      console.warn(`[${config.url}]: ` + 'Request data size exceeds the allowed 5M limit, cannot perform duplicate submission verification.')
      return config
    }
    const sessionObj = cache.session.getJSON('sessionObj')
    if (sessionObj === undefined || sessionObj === null || sessionObj === '') {
      cache.session.setJSON('sessionObj', requestObj)
    } else {
      const s_url = sessionObj.url                  // Request Address
      const s_data = sessionObj.data                // Request Data
      const s_time = sessionObj.time                // Request Time
      if (s_data === requestObj.data && requestObj.time - s_time < interval && s_url === requestObj.url) {
        const message = 'Data is being processed, please do not submit repeatedly'
        console.warn(`[${s_url}]: ` + message)
        return Promise.reject(new Error(message))
      } else {
        cache.session.setJSON('sessionObj', requestObj)
      }
    }
  }
  return config
}, error => {
    console.log(error)
    Promise.reject(error)
})

// Response Interceptor
service.interceptors.response.use(res => {
    // If status code is not set, default to success status
    const code = res.data.code || 200
    // Get Error Message
    const msg = errorCode[code] || res.data.msg || errorCode['default']
    // Binary data is returned directly
    if (res.request.responseType ===  'blob' || res.request.responseType ===  'arraybuffer') {
      return res.data
    }
    if (code === 401) {
      // Check if current path is login page or login-related API
      const currentPath = window.location.pathname
      const isLoginPage = currentPath === '/login' || currentPath === '/mobile-login' || currentPath === '/register'
      const isLoginApi = res.config && res.config.url && (
        res.config.url.includes('/login') || 
        res.config.url.includes('/mobile/login') || 
        res.config.url.includes('/mobile/sendCode') ||
        res.config.url.includes('/register')
      )
      
      // Don't show login expired message on login pages or login APIs
      if (!isLoginPage && !isLoginApi && !isRelogin.show) {
        isRelogin.show = true
        MessageBox.confirm('Login status has expired, you can stay on this page or log in again', 'System Prompt', { confirmButtonText: 'Re-login', cancelButtonText: 'Cancel', type: 'warning' }).then(() => {
          isRelogin.show = false
          store.dispatch('LogOut').then(() => {
            location.href = '/index'
          })
      }).catch(() => {
        isRelogin.show = false
      })
    }
      return Promise.reject('Invalid session, or session has expired, please log in again.')
    } else if (code === 500) {
      Message({ message: msg, type: 'error' })
      return Promise.reject(new Error(msg))
    } else if (code === 601) {
      Message({ message: msg, type: 'warning' })
      return Promise.reject('error')
    } else if (code !== 200) {
      Notification.error({ title: msg })
      return Promise.reject('error')
    } else {
      return res.data
    }
  },
  error => {
    console.log('err' + error)
    let { message } = error
    if (message == "Network Error") {
      message = "Backend Interface Connection Exception"
    } else if (message.includes("timeout")) {
      message = "System Interface Request Timeout"
    } else if (message.includes("Request failed with status code")) {
      message = "System Interface " + message.slice(-3) + " Exception"
    }
    Message({ message: message, type: 'error', duration: 5 * 1000 })
    return Promise.reject(error)
  }
)

// General Download Method
export function download(url, params, filename, config) {
  downloadLoadingInstance = Loading.service({ text: "Downloading data, please wait", spinner: "el-icon-loading", background: "rgba(0, 0, 0, 0.7)", })
  return service.post(url, params, {
    transformRequest: [(params) => { return tansParams(params) }],
    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
    responseType: 'blob',
    ...config
  }).then(async (data) => {
    const isBlob = blobValidate(data)
    if (isBlob) {
      const blob = new Blob([data])
      saveAs(blob, filename)
    } else {
      const resText = await data.text()
      const rspObj = JSON.parse(resText)
      const errMsg = errorCode[rspObj.code] || rspObj.msg || errorCode['default']
      Message.error(errMsg)
    }
    downloadLoadingInstance.close()
  }).catch((r) => {
    console.error(r)
    Message.error('An error occurred while downloading the file, please contact the administrator!')
    downloadLoadingInstance.close()
  })
}

export default service
