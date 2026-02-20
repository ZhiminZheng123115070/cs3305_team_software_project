import request from '@/utils/request'

// Get Server Information
export function getServer() {
  return request({
    url: '/monitor/server',
    method: 'get'
  })
}