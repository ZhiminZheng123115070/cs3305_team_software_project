<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch">
      <el-form-item label="Role Name" prop="roleName">
        <el-input
          v-model="queryParams.roleName"
          placeholder="Please enter role name"
          clearable
          style="width: 240px"
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="Permission Key" prop="roleKey">
        <el-input
          v-model="queryParams.roleKey"
          placeholder="Please enter permission key"
          clearable
          style="width: 240px"
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="Status" prop="status">
        <el-select
          v-model="queryParams.status"
          placeholder="Role Status"
          clearable
          style="width: 240px"
        >
          <el-option
            v-for="dict in dict.type.sys_normal_disable"
            :key="dict.value"
            :label="dict.label"
            :value="dict.value"
          />
        </el-select>
      </el-form-item>
      <el-form-item label="Creation Time">
        <el-date-picker
          v-model="dateRange"
          style="width: 240px"
          value-format="yyyy-MM-dd"
          type="daterange"
          range-separator="-"
          start-placeholder="Start Date"
          end-placeholder="End Date"
        ></el-date-picker>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">Search</el-button>
        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">Reset</el-button>
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-button
          type="primary"
          plain
          icon="el-icon-plus"
          size="mini"
          @click="handleAdd"
          v-hasPermi="['system:role:add']"
        >Add</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="success"
          plain
          icon="el-icon-edit"
          size="mini"
          :disabled="single"
          @click="handleUpdate"
          v-hasPermi="['system:role:edit']"
        >Edit</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="danger"
          plain
          icon="el-icon-delete"
          size="mini"
          :disabled="multiple"
          @click="handleDelete"
          v-hasPermi="['system:role:remove']"
        >Delete</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="warning"
          plain
          icon="el-icon-download"
          size="mini"
          @click="handleExport"
          v-hasPermi="['system:role:export']"
        >Export</el-button>
      </el-col>
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="roleList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="Role ID" prop="roleId" width="120" />
      <el-table-column label="Role Name" prop="roleName" :show-overflow-tooltip="true" width="150" />
      <el-table-column label="Permission Key" prop="roleKey" :show-overflow-tooltip="true" width="150" />
      <el-table-column label="Display Order" prop="roleSort" width="100" />
      <el-table-column label="Status" align="center" width="100">
        <template slot-scope="scope">
          <el-switch
            v-model="scope.row.status"
            active-value="0"
            inactive-value="1"
            @change="handleStatusChange(scope.row)"
          ></el-switch>
        </template>
      </el-table-column>
      <el-table-column label="Creation Time" align="center" prop="createTime" width="180">
        <template slot-scope="scope">
          <span>{{ parseTime(scope.row.createTime) }}</span>
        </template>
      </el-table-column>
      <el-table-column label="Operation" align="center" class-name="small-padding fixed-width">
        <template slot-scope="scope" v-if="scope.row.roleId !== 1">
          <el-button
            size="mini"
            type="text"
            icon="el-icon-edit"
            @click="handleUpdate(scope.row)"
            v-hasPermi="['system:role:edit']"
          >Edit</el-button>
          <el-button
            size="mini"
            type="text"
            icon="el-icon-delete"
            @click="handleDelete(scope.row)"
            v-hasPermi="['system:role:remove']"
          >Delete</el-button>
          <el-dropdown size="mini" @command="(command) => handleCommand(command, scope.row)" v-hasPermi="['system:role:edit']">
            <el-button size="mini" type="text" icon="el-icon-d-arrow-right">More</el-button>
            <el-dropdown-menu slot="dropdown">
              <el-dropdown-item command="handleDataScope" icon="el-icon-circle-check"
                v-hasPermi="['system:role:edit']">Data Permission</el-dropdown-item>
              <el-dropdown-item command="handleAuthUser" icon="el-icon-user"
                v-hasPermi="['system:role:edit']">Assign User</el-dropdown-item>
            </el-dropdown-menu>
          </el-dropdown>
        </template>
      </el-table-column>
    </el-table>

    <pagination
      v-show="total>0"
      :total="total"
      :page.sync="queryParams.pageNum"
      :limit.sync="queryParams.pageSize"
      @pagination="getList"
    />

    <!-- Add or Modify Role Configuration Dialog -->
    <el-dialog :title="title" :visible.sync="open" width="500px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="100px">
        <el-form-item label="Role Name" prop="roleName">
          <el-input v-model="form.roleName" placeholder="Please enter role name" />
        </el-form-item>
        <el-form-item prop="roleKey">
          <span slot="label">
            <el-tooltip content="Permission character defined in the controller, e.g.: @PreAuthorize(`@ss.hasRole('admin')`)" placement="top">
              <i class="el-icon-question"></i>
            </el-tooltip>
            Permission Key
          </span>
          <el-input v-model="form.roleKey" placeholder="Please enter permission key" />
        </el-form-item>
        <el-form-item label="Role Order" prop="roleSort">
          <el-input-number v-model="form.roleSort" controls-position="right" :min="0" />
        </el-form-item>
        <el-form-item label="Status">
          <el-radio-group v-model="form.status">
            <el-radio
              v-for="dict in dict.type.sys_normal_disable"
              :key="dict.value"
              :label="dict.value"
            >{{dict.label}}</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="Menu Permission">
          <el-checkbox v-model="menuExpand" @change="handleCheckedTreeExpand($event, 'menu')">Expand/Collapse</el-checkbox>
          <el-checkbox v-model="menuNodeAll" @change="handleCheckedTreeNodeAll($event, 'menu')">Select All/None</el-checkbox>
          <el-checkbox v-model="form.menuCheckStrictly" @change="handleCheckedTreeConnect($event, 'menu')">Parent-Child Linkage</el-checkbox>
          <el-tree
            class="tree-border"
            :data="menuOptions"
            show-checkbox
            ref="menu"
            node-key="id"
            :check-strictly="!form.menuCheckStrictly"
            empty-text="Loading, please wait"
            :props="defaultProps"
          ></el-tree>
        </el-form-item>
        <el-form-item label="Remark">
          <el-input v-model="form.remark" type="textarea" placeholder="Please enter content"></el-input>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitForm">Confirm</el-button>
        <el-button @click="cancel">Cancel</el-button>
      </div>
    </el-dialog>

    <!-- Assign Role Data Permission Dialog -->
    <el-dialog :title="title" :visible.sync="openDataScope" width="500px" append-to-body>
      <el-form :model="form" label-width="80px">
        <el-form-item label="Role Name">
          <el-input v-model="form.roleName" :disabled="true" />
        </el-form-item>
        <el-form-item label="Permission Key">
          <el-input v-model="form.roleKey" :disabled="true" />
        </el-form-item>
        <el-form-item label="Permission Scope">
          <el-select v-model="form.dataScope" @change="dataScopeSelectChange">
            <el-option
              v-for="item in dataScopeOptions"
              :key="item.value"
              :label="item.label"
              :value="item.value"
            ></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="Data Permission" v-show="form.dataScope == 2">
          <el-checkbox v-model="deptExpand" @change="handleCheckedTreeExpand($event, 'dept')">Expand/Collapse</el-checkbox>
          <el-checkbox v-model="deptNodeAll" @change="handleCheckedTreeNodeAll($event, 'dept')">Select All/None</el-checkbox>
          <el-checkbox v-model="form.deptCheckStrictly" @change="handleCheckedTreeConnect($event, 'dept')">Parent-Child Linkage</el-checkbox>
          <el-tree
            class="tree-border"
            :data="deptOptions"
            show-checkbox
            default-expand-all
            ref="dept"
            node-key="id"
            :check-strictly="!form.deptCheckStrictly"
            empty-text="Loading, please wait"
            :props="defaultProps"
          ></el-tree>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitDataScope">Confirm</el-button>
        <el-button @click="cancelDataScope">Cancel</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { listRole, getRole, delRole, addRole, updateRole, dataScope, changeRoleStatus, deptTreeSelect } from "@/api/system/role"
