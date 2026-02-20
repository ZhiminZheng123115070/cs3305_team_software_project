<template>
  <div class="upload-file">
    <el-upload
      multiple
      :action="uploadFileUrl"
      :before-upload="handleBeforeUpload"
      :file-list="fileList"
      :data="data"
      :limit="limit"
      :on-error="handleUploadError"
      :on-exceed="handleExceed"
      :on-success="handleUploadSuccess"
      :show-file-list="false"
      :headers="headers"
      class="upload-file-uploader"
      ref="fileUpload"
      v-if="!disabled"
    >
      <!-- Upload Button -->
      <el-button size="mini" type="primary">Select File</el-button>
      <!-- Upload Tip -->
      <div class="el-upload__tip" slot="tip" v-if="showTip">
        Please upload
        <template v-if="fileSize"> files with size not exceeding <b style="color: #f56c6c">{{ fileSize }}MB</b> </template>
        <template v-if="fileType"> in format <b style="color: #f56c6c">{{ fileType.join("/") }}</b> </template>
      </div>
    </el-upload>

    <!-- File List -->
    <transition-group ref="uploadFileList" class="upload-file-list el-upload-list el-upload-list--text" name="el-fade-in-linear" tag="ul">
      <li :key="file.url" class="el-upload-list__item ele-upload-list__item-content" v-for="(file, index) in fileList">
        <el-link :href="`${baseUrl}${file.url}`" :underline="false" target="_blank">
          <span class="el-icon-document"> {{ getFileName(file.name) }} </span>
        </el-link>
        <div class="ele-upload-list__item-content-action">
          <el-link :underline="false" @click="handleDelete(index)" type="danger" v-if="!disabled">Delete</el-link>
        </div>
      </li>
    </transition-group>
  </div>
</template>

<script>
import { getToken } from "@/utils/auth"
import Sortable from 'sortablejs'

export default {
  name: "FileUpload",
  props: {
    // Value
    value: [String, Object, Array],
    // Upload API Address
    action: {
      type: String,
      default: "/common/upload"
    },
    // Parameters Carried in Upload
    data: {
      type: Object
    },
    // Quantity Limit
    limit: {
      type: Number,
      default: 5
    },
    // Size Limit (MB)
    fileSize: {
      type: Number,
      default: 5
    },
    // File Type, e.g. ['png', 'jpg', 'jpeg']
    fileType: {
      type: Array,
      default: () => ["doc", "docx", "xls", "xlsx", "ppt", "pptx", "txt", "pdf"]
    },
    // Whether to Show Tip
    isShowTip: {
      type: Boolean,
      default: true
    },
    // Disable Component (View Files Only)
    disabled: {
      type: Boolean,
      default: false
    },
    // Drag to Sort
    drag: {
      type: Boolean,
      default: true
    }
  },
  data() {
    return {
      number: 0,
      uploadList: [],
      baseUrl: process.env.VUE_APP_BASE_API,
      uploadFileUrl: process.env.VUE_APP_BASE_API + this.action, // Upload File Server Address
      headers: {
        Authorization: "Bearer " + getToken(),
      },
      fileList: []
    }
  },
  mounted() {
    if (this.drag && !this.disabled) {
      this.$nextTick(() => {
        const element = this.$refs.uploadFileList?.$el || this.$refs.uploadFileList
        Sortable.create(element, {
          ghostClass: 'file-upload-darg',
          onEnd: (evt) => {
            const movedItem = this.fileList.splice(evt.oldIndex, 1)[0]
            this.fileList.splice(evt.newIndex, 0, movedItem)
            this.$emit("input", this.listToString(this.fileList))
          }
        })
      })
    }
  },
  watch: {
    value: {
      handler(val) {
        if (val) {
          let temp = 1
          // First Convert Value to Array
          const list = Array.isArray(val) ? val : this.value.split(',')
          // Then Convert Array to Object Array
          this.fileList = list.map(item => {
            if (typeof item === "string") {
              item = { name: item, url: item }
            }
            item.uid = item.uid || new Date().getTime() + temp++
            return item
          })
        } else {
          this.fileList = []
          return []
        }
      },
      deep: true,
      immediate: true
    }
  },
  computed: {
    // Whether to Show Tip
    showTip() {
      return this.isShowTip && (this.fileType || this.fileSize)
    },
  },
  methods: {
    // Validate Format and Size Before Upload
    handleBeforeUpload(file) {
      // Validate File Type
      if (this.fileType) {
        const fileName = file.name.split('.')
        const fileExt = fileName[fileName.length - 1]
        const isTypeOk = this.fileType.indexOf(fileExt) >= 0
        if (!isTypeOk) {
          this.$modal.msgError(`File format is incorrect, please upload ${this.fileType.join("/")} format files!`)
          return false
        }
      }
      // Validate if File Name Contains Special Characters
      if (file.name.includes(',')) {
        this.$modal.msgError('File name is incorrect, cannot contain English comma!')
        return false
      }
      // Validate File Size
      if (this.fileSize) {
        const isLt = file.size / 1024 / 1024 < this.fileSize
        if (!isLt) {
          this.$modal.msgError(`Upload file size cannot exceed ${this.fileSize} MB!`)
          return false
        }
      }
      this.$modal.loading("Uploading file, please wait...")
      this.number++
      return true
    },
    // File Count Exceeded
    handleExceed() {
      this.$modal.msgError(`Upload file count cannot exceed ${this.limit}!`)
    },
    // Upload Failed
    handleUploadError(err) {
      this.$modal.msgError("File upload failed, please try again")
      this.$modal.closeLoading()
    },
    // Upload Success Callback
    handleUploadSuccess(res, file) {
      if (res.code === 200) {
        this.uploadList.push({ name: res.fileName, url: res.fileName })
        this.uploadedSuccessfully()
      } else {
        this.number--
        this.$modal.closeLoading()
        this.$modal.msgError(res.msg)
        this.$refs.fileUpload.handleRemove(file)
        this.uploadedSuccessfully()
      }
    },
    // Delete File
    handleDelete(index) {
      this.fileList.splice(index, 1)
      this.$emit("input", this.listToString(this.fileList))
    },
    // Upload End Processing
    uploadedSuccessfully() {
      if (this.number > 0 && this.uploadList.length === this.number) {
        this.fileList = this.fileList.concat(this.uploadList)
        this.uploadList = []
        this.number = 0
        this.$emit("input", this.listToString(this.fileList))
        this.$modal.closeLoading()
      }
    },
    // Get File Name
    getFileName(name) {
      // If it's a URL, get the last name; if not, return directly
      if (name.lastIndexOf("/") > -1) {
        return name.slice(name.lastIndexOf("/") + 1)
      } else {
        return name
      }
    },
    // Convert Object to Specified String Separator
    listToString(list, separator) {
      let strs = ""
      separator = separator || ","
      for (let i in list) {
        strs += list[i].url + separator
      }
      return strs != '' ? strs.substr(0, strs.length - 1) : ''
    }
  }
}
</script>

<style scoped lang="scss">
.file-upload-darg {
  opacity: 0.5;
  background: #c8ebfb;
}
.upload-file-uploader {
  margin-bottom: 5px;
}
.upload-file-list .el-upload-list__item {
  border: 1px solid #e4e7ed;
  line-height: 2;
  margin-bottom: 10px;
  position: relative;
}
.upload-file-list .ele-upload-list__item-content {
  display: flex;
  justify-content: space-between;
  align-items: center;
  color: inherit;
}
.ele-upload-list__item-content-action .el-link {
  margin-right: 10px;
}
</style>
