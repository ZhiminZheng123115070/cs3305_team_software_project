import { Message, MessageBox, Notification, Loading } from 'element-ui'

let loadingInstance

export default {
  // Message prompt
  msg(content) {
    Message.info(content)
  },
  // Error message
  msgError(content) {
    Message.error(content)
  },
  // Success message
  msgSuccess(content) {
    Message.success(content)
  },
  // Warning message
  msgWarning(content) {
    Message.warning(content)
  },
  // Alert prompt
  alert(content) {
    MessageBox.alert(content, "System Prompt")
  },
  // Error alert
  alertError(content) {
    MessageBox.alert(content, "System Prompt", { type: 'error' })
  },
  // Success alert
  alertSuccess(content) {
    MessageBox.alert(content, "System Prompt", { type: 'success' })
  },
  // Warning alert
  alertWarning(content) {
    MessageBox.alert(content, "System Prompt", { type: 'warning' })
  },
  // Notification prompt
  notify(content) {
    Notification.info(content)
  },
  // Error notification
  notifyError(content) {
    Notification.error(content)
  },
  // Success notification
  notifySuccess(content) {
    Notification.success(content)
  },
  // Warning notification
  notifyWarning(content) {
    Notification.warning(content)
  },
  // Confirm dialog
  confirm(content) {
    return MessageBox.confirm(content, "System Prompt", {
      confirmButtonText: 'OK',
      cancelButtonText: 'Cancel',
      type: "warning",
    })
  },
  // Prompt input
  prompt(content) {
    return MessageBox.prompt(content, "System Prompt", {
      confirmButtonText: 'OK',
      cancelButtonText: 'Cancel',
      type: "warning",
    })
  },
  // Open loading overlay
  loading(content) {
    loadingInstance = Loading.service({
      lock: true,
      text: content,
      spinner: "el-icon-loading",
      background: "rgba(0, 0, 0, 0.7)",
    })
  },
  // Close loading overlay
  closeLoading() {
    loadingInstance.close()
  }
}
