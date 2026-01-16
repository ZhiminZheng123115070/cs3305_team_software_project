import router from './router'
import store from './store'
import { Message } from 'element-ui'
import NProgress from 'nprogress'
import 'nprogress/nprogress.css'
import { getToken } from '@/utils/auth'
import { isPathMatch } from '@/utils/validate'
import { isRelogin } from '@/utils/request'

NProgress.configure({ showSpinner: false })

const whiteList = ['/login', '/register','/mobile-login']

const isWhiteList = (path) => {
  return whiteList.some(pattern => isPathMatch(pattern, path))
}

router.beforeEach((to, from, next) => {
  NProgress.start()
  if (getToken()) {
    to.meta.title && store.dispatch('settings/setTitle', to.meta.title)
    /* has token*/
    // If user has token and tries to access login pages, redirect to home
    if (to.path === '/login' || to.path === '/mobile-login') {
      next({ path: '/' })
      NProgress.done()
    } else if (isWhiteList(to.path)) {
      // Other whitelist pages (like /register) can be accessed
      next()
    } else {
      if (store.getters.roles.length === 0) {
        isRelogin.show = true
        // Check if current user has finished fetching user_info
        store.dispatch('GetInfo').then(() => {
          isRelogin.show = false
          store.dispatch('GenerateRoutes').then(accessRoutes => {
            // Generate accessible routes based on roles permissions
            router.addRoutes(accessRoutes) // Dynamically add accessible routes
            next({ ...to, replace: true }) // Hack method to ensure addRoutes is completed
          })
        }).catch(err => {
            store.dispatch('LogOut').then(() => {
              Message.error(err)
              next({ path: '/' })
            })
          })
      } else {
        next()
      }
    }
  } else {
    // No token
    if (isWhiteList(to.path)) {
      // In the whitelist, directly enter
      next()
    } else {
      // Redirect to login page by default, but preserve redirect parameter
      // Users can manually navigate to /mobile-login if they prefer
      next(`/login?redirect=${encodeURIComponent(to.fullPath)}`) // Otherwise redirect all to login page
      NProgress.done()
    }
  }
})

router.afterEach(() => {
  NProgress.done()
})
