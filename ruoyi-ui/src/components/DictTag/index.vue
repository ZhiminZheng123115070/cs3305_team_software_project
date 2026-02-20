<template>
  <div>
    <template v-for="(item, index) in options">
      <template v-if="isValueMatch(item.value)">
        <span
          v-if="(item.raw.listClass == 'default' || item.raw.listClass == '') && (item.raw.cssClass == '' || item.raw.cssClass == null)"
          :key="item.value"
          :index="index"
          :class="item.raw.cssClass"
          >{{ item.label + ' ' }}</span
        >
        <el-tag
          v-else
          :disable-transitions="true"
          :key="item.value"
          :index="index"
          :type="item.raw.listClass == 'primary' ? '' : item.raw.listClass"
          :class="item.raw.cssClass"
        >
          {{ item.label + ' ' }}
        </el-tag>
      </template>
    </template>
    <template v-if="unmatch && showValue">
      {{ unmatchArray | handleArray }}
    </template>
  </div>
</template>

<script>
export default {
  name: "DictTag",
  props: {
    options: {
      type: Array,
      default: null,
    },
    value: [Number, String, Array],
    showValue: {
      type: Boolean,
      default: true,
    },
    separator: {
      type: String,
      default: ","
    }
  },
  data() {
    return {
      unmatchArray: [], // Record Unmatched Items
    }
  },
  computed: {
    values() {
      if (this.value === null || typeof this.value === 'undefined' || this.value === '') return []
      if (typeof this.value === 'number' || typeof this.value === 'boolean') return [this.value]
      return Array.isArray(this.value) ? this.value.map(item => '' + item) : String(this.value).split(this.separator)
    },
    unmatch() {
      this.unmatchArray = []
      // No value, do not display
      if (this.value === null || typeof this.value === 'undefined' || this.value === '' || this.options.length === 0) return false
      // Input value is array
      let unmatch = false // Add a flag to determine if there are unmatched items
      this.values.forEach(item => {
        if (!this.options.some(v => v.value == item)) {
          this.unmatchArray.push(item)
          unmatch = true // If there are unmatched items, set flag to true
        }
      })
      return unmatch // Return flag value
    },
  },
  methods: {
    isValueMatch(itemValue) {
      return this.values.some(val => val == itemValue)
    }
  },
  filters: {
    handleArray(array) {
      if (array.length === 0) return ''
      return array.reduce((pre, cur) => {
        return pre + ' ' + cur
      })
    },
  }
}
</script>
<style scoped>
.el-tag + .el-tag {
  margin-left: 10px;
}
</style>