import { treeselect as menuTreeselect, roleMenuTreeselect } from "@/api/system/menu"

export default {
  name: "Role",
  dicts: ['sys_normal_disable'],
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
      // Role Table Data
      roleList: [],
      // Popup Title
      title: "",
      // Whether to Show Popup
      open: false,
      // Whether to Show Popup (Data Permission)
      openDataScope: false,
      menuExpand: false,
      menuNodeAll: false,
      deptExpand: true,
      deptNodeAll: false,
      // Date Range
      dateRange: [],
      // Data Scope Options
      dataScopeOptions: [
        {
          value: "1",
          label: "All Data Permissions"
        },
        {
          value: "2",
          label: "Custom Data Permissions"
        },
        {
          value: "3",
          label: "Department Data Permissions"
        },
        {
          value: "4",
          label: "Department and Sub-department Data Permissions"
        },
        {
          value: "5",
          label: "Only Own Data Permissions"
        }
      ],
      // Menu List
      menuOptions: [],
      // Department List
      deptOptions: [],
      // Query Parameters
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        roleName: undefined,
        roleKey: undefined,
        status: undefined
      },
      // Form Parameters
      form: {},
      defaultProps: {
        children: "children",
        label: "label"
      },
      // Form Validation
      rules: {
        roleName: [
          { required: true, message: "Role name cannot be empty", trigger: "blur" }
        ],
        roleKey: [
          { required: true, message: "Permission key cannot be empty", trigger: "blur" }
        ],
        roleSort: [
          { required: true, message: "Role order cannot be empty", trigger: "blur" }
        ]
      }
    }
  },
  created() {
    this.getList()
  },
  methods: {
    /** Query Role List */
    getList() {
      this.loading = true
      listRole(this.addDateRange(this.queryParams, this.dateRange)).then(response => {
          this.roleList = response.rows
          this.total = response.total
          this.loading = false
        }
      )
    },
    /** Query Menu Tree Structure */
    getMenuTreeselect() {
      menuTreeselect().then(response => {
        this.menuOptions = response.data
      })
    },
    // All Menu Node Data
    getMenuAllCheckedKeys() {
      // Currently Selected Menu Nodes
      let checkedKeys = this.$refs.menu.getCheckedKeys()
      // Half-Selected Menu Nodes
      let halfCheckedKeys = this.$refs.menu.getHalfCheckedKeys()
      checkedKeys.unshift.apply(checkedKeys, halfCheckedKeys)
      return checkedKeys
    },
    // All Department Node Data
    getDeptAllCheckedKeys() {
      // Currently Selected Department Nodes
      let checkedKeys = this.$refs.dept.getCheckedKeys()
      // Half-Selected Department Nodes
      let halfCheckedKeys = this.$refs.dept.getHalfCheckedKeys()
      checkedKeys.unshift.apply(checkedKeys, halfCheckedKeys)
      return checkedKeys
    },
    /** Query Menu Tree Structure by Role ID */
    getRoleMenuTreeselect(roleId) {
      return roleMenuTreeselect(roleId).then(response => {
        this.menuOptions = response.menus
        return response
      })
    },
    /** Query Department Tree Structure by Role ID */
    getDeptTree(roleId) {
      return deptTreeSelect(roleId).then(response => {
        this.deptOptions = response.depts
        return response
      })
    },
    // Role Status Change
    handleStatusChange(row) {
      let text = row.status === "0" ? "Enable" : "Disable"
      this.$modal.confirm('Confirm to "' + text + '" "' + row.roleName + '" role?').then(function() {
        return changeRoleStatus(row.roleId, row.status)
      }).then(() => {
        this.$modal.msgSuccess(text + " successfully")
      }).catch(function() {
        row.status = row.status === "0" ? "1" : "0"
      })
    },
    // Cancel Button
    cancel() {
      this.open = false
      this.reset()
    },
    // Cancel Button (Data Permission)
    cancelDataScope() {
      this.openDataScope = false
      this.reset()
    },
    // Form Reset
    reset() {
      if (this.$refs.menu != undefined) {
        this.$refs.menu.setCheckedKeys([])
      }
      this.menuExpand = false,
      this.menuNodeAll = false,
      this.deptExpand = true,
      this.deptNodeAll = false,
      this.form = {
        roleId: undefined,
        roleName: undefined,
        roleKey: undefined,
        roleSort: 0,
        status: "0",
        menuIds: [],
        deptIds: [],
        menuCheckStrictly: true,
        deptCheckStrictly: true,
        remark: undefined
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
      this.handleQuery()
    },
    // Multi-select Selected Data
    handleSelectionChange(selection) {
      this.ids = selection.map(item => item.roleId)
      this.single = selection.length!=1
      this.multiple = !selection.length
    },
    // More Operations Trigger
    handleCommand(command, row) {
      switch (command) {
        case "handleDataScope":
          this.handleDataScope(row)
          break
        case "handleAuthUser":
          this.handleAuthUser(row)
          break
        default:
          break
      }
    },
    // Tree Permission (Expand/Collapse)
    handleCheckedTreeExpand(value, type) {
      if (type == 'menu') {
        let treeList = this.menuOptions
        for (let i = 0; i < treeList.length; i++) {
          this.$refs.menu.store.nodesMap[treeList[i].id].expanded = value
        }
      } else if (type == 'dept') {
        let treeList = this.deptOptions
        for (let i = 0; i < treeList.length; i++) {
          this.$refs.dept.store.nodesMap[treeList[i].id].expanded = value
        }
      }
    },
    // Tree Permission (Select All/None)
    handleCheckedTreeNodeAll(value, type) {
      if (type == 'menu') {
        this.$refs.menu.setCheckedNodes(value ? this.menuOptions: [])
      } else if (type == 'dept') {
        this.$refs.dept.setCheckedNodes(value ? this.deptOptions: [])
      }
    },
    // Tree Permission (Parent-Child Linkage)
    handleCheckedTreeConnect(value, type) {
      if (type == 'menu') {
        this.form.menuCheckStrictly = value ? true: false
      } else if (type == 'dept') {
        this.form.deptCheckStrictly = value ? true: false
      }
    },
    /** Add Button Operation */
    handleAdd() {
      this.reset()
      this.getMenuTreeselect()
      this.open = true
      this.title = "Add Role"
    },
    /** Modify Button Operation */
    handleUpdate(row) {
      this.reset()
      const roleId = row.roleId || this.ids
      const roleMenu = this.getRoleMenuTreeselect(roleId)
      getRole(roleId).then(response => {
        this.form = response.data
        this.open = true
        this.$nextTick(() => {
          roleMenu.then(res => {
            let checkedKeys = res.checkedKeys
            checkedKeys.forEach((v) => {
                this.$nextTick(()=>{
                    this.$refs.menu.setChecked(v, true ,false)
                })
            })
          })
        })
      })
      this.title = "Modify Role"
    },
    /** Select Role Permission Scope Trigger */
    dataScopeSelectChange(value) {
      if(value !== '2') {
        this.$refs.dept.setCheckedKeys([])
      }
    },
    /** Assign Data Permission Operation */
    handleDataScope(row) {
      this.reset()
      const deptTreeSelect = this.getDeptTree(row.roleId)
      getRole(row.roleId).then(response => {
        this.form = response.data
        this.openDataScope = true
        this.$nextTick(() => {
          deptTreeSelect.then(res => {
            this.$refs.dept.setCheckedKeys(res.checkedKeys)
          })
        })
      })
      this.title = "Assign Data Permission"
    },
    /** Assign User Operation */
    handleAuthUser: function(row) {
      const roleId = row.roleId
      this.$router.push("/system/role-auth/user/" + roleId)
    },
    /** Submit Button */
    submitForm: function() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          if (this.form.roleId != undefined) {
            this.form.menuIds = this.getMenuAllCheckedKeys()
            updateRole(this.form).then(response => {
              this.$modal.msgSuccess("Updated successfully")
              this.open = false
              this.getList()
            })
          } else {
            this.form.menuIds = this.getMenuAllCheckedKeys()
            addRole(this.form).then(response => {
              this.$modal.msgSuccess("Added successfully")
              this.open = false
              this.getList()
            })
          }
        }
      })
    },
    /** Submit Button (Data Permission) */
    submitDataScope: function() {
      if (this.form.roleId != undefined) {
        this.form.deptIds = this.getDeptAllCheckedKeys()
        dataScope(this.form).then(response => {
          this.$modal.msgSuccess("Updated successfully")
          this.openDataScope = false
          this.getList()
        })
      }
    },
    /** Delete Button Operation */
    handleDelete(row) {
      const roleIds = row.roleId || this.ids
      this.$modal.confirm('Are you sure to delete role ID "' + roleIds + '" data items?').then(function() {
        return delRole(roleIds)
      }).then(() => {
        this.getList()
        this.$modal.msgSuccess("Deleted successfully")
      }).catch(() => {})
    },
    /** Export Button Operation */
    handleExport() {
      this.download('system/role/export', {
        ...this.queryParams
      }, `role_${new Date().getTime()}.xlsx`)
    }
  }
}
</script>