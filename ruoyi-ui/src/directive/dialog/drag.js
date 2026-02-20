/**
* v-dialogDrag dialog drag
* Copyright (c) 2019 ruoyi
*/

export default {
  bind(el, binding, vnode, oldVnode) {
    const value = binding.value
    if (value == false) return
    // Get drag content header
    const dialogHeaderEl = el.querySelector('.el-dialog__header')
    const dragDom = el.querySelector('.el-dialog')
    dialogHeaderEl.style.cursor = 'move'
    // Get original properties ie dom element.currentStyle Firefox Chrome window.getComputedStyle(dom element, null)
    const sty = dragDom.currentStyle || window.getComputedStyle(dragDom, null)
    dragDom.style.position = 'absolute'
    dragDom.style.marginTop = 0
    let width = dragDom.style.width
    if (width.includes('%')) {
      width = +document.body.clientWidth * (+width.replace(/\%/g, '') / 100)
    } else {
      width = +width.replace(/\px/g, '')
    }
    dragDom.style.left = `${(document.body.clientWidth - width) / 2}px`
    // Mouse down event
    dialogHeaderEl.onmousedown = (e) => {
      // Mouse down, calculate the distance from current element to visible area (distance from mouse click position to visible window)
      const disX = e.clientX - dialogHeaderEl.offsetLeft
      const disY = e.clientY - dialogHeaderEl.offsetTop

      // Get value with px, replace with regex match
      let styL, styT

      // Note in IE the first value obtained is component default 50%, after movement assign value as px
      if (sty.left.includes('%')) {
        styL = +document.body.clientWidth * (+sty.left.replace(/\%/g, '') / 100)
        styT = +document.body.clientHeight * (+sty.top.replace(/\%/g, '') / 100)
      } else {
        styL = +sty.left.replace(/\px/g, '')
        styT = +sty.top.replace(/\px/g, '')
      }

      // Mouse drag event
      document.onmousemove = function (e) {
        // Calculate movement distance through event delegation (distance from start to end of drag)
        const l = e.clientX - disX
        const t = e.clientY - disY

        let finallyL = l + styL
        let finallyT = t + styT

        // Move current element
        dragDom.style.left = `${finallyL}px`
        dragDom.style.top = `${finallyT}px`

      }

      document.onmouseup = function (e) {
        document.onmousemove = null
        document.onmouseup = null
      }
    }
  }
}