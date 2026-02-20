import request from '@/utils/request'

// Get Routes
export const getRouters = () => {
  return request({
    url: '/getRouters',
    method: 'get'
  })
}