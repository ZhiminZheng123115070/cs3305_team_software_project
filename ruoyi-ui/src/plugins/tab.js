import store from '@/store'
import router from '@/router'

export default {
  // Refresh current tab
  refreshPage(obj) {
    const { path, query, matched } = router.currentRoute
    if (obj === undefined) {
      matched.forEach((m) => {
        if (m.components && m.components.default && m.components.default.name) {
          if (!['Layout', 'ParentView'].includes(m.components.default.name)) {
            obj = { name: m.components.default.name, path: path, query: query }
          }
        }
      })
    }
    return store.dispatch('tagsView/delCachedView', obj).then(() => {
      const { path, query } = obj
      router.replace({
        path: '/redirect' + path,
        query: query
      })
    })
  },
  // Close current tab and open new tab
  closeOpenPage(obj) {
    store.dispatch("tagsView/delView", router.currentRoute)
    if (obj !== undefined) {
      return router.push(obj)
    }
  },
  // Close specified tab
  closePage(obj) {
    if (obj === undefined) {
      return store.dispatch('tagsView/delView', router.currentRoute).then(({ visitedViews }) => {
        const latestView = visitedViews.slice(-1)[0]
        if (latestView) {
          return router.push(latestView.fullPath)
        }
        return router.push('/')
      })
    }
    return store.dispatch('tagsView/delView', obj)
  },
  // Close all tabs
  closeAllPage() {
    return store.dispatch('tagsView/delAllViews')
  },
  // Close left tabs
  closeLeftPage(obj) {
    return store.dispatch('tagsView/delLeftTags', obj || router.currentRoute)
  },
  // Close right tabs
  closeRightPage(obj) {
    return store.dispatch('tagsView/delRightTags', obj || router.currentRoute)
  },
  // Close other tabs
  closeOtherPage(obj) {
    return store.dispatch('tagsView/delOthersViews', obj || router.currentRoute)
  },
  // Add tab
  openPage(title, url, params) {
    const obj = { path: url, meta: { title: title } }
    store.dispatch('tagsView/addView', obj)
    return router.push({ path: url, query: params })
  },
  // Update tab
  updatePage(obj) {
    return store.dispatch('tagsView/updateVisitedView', obj)
  }
}
