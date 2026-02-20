import tab from './tab'
import auth from './auth'
import cache from './cache'
import modal from './modal'
import download from './download'

export default {
  install(Vue) {
    // Tab operations
    Vue.prototype.$tab = tab
    // Authentication object
    Vue.prototype.$auth = auth
    // Cache object
    Vue.prototype.$cache = cache
    // Modal object
    Vue.prototype.$modal = modal
    // Download file
    Vue.prototype.$download = download
  }
}
