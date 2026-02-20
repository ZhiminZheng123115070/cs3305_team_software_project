import Vue from 'vue'
import Router from 'vue-router'

Vue.use(Router)

/* Layout */
import Layout from '@/layout'

/**
 * Note: Route Configuration Items
 *
 * hidden: true                     // When set to true, this route will not appear in the sidebar, such as 401, login pages, or some edit pages /edit/1
 * alwaysShow: true                 // When you have more than 1 route declared under children of a route, it will automatically become nested mode--like component pages
 *                                  // When there is only one, that child route will be displayed as the root route in the sidebar--like guide pages
 *                                  // If you want to always show your root route regardless of the number of children declared under the route
 *                                  // You can set alwaysShow: true, so it will ignore the previously defined rules and always show the root route
 * redirect: noRedirect             // When set to noRedirect, this route cannot be clicked in breadcrumb navigation
 * name:'router-name'               // Set the name of the route, must be filled otherwise various problems will occur when using <keep-alive>
 * query: '{"id": 1, "name": "ry"}' // Default parameters passed when accessing the route
 * roles: ['admin', 'common']       // Role permissions to access the route
 * permissions: ['a:a:a', 'b:b:b']  // Menu permissions to access the route
 * meta : {
    noCache: true                   // If set to true, it will not be cached by <keep-alive> (default false)
    title: 'title'                  // Set the name displayed in the sidebar and breadcrumb for this route
    icon: 'svg-name'                // Set the icon for this route, corresponding to path src/assets/icons/svg
    breadcrumb: false               // If set to false, it will not be displayed in the breadcrumb
    activeMenu: '/system/user'      // When the route sets this property, it will highlight the corresponding sidebar.
  }
 */

// Public Routes
export const constantRoutes = [
  {
    path: '/redirect',
    component: Layout,
    hidden: true,
    children: [
      {
        path: '/redirect/:path(.*)',
        component: () => import('@/views/redirect')
      }
    ]
  },
  {
    path: '/login',
    component: () => import('@/views/login'),
    hidden: true
  },
  {
    path: '/register',
    component: () => import('@/views/register'),
    hidden: true
  },
  {
    path: '/mobile-login',
    component: () => import('@/views/mobile-login'),
    hidden: true
  },

  {
    path: '/404',
    component: () => import('@/views/error/404'),
    hidden: true
  },
  {
    path: '/401',
    component: () => import('@/views/error/401'),
    hidden: true
  },
  {
    path: '',
    component: Layout,
    redirect: 'index',
    children: [
      {
        path: 'index',
        component: () => import('@/views/index'),
        name: 'Index',
        meta: { title: 'Home', icon: 'dashboard', affix: true }
      }
    ]
  },
  {
    path: '/user',
    component: Layout,
    hidden: true,
    redirect: 'noredirect',
    children: [
      {
        path: 'profile',
        component: () => import('@/views/system/user/profile/index'),
        name: 'Profile',
        meta: { title: 'Profile', icon: 'user' }
      }
    ]
  }
]

// Dynamic Routes, dynamically loaded based on user permissions
export const dynamicRoutes = [
  {
    path: '/system/user-auth',
    component: Layout,
    hidden: true,
    permissions: ['system:user:edit'],
    children: [
      {
        path: 'role/:userId(\\d+)',
        component: () => import('@/views/system/user/authRole'),
        name: 'AuthRole',
        meta: { title: 'Assign Role', activeMenu: '/system/user' }
      }
    ]
  },
  {
    path: '/system/role-auth',
    component: Layout,
    hidden: true,
    permissions: ['system:role:edit'],
    children: [
      {
        path: 'user/:roleId(\\d+)',
        component: () => import('@/views/system/role/authUser'),
        name: 'AuthUser',
        meta: { title: 'Assign User', activeMenu: '/system/role' }
      }
    ]
  },
  {
    path: '/system/dict-data',
    component: Layout,
    hidden: true,
    permissions: ['system:dict:list'],
    children: [
      {
        path: 'index/:dictId(\\d+)',
        component: () => import('@/views/system/dict/data'),
        name: 'Data',
        meta: { title: 'Dictionary Data', activeMenu: '/system/dict' }
      }
    ]
  },
  {
    path: '/monitor/job-log',
    component: Layout,
    hidden: true,
    permissions: ['monitor:job:list'],
    children: [
      {
        path: 'index/:jobId(\\d+)',
        component: () => import('@/views/monitor/job/log'),
        name: 'JobLog',
        meta: { title: 'Scheduler Log', activeMenu: '/monitor/job' }
      }
    ]
  },
  {
    path: '/tool/gen-edit',
    component: Layout,
    hidden: true,
    permissions: ['tool:gen:edit'],
    children: [
      {
        path: 'index/:tableId(\\d+)',
        component: () => import('@/views/tool/gen/editTable'),
        name: 'GenEdit',
        meta: { title: 'Modify Generation Configuration', activeMenu: '/tool/gen' }
      }
    ]
  }
]

// Prevent multiple route click errors
let routerPush = Router.prototype.push
let routerReplace = Router.prototype.replace
// push
Router.prototype.push = function push(location) {
  return routerPush.call(this, location).catch(err => err)
}
// replace
Router.prototype.replace = function push(location) {
  return routerReplace.call(this, location).catch(err => err)
}

export default new Router({
  mode: 'history', // Remove # from URL
  scrollBehavior: () => ({ y: 0 }),
  routes: constantRoutes
})
