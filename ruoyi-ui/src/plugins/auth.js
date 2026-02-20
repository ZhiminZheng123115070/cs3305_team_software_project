import store from '@/store'

function authPermission(permission) {
  const all_permission = "*:*:*"
  const permissions = store.getters && store.getters.permissions
  if (permission && permission.length > 0) {
    return permissions.some(v => {
      return all_permission === v || v === permission
    })
  } else {
    return false
  }
}

function authRole(role) {
  const super_admin = "admin"
  const roles = store.getters && store.getters.roles
  if (role && role.length > 0) {
    return roles.some(v => {
      return super_admin === v || v === role
    })
  } else {
    return false
  }
}

export default {
  // Verify if user has a certain permission
  hasPermi(permission) {
    return authPermission(permission)
  },
  // Verify if user has any of the specified permissions, only needs to include one
  hasPermiOr(permissions) {
    return permissions.some(item => {
      return authPermission(item)
    })
  },
  // Verify if user has all of the specified permissions, must have all
  hasPermiAnd(permissions) {
    return permissions.every(item => {
      return authPermission(item)
    })
  },
  // Verify if user has a certain role
  hasRole(role) {
    return authRole(role)
  },
  // Verify if user has any of the specified roles, only needs to include one
  hasRoleOr(roles) {
    return roles.some(item => {
      return authRole(item)
    })
  },
  // Verify if user has all of the specified roles, must have all
  hasRoleAnd(roles) {
    return roles.every(item => {
      return authRole(item)
    })
  }
}
