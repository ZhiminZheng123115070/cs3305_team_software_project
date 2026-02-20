<template>
  <div>
    <div class="user-info-head" @click="editCropper()"><img v-bind:src="options.img" title="Click to upload avatar" class="img-circle img-lg" /></div>
    <el-dialog :title="title" :visible.sync="open" width="800px" append-to-body @opened="modalOpened"  @close="closeDialog">
      <el-row>
        <el-col :xs="24" :md="12" :style="{height: '350px'}">
          <vue-cropper
            ref="cropper"
            :img="options.img"
            :info="true"
            :autoCrop="options.autoCrop"
            :autoCropWidth="options.autoCropWidth"
            :autoCropHeight="options.autoCropHeight"
            :fixedBox="options.fixedBox"
            :outputType="options.outputType"
            @realTime="realTime"
            v-if="visible"
          />
        </el-col>
        <el-col :xs="24" :md="12" :style="{height: '350px'}">
          <div class="avatar-upload-preview">
            <img :src="previews.url" :style="previews.img" />
          </div>
        </el-col>
      </el-row>
      <br />
      <el-row>
        <el-col :lg="2" :sm="3" :xs="3">
          <el-upload action="#" :http-request="requestUpload" :show-file-list="false" :before-upload="beforeUpload">
            <el-button size="small">
              Select
              <i class="el-icon-upload el-icon--right"></i>
            </el-button>
          </el-upload>
        </el-col>
        <el-col :lg="{span: 1, offset: 2}" :sm="2" :xs="2">
          <el-button icon="el-icon-plus" size="small" @click="changeScale(1)"></el-button>
        </el-col>
        <el-col :lg="{span: 1, offset: 1}" :sm="2" :xs="2">
          <el-button icon="el-icon-minus" size="small" @click="changeScale(-1)"></el-button>
        </el-col>
        <el-col :lg="{span: 1, offset: 1}" :sm="2" :xs="2">
          <el-button icon="el-icon-refresh-left" size="small" @click="rotateLeft()"></el-button>
        </el-col>
        <el-col :lg="{span: 1, offset: 1}" :sm="2" :xs="2">
          <el-button icon="el-icon-refresh-right" size="small" @click="rotateRight()"></el-button>
        </el-col>
        <el-col :lg="{span: 2, offset: 6}" :sm="2" :xs="2">
          <el-button type="primary" size="small" @click="uploadImg()">Submit</el-button>
        </el-col>
      </el-row>
    </el-dialog>
  </div>
</template>

<script>
import store from "@/store"
import { VueCropper } from "vue-cropper"
import { uploadAvatar } from "@/api/system/user"
import { debounce } from '@/utils'

export default {
  components: { VueCropper },
  data() {
    return {
      // Whether to Show Popup
      open: false,
      // Whether to Show Cropper
      visible: false,
      // Popup Title
      title: "Modify Avatar",
      options: {
        img: store.getters.avatar,  // Cropped Image Address
        autoCrop: true,             // Whether to Generate Crop Box by Default
        autoCropWidth: 200,         // Default Crop Box Width
        autoCropHeight: 200,        // Default Crop Box Height
        fixedBox: true,             // Fixed Crop Box Size, Not Allowed to Change
        outputType:"png",           // Default Output Format PNG
        filename: 'avatar'          // File Name
      },
      previews: {},
      resizeHandler: null
    }
  },
  methods: {
    // Edit Avatar
    editCropper() {
      this.open = true
    },
    // Callback When Popup Opens
    modalOpened() {
      this.visible = true
      if (!this.resizeHandler) {
        this.resizeHandler = debounce(() => {
          this.refresh()
        }, 100)
      }
      window.addEventListener("resize", this.resizeHandler)
    },
    // Refresh Component
    refresh() {
      this.$refs.cropper.refresh()
    },
    // Override Default Upload Behavior
    requestUpload() {
    },
    // Rotate Left
    rotateLeft() {
      this.$refs.cropper.rotateLeft()
    },
    // Rotate Right
    rotateRight() {
      this.$refs.cropper.rotateRight()
    },
    // Image Scale
    changeScale(num) {
      num = num || 1
      this.$refs.cropper.changeScale(num)
    },
    // Upload Preprocessing
    beforeUpload(file) {
      if (file.type.indexOf("image/") == -1) {
        this.$modal.msgError("File format error, please upload image type files, such as: JPG, PNG suffix files.")
      } else {
        const reader = new FileReader()
        reader.readAsDataURL(file)
        reader.onload = () => {
          this.options.img = reader.result
          this.options.filename = file.name
        }
      }
    },
    // Upload Image
    uploadImg() {
      this.$refs.cropper.getCropBlob(data => {
        let formData = new FormData()
        formData.append("avatarfile", data, this.options.filename)
        uploadAvatar(formData).then(response => {
          this.open = false
          this.options.img = process.env.VUE_APP_BASE_API + response.imgUrl
          store.commit('SET_AVATAR', this.options.img)
          this.$modal.msgSuccess("Updated successfully")
          this.visible = false
        })
      })
    },
    // Real-time Preview
    realTime(data) {
      this.previews = data
    },
    // Close Dialog
    closeDialog() {
      this.options.img = store.getters.avatar
      this.visible = false
      window.removeEventListener("resize", this.resizeHandler)
    }
  }
}
</script>
<style scoped lang="scss">
.user-info-head {
  position: relative;
  display: inline-block;
  height: 120px;
}

.user-info-head:hover:after {
  content: '+';
  position: absolute;
  left: 0;
  right: 0;
  top: 0;
  bottom: 0;
  color: #eee;
  background: rgba(0, 0, 0, 0.5);
  font-size: 24px;
  font-style: normal;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  cursor: pointer;
  line-height: 110px;
  border-radius: 50%;
}
</style>
