<template>
  <div class="app-container">
    <el-row :gutter="20">
      <splitpanes :horizontal="this.$store.getters.device === 'mobile'" class="default-theme">
        <!--Department Data-->
        <pane size="16">
          <el-col>
            <div class="head-container">
              <el-input v-model="deptName" placeholder="Please enter department name" clearable size="small" prefix-icon="el-icon-search" style="margin-bottom: 20px" />
            </div>
            <div class="head-container">
              <el-tree :data="deptOptions" :props="defaultProps" :expand-on-click-node="false" :filter-node-method="filterNode" ref="tree" node-key="id" default-expand-all highlight-current @node-click="handleNodeClick" />
            </div>
          </el-col>
        </pane>
        <!--User Data-->
        <pane size="84">
          <el-col>
            <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="68px">
              <el-form-item label="User Name" prop="userName">
                <el-input v-model="queryParams.userName" placeholder="Please enter user name" clearable style="width: 240px" @keyup.enter.native="handleQuery" />
              </el-form-item>
              <el-form-item label="Phone Number" prop="phonenumber">
                <el-input v-model="queryParams.phonenumber" placeholder="Please enter phone number" clearable style="width: 240px" @keyup.enter.native="handleQuery" />
              </el-form-item>
              <el-form-item label="Status" prop="status">
                <el-select v-model="queryParams.status" placeholder="User Status" clearable style="width: 240px">
                  <el-option v-for="dict in dict.type.sys_normal_disable" :key="dict.value" :label="dict.label" :value="dict.value" />
                </el-select>
              </el-form-item>
              <el-form-item label="Creation Time">
                <el-date-picker v-model="dateRange" style="width: 240px" value-format="yyyy-MM-dd" type="daterange" range-separator="-" start-placeholder="Start Date" end-placeholder="End Date"></el-date-picker>
              </el-form-item>
              <el-form-item>
                <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">Search</el-button>
                <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">Reset</el-button>
              </el-form-item>
            </el-form>

            <el-row :gutter="10" class="mb8">
              <el-col :span="1.5">
                <el-button type="primary" plain icon="el-icon-plus" size="mini" @click="handleAdd" v-hasPermi="['system:user:add']">Add</el-button>
              </el-col>
              <el-col :span="1.5">
                <el-button type="success" plain icon="el-icon-edit" size="mini" :disabled="single" @click="handleUpdate" v-hasPermi="['system:user:edit']">Modify</el-button>
              </el-col>
              <el-col :span="1.5">
                <el-button type="danger" plain icon="el-icon-delete" size="mini" :disabled="multiple" @click="handleDelete" v-hasPermi="['system:user:remove']">Delete</el-button>
              </el-col>
              <el-col :span="1.5">
                <el-button type="info" plain icon="el-icon-upload2" size="mini" @click="handleImport" v-hasPermi="['system:user:import']">Import</el-button>
              </el-col>
              <el-col :span="1.5">
                <el-button type="warning" plain icon="el-icon-download" size="mini" @click="handleExport" v-hasPermi="['system:user:export']">Export</el-button>
              </el-col>
              <right-toolbar :showSearch.sync="showSearch" @queryTable="getList" :columns="columns"></right-toolbar>
            </el-row>

            <el-table v-loading="loading" :data="userList" @selection-change="handleSelectionChange">
              <el-table-column type="selection" width="50" align="center" />
              <el-table-column label="User ID" align="center" key="userId" prop="userId" v-if="columns.userId.visible" />
              <el-table-column label="User Name" align="center" key="userName" prop="userName" v-if="columns.userName.visible" :show-overflow-tooltip="true" />
              <el-table-column label="User Nickname" align="center" key="nickName" prop="nickName" v-if="columns.nickName.visible" :show-overflow-tooltip="true" />
              <el-table-column label="Department" align="center" key="deptName" prop="dept.deptName" v-if="columns.deptName.visible" :show-overflow-tooltip="true" />
              <el-table-column label="Phone Number" align="center" key="phonenumber" prop="phonenumber" v-if="columns.phonenumber.visible" width="120" />
              <el-table-column label="Status" align="center" key="status" v-if="columns.status.visible">
                <template slot-scope="scope">
                  <el-switch v-model="scope.row.status" active-value="0" inactive-value="1" @change="handleStatusChange(scope.row)"></el-switch>
                </template>
              </el-table-column>
              <el-table-column label="Creation Time" align="center" prop="createTime" v-if="columns.createTime.visible" width="160">
                <template slot-scope="scope">
                  <span>{{ parseTime(scope.row.createTime) }}</span>
                </template>
              </el-table-column>
              <el-table-column label="Operation" align="center" width="160" class-name="small-padding fixed-width">
                <template slot-scope="scope" v-if="scope.row.userId !== 1">
                  <el-button size="mini" type="text" icon="el-icon-edit" @click="handleUpdate(scope.row)" v-hasPermi="['system:user:edit']">Modify</el-button>
                  <el-button size="mini" type="text" icon="el-icon-delete" @click="handleDelete(scope.row)" v-hasPermi="['system:user:remove']">Delete</el-button>
                  <el-dropdown size="mini" @command="(command) => handleCommand(command, scope.row)" v-hasPermi="['system:user:resetPwd', 'system:user:edit']">
                    <el-button size="mini" type="text" icon="el-icon-d-arrow-right">More</el-button>
                    <el-dropdown-menu slot="dropdown">
                      <el-dropdown-item command="handleResetPwd" icon="el-icon-key" v-hasPermi="['system:user:resetPwd']">Reset Password</el-dropdown-item>
                      <el-dropdown-item command="handleAuthRole" icon="el-icon-circle-check" v-hasPermi="['system:user:edit']">Assign Role</el-dropdown-item>
                    </el-dropdown-menu>
                  </el-dropdown>
                </template>
              </el-table-column>
            </el-table>

            <pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />
          </el-col>
        </pane>
      </splitpanes>
    </el-row>

    <!-- Add or Modify User Configuration Dialog -->
    <el-dialog :title="title" :visible.sync="open" width="600px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="80px">
        <el-row>
          <el-col :span="12">
            <el-form-item label="User Nickname" prop="nickName">
              <el-input v-model="form.nickName" placeholder="Please enter user nickname" maxlength="30" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="Department" prop="deptId">
              <treeselect v-model="form.deptId" :options="enabledDeptOptions" :show-count="true" placeholder="Please select department" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="Phone Number" prop="phonenumber">
              <el-input v-model="form.phonenumber" placeholder="Please enter phone number" maxlength="11" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="Email" prop="email">
              <el-input v-model="form.email" placeholder="Please enter email" maxlength="50" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item v-if="form.userId == undefined" label="User Name" prop="userName">
              <el-input v-model="form.userName" placeholder="Please enter user name" maxlength="30" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item v-if="form.userId == undefined" label="User Password" prop="password">
              <el-input v-model="form.password" placeholder="Please enter user password" type="password" maxlength="20" show-password />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="User Gender">
              <el-select v-model="form.sex" placeholder="Please select gender">
                <el-option v-for="dict in dict.type.sys_user_sex" :key="dict.value" :label="dict.label" :value="dict.value"></el-option>
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="Status">
              <el-radio-group v-model="form.status">
                <el-radio v-for="dict in dict.type.sys_normal_disable" :key="dict.value" :label="dict.value">{{ dict.label }}</el-radio>
              </el-radio-group>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="Post">
              <el-select v-model="form.postIds" multiple placeholder="Please select post">
                <el-option v-for="item in postOptions" :key="item.postId" :label="item.postName" :value="item.postId" :disabled="item.status == 1" ></el-option>
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="Role">
              <el-select v-model="form.roleIds" multiple placeholder="Please select role">
                <el-option v-for="item in roleOptions" :key="item.roleId" :label="item.roleName" :value="item.roleId" :disabled="item.status == 1"></el-option>
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="24">
            <el-form-item label="Remark">
              <el-input v-model="form.remark" type="textarea" placeholder="Please enter content"></el-input>
            </el-form-item>
          </el-col>
        </el-row>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitForm">Confirm</el-button>
        <el-button @click="cancel">Cancel</el-button>
      </div>
    </el-dialog>

    <!-- User Import Dialog -->
    <el-dialog :title="upload.title" :visible.sync="upload.open" width="400px" append-to-body>
      <el-upload ref="upload" :limit="1" accept=".xlsx, .xls" :headers="upload.headers" :action="upload.url + '?updateSupport=' + upload.updateSupport" :disabled="upload.isUploading" :on-progress="handleFileUploadProgress" :on-success="handleFileSuccess" :auto-upload="false" drag>
        <i class="el-icon-upload"></i>
        <div class="el-upload__text">Drag file here, or<em>click to upload</em></div>
        <div class="el-upload__tip text-center" slot="tip">
          <div class="el-upload__tip" slot="tip">
            <el-checkbox v-model="upload.updateSupport" />Whether to update existing user data
          </div>
          <span>Only xls and xlsx format files are allowed to be imported.</span>
          <el-link type="primary" :underline="false" style="font-size: 12px; vertical-align: baseline" @click="importTemplate">Download Template</el-link>
        </div>
      </el-upload>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitFileForm">Confirm</el-button>
        <el-button @click="upload.open = false">Cancel</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { listUser, getUser, delUser, addUser, updateUser, resetUserPwd, changeUserStatus, deptTreeSelect } from "@/api/system/user"
import { getToken } from "@/utils/auth"
import Treeselect from "@riophae/vue-treeselect"
import "@riophae/vue-treeselect/dist/vue-treeselect.css"
import { Splitpanes, Pane } from "splitpanes"
import "splitpanes/dist/splitpanes.css"

export default {
  name: "User",
  dicts: ['sys_normal_disable', 'sys_user_sex'],
  components: { Treeselect, Splitpanes, Pane },
  data() {
    return {
      // Overlay
      loading: true,
      // Selected Array
      ids: [],
      // Not Single Disabled
      single: true,
      // Not Multiple Disabled
      multiple: true,
      // Show Search Conditions
      showSearch: true,
      // Total Count
      total: 0,
      // User Table Data
      userList: null,
      // Popup Title
      title: "",
      // All Department Tree Options
      deptOptions: undefined,
      // Filter Out Disabled Department Tree Options
      enabledDeptOptions: undefined,
      // Whether to Show Popup
      open: false,
      // Department Name
      deptName: undefined,
      // Default Password
      initPassword: undefined,
      // Date Range
      dateRange: [],
      // Post Options
      postOptions: [],
      // Role Options
      roleOptions: [],
      // Form Parameters
      form: {},
      defaultProps: {
        children: "children",
        label: "label"
      },
      // User Import Parameters
      upload: {
        // Whether to Show Popup (User Import)
        open: false,
        // Popup Title (User Import)
        title: "",
        // Whether Upload is Disabled
        isUploading: false,
        // Whether to Update Existing User Data
        updateSupport: 0,
        // Set Upload Request Headers
        headers: { Authorization: "Bearer " + getToken() },
        // Upload Address
        url: process.env.VUE_APP_BASE_API + "/system/user/importData"
      },
      // Query Parameters
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        userName: undefined,
        phonenumber: undefined,
        status: undefined,
        deptId: undefined
      },
      // Column Information
      columns: {
        userId: { label: 'User ID', visible: true },
        userName: { label: 'User Name', visible: true },
        nickName: { label: 'User Nickname', visible: true },
        deptName: { label: 'Department', visible: true },
        phonenumber: { label: 'Phone Number', visible: true },
        status: { label: 'Status', visible: true },
        createTime: { label: 'Creation Time', visible: true }
      },
      // Form Validation
      rules: {
        userName: [
          { required: true, message: "User name cannot be empty", trigger: "blur" },
          { min: 2, max: 20, message: 'User name length must be between 2 and 20 characters', trigger: 'blur' }
        ],
        nickName: [
          { required: true, message: "User nickname cannot be empty", trigger: "blur" }
        ],
        password: [
          { required: true, message: "User password cannot be empty", trigger: "blur" },
          { min: 5, max: 20, message: 'User password length must be between 5 and 20 characters', trigger: 'blur' },
          { pattern: /^[^<>"'|\\]+$/, message: "Cannot contain illegal characters: < > \" ' \\\ |", trigger: "blur" }
        ],
        email: [
          {
            type: "email",
            message: "Please enter a valid email address",
            trigger: ["blur", "change"]
          }
        ],
        phonenumber: [
          {
            pattern: /^1[3|4|5|6|7|8|9][0-9]\d{8}$/,
            message: "Please enter a valid phone number",
            trigger: "blur"
          }
        ]
      }
    }
  },
  watch: {
    // Filter Department Tree by Name
    deptName(val) {
      this.$refs.tree.filter(val)
    }
  },
  created() {
    this.getList()
    this.getDeptTree()
    this.getConfigKey("sys.user.initPassword").then(response => {
      this.initPassword = response.msg
    })
  },
  methods: {
    /** Query User List */
    getList() {
      this.loading = true
      listUser(this.addDateRange(this.queryParams, this.dateRange)).then(response => {
          this.userList = response.rows
          this.total = response.total
          this.loading = false
        }
      )
    },
    /** Query Department Dropdown Tree Structure */
    getDeptTree() {
      deptTreeSelect().then(response => {
        this.deptOptions = response.data
        this.enabledDeptOptions = this.filterDisabledDept(JSON.parse(JSON.stringify(response.data)))
      })
    },
    // Filter Disabled Departments
    filterDisabledDept(deptList) {
      return deptList.filter(dept => {
        if (dept.disabled) {
          return false
        }
        if (dept.children && dept.children.length) {
          dept.children = this.filterDisabledDept(dept.children)
        }
        return true
      })
    },
    // Filter Node
    filterNode(value, data) {
      if (!value) return true
      return data.label.indexOf(value) !== -1
    },
    // Node Click Event
    handleNodeClick(data) {
      this.queryParams.deptId = data.id
      this.handleQuery()
    },
    // User Status Change
    handleStatusChange(row) {
      let text = row.status === "0" ? "Enable" : "Disable"
      this.$modal.confirm('Confirm to "' + text + '" "' + row.userName + '" user?').then(function() {
        return changeUserStatus(row.userId, row.status)
      }).then(() => {
        this.$modal.msgSuccess(text + " successful")
      }).catch(function() {
        row.status = row.status === "0" ? "1" : "0"
      })
    },
    // Cancel Button
    cancel() {
      this.open = false
      this.reset()
    },
    // Form Reset
    reset() {
      this.form = {
        userId: undefined,
        deptId: undefined,
        userName: undefined,
        nickName: undefined,
        password: undefined,
        phonenumber: undefined,
        email: undefined,
        sex: undefined,
        status: "0",
        remark: undefined,
        postIds: [],
        roleIds: []
      }
      this.resetForm("form")
    },
    /** Search Button Operation */
    handleQuery() {
      this.queryParams.pageNum = 1
      this.getList()
    },
    /** Reset Button Operation */
    resetQuery() {
      this.dateRange = []
      this.resetForm("queryForm")
      this.queryParams.deptId = undefined
      this.$refs.tree.setCurrentKey(null)
      this.handleQuery()
    },
    // Multi-select Selected Data
    handleSelectionChange(selection) {
      this.ids = selection.map(item => item.userId)
      this.single = selection.length != 1
      this.multiple = !selection.length
    },
    // More Operations Trigger
    handleCommand(command, row) {
      switch (command) {
        case "handleResetPwd":
          this.handleResetPwd(row)
          break
        case "handleAuthRole":
          this.handleAuthRole(row)
          break
        default:
          break
      }
    },
    /** Add Button Operation */
    handleAdd() {
      this.reset()
      getUser().then(response => {
        this.postOptions = response.posts
        this.roleOptions = response.roles
        this.open = true
        this.title = "Add User"
        this.form.password = this.initPassword
      })
    },
    /** Modify Button Operation */
    handleUpdate(row) {
      this.reset()
      const userId = row.userId || this.ids
      getUser(userId).then(response => {
        this.form = response.data
        this.postOptions = response.posts
        this.roleOptions = response.roles
        this.$set(this.form, "postIds", response.postIds)
        this.$set(this.form, "roleIds", response.roleIds)
        this.open = true
        this.title = "Modify User"
        this.form.password = ""
      })
    },
    /** Reset Password Button Operation */
    handleResetPwd(row) {
      this.$prompt('Please enter the new password for "' + row.userName + '"', "Prompt", {
        confirmButtonText: "Confirm",
        cancelButtonText: "Cancel",
        closeOnClickModal: false,
        inputPattern: /^.{5,20}$/,
        inputErrorMessage: "User password length must be between 5 and 20 characters",
        inputValidator: (value) => {
          if (/<|>|"|'|\||\\/.test(value)) {
            return "Cannot contain illegal characters: < > \" ' \\\ |"
          }
        },
      }).then(({ value }) => {
          resetUserPwd(row.userId, value).then(response => {
            this.$modal.msgSuccess("Modified successfully, new password is: " + value)
          })
        }).catch(() => {})
    },
    /** Assign Role Operation */
    handleAuthRole: function(row) {
      const userId = row.userId
      this.$router.push("/system/user-auth/role/" + userId)
    },
    /** Submit Button */
    submitForm: function() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          if (this.form.userId != undefined) {
            updateUser(this.form).then(response => {
              this.$modal.msgSuccess("Modified successfully")
              this.open = false
              this.getList()
            })
          } else {
            addUser(this.form).then(response => {
              this.$modal.msgSuccess("Added successfully")
              this.open = false
              this.getList()
            })
          }
        }
      })
    },
    /** Delete Button Operation */
    handleDelete(row) {
      const userIds = row.userId || this.ids
      this.$modal.confirm('Are you sure to delete user ID "' + userIds + '" data items?').then(function() {
        return delUser(userIds)
      }).then(() => {
        this.getList()
        this.$modal.msgSuccess("Deleted successfully")
      }).catch(() => {})
    },
    /** Export Button Operation */
    handleExport() {
      this.download('system/user/export', {
        ...this.queryParams
      }, `user_${new Date().getTime()}.xlsx`)
    },
    /** Import Button Operation */
    handleImport() {
      this.upload.title = "User Import"
      this.upload.open = true
    },
    /** Download Template Operation */
    importTemplate() {
      this.download('system/user/importTemplate', {
      }, `user_template_${new Date().getTime()}.xlsx`)
    },
    // File Upload Progress Handler
    handleFileUploadProgress(event, file, fileList) {
      this.upload.isUploading = true
    },
    // File Upload Success Handler
    handleFileSuccess(response, file, fileList) {
      this.upload.open = false
      this.upload.isUploading = false
      this.$refs.upload.clearFiles()
      this.$alert("<div style='overflow: auto;overflow-x: hidden;max-height: 70vh;padding: 10px 20px 0;'>" + response.msg + "</div>", "Import Result", { dangerouslyUseHTMLString: true })
      this.getList()
    },
    // Submit Upload File
    submitFileForm() {
      const file = this.$refs.upload.uploadFiles
      if (!file || file.length === 0 || !file[0].name.toLowerCase().endsWith('.xls') && !file[0].name.toLowerCase().endsWith('.xlsx')) {
        this.$modal.msgError("Please select files with suffix \".xls\" or \".xlsx\".")
        return
      }
      this.$refs.upload.submit()
    }
  }
}
</script>