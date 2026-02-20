<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch">
      <el-form-item label="Menu Name" prop="menuName">
        <el-input
          v-model="queryParams.menuName"
          placeholder="Please enter menu name"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="Status" prop="status">
        <el-select v-model="queryParams.status" placeholder="Menu Status" clearable>
          <el-option
            v-for="dict in dict.type.sys_normal_disable"
            :key="dict.value"
            :label="dict.label"
            :value="dict.value"
          />
        </el-select>
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
          v-hasPermi="['system:menu:add']"
        >Add</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="info"
          plain
          icon="el-icon-sort"
          size="mini"
          @click="toggleExpandAll"
        >Expand/Collapse</el-button>
      </el-col>
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table
      v-if="refreshTable"
      v-loading="loading"
      :data="menuList"
      row-key="menuId"
      :default-expand-all="isExpandAll"
      :tree-props="{children: 'children', hasChildren: 'hasChildren'}"
    >
      <el-table-column prop="menuName" label="Menu Name" :show-overflow-tooltip="true" width="160"></el-table-column>
      <el-table-column prop="icon" label="Icon" align="center" width="100">
        <template slot-scope="scope">
          <svg-icon :icon-class="scope.row.icon" />
        </template>
      </el-table-column>
      <el-table-column prop="orderNum" label="Order" width="60"></el-table-column>
      <el-table-column prop="perms" label="Permission Key" :show-overflow-tooltip="true"></el-table-column>
      <el-table-column prop="component" label="Component Path" :show-overflow-tooltip="true"></el-table-column>
      <el-table-column prop="status" label="Status" width="80">
        <template slot-scope="scope">
          <dict-tag :options="dict.type.sys_normal_disable" :value="scope.row.status"/>
        </template>
      </el-table-column>
      <el-table-column label="Creation Time" align="center" prop="createTime">
        <template slot-scope="scope">
          <span>{{ parseTime(scope.row.createTime) }}</span>
        </template>
      </el-table-column>
      <el-table-column label="Operation" align="center" class-name="small-padding fixed-width">
        <template slot-scope="scope">
          <el-button
            size="mini"
            type="text"
            icon="el-icon-edit"
            @click="handleUpdate(scope.row)"
            v-hasPermi="['system:menu:edit']"
          >Edit</el-button>
          <el-button
            size="mini"
            type="text"
            icon="el-icon-plus"
            @click="handleAdd(scope.row)"
            v-hasPermi="['system:menu:add']"
          >Add</el-button>
          <el-button
            size="mini"
            type="text"
            icon="el-icon-delete"
            @click="handleDelete(scope.row)"
            v-hasPermi="['system:menu:remove']"
          >Delete</el-button>
        </template>
      </el-table-column>
    </el-table>

    <!-- Add or Modify Menu Dialog -->
    <el-dialog :title="title" :visible.sync="open" width="680px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="100px">
        <el-row>
          <el-col :span="24">
            <el-form-item label="Parent Menu" prop="parentId">
              <treeselect
                v-model="form.parentId"
                :options="menuOptions"
                :normalizer="normalizer"
                :show-count="true"
                placeholder="Select parent menu"
              />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="24">
            <el-form-item label="Menu Type" prop="menuType">
              <el-radio-group v-model="form.menuType">
                <el-radio label="M">Directory</el-radio>
                <el-radio label="C">Menu</el-radio>
                <el-radio label="F">Button</el-radio>
              </el-radio-group>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12" v-if="form.menuType != 'F'">
            <el-form-item label="Menu Icon" prop="icon">
              <el-popover
                placement="bottom-start"
                width="460"
                trigger="click"
                @show="$refs['iconSelect'].reset()"
              >
                <IconSelect ref="iconSelect" @selected="selected" :active-icon="form.icon" />
                <el-input slot="reference" v-model="form.icon" placeholder="Click to select icon" readonly>
                  <svg-icon
                    v-if="form.icon"
                    slot="prefix"
                    :icon-class="form.icon"
                    style="width: 25px;"
                  />
                  <i v-else slot="prefix" class="el-icon-search el-input__icon" />
                </el-input>
              </el-popover>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="Display Order" prop="orderNum">
              <el-input-number v-model="form.orderNum" controls-position="right" :min="0" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="Menu Name" prop="menuName">
              <el-input v-model="form.menuName" placeholder="Please enter menu name" />
            </el-form-item>
          </el-col>
          <el-col :span="12" v-if="form.menuType == 'C'">
            <el-form-item prop="routeName">
              <el-input v-model="form.routeName" placeholder="Please enter route name" />
              <span slot="label">
                <el-tooltip content="If not filled, it will be the same as the route address: e.g., if the address is `user`, then the name is `User` (Note: To avoid name conflicts, please customize in special cases to ensure uniqueness)" placement="top">
                <i class="el-icon-question"></i>
                </el-tooltip>
                Route Name
              </span>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12" v-if="form.menuType != 'F'">
            <el-form-item prop="isFrame">
              <span slot="label">
                <el-tooltip content="If external link is selected, the route address needs to start with `http(s)://`" placement="top">
                <i class="el-icon-question"></i>
                </el-tooltip>
                Is External Link
              </span>
              <el-radio-group v-model="form.isFrame">
                <el-radio label="0">Yes</el-radio>
                <el-radio label="1">No</el-radio>
              </el-radio-group>
            </el-form-item>
          </el-col>
          <el-col :span="12" v-if="form.menuType != 'F'">
            <el-form-item prop="path">
              <span slot="label">
                <el-tooltip content="The route address to access, e.g.: `user`, if external address needs internal link access, start with `http(s)://`" placement="top">
                <i class="el-icon-question"></i>
                </el-tooltip>
                Route Address
              </span>
              <el-input v-model="form.path" placeholder="Please enter route address" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12" v-if="form.menuType == 'C'">
            <el-form-item prop="component">
              <span slot="label">
                <el-tooltip content="The component path to access, e.g.: `system/user/index`, default is under the `views` directory" placement="top">
                <i class="el-icon-question"></i>
                </el-tooltip>
                Component Path
              </span>
              <el-input v-model="form.component" placeholder="Please enter component path" />
            </el-form-item>
          </el-col>
          <el-col :span="12" v-if="form.menuType != 'M'">
            <el-form-item prop="perms">
              <el-input v-model="form.perms" placeholder="Please enter permission key" maxlength="100" />
              <span slot="label">
                <el-tooltip content="Permission character defined in the controller, e.g.: @PreAuthorize(`@ss.hasPermi('system:user:list')`)" placement="top">
                <i class="el-icon-question"></i>
                </el-tooltip>
                Permission Key
              </span>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12" v-if="form.menuType == 'C'">
            <el-form-item prop="query">
              <el-input v-model="form.query" placeholder="Please enter route parameters" maxlength="255" />
              <span slot="label">
                <el-tooltip content='Default parameters passed when accessing the route, e.g.: `{"id": 1, "name": "ry"}`' placement="top">
                <i class="el-icon-question"></i>
                </el-tooltip>
                Route Parameters
              </span>
            </el-form-item>
          </el-col>
          <el-col :span="12" v-if="form.menuType == 'C'">
            <el-form-item prop="isCache">
              <span slot="label">
                <el-tooltip content="If selected, it will be cached by `keep-alive`, need to match the component's `name` and address to be consistent" placement="top">
                <i class="el-icon-question"></i>
                </el-tooltip>
                Is Cache
              </span>
              <el-radio-group v-model="form.isCache">
                <el-radio label="0">Cache</el-radio>
                <el-radio label="1">No Cache</el-radio>
              </el-radio-group>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12" v-if="form.menuType != 'F'">
            <el-form-item prop="visible">
              <span slot="label">
                <el-tooltip content="If hidden is selected, the route will not appear in the sidebar, but can still be accessed" placement="top">
                <i class="el-icon-question"></i>
                </el-tooltip>
                Display Status
              </span>
              <el-radio-group v-model="form.visible">
                <el-radio
                  v-for="dict in dict.type.sys_show_hide"
                  :key="dict.value"
                  :label="dict.value"
                >{{dict.label}}</el-radio>
              </el-radio-group>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item prop="status">
              <span slot="label">
                <el-tooltip content="If disabled is selected, the route will not appear in the sidebar and cannot be accessed" placement="top">
                <i class="el-icon-question"></i>
                </el-tooltip>
                Menu Status
              </span>
              <el-radio-group v-model="form.status">
                <el-radio
                  v-for="dict in dict.type.sys_normal_disable"
                  :key="dict.value"
                  :label="dict.value"
                >{{dict.label}}</el-radio>
              </el-radio-group>
            </el-form-item>
          </el-col>
        </el-row>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitForm">Confirm</el-button>
        <el-button @click="cancel">Cancel</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { listMenu, getMenu, delMenu, addMenu, updateMenu } from "@/api/system/menu"
import Treeselect from "@riophae/vue-treeselect"
import "@riophae/vue-treeselect/dist/vue-treeselect.css"
import IconSelect from "@/components/IconSelect"

export default {
  name: "Menu",
  dicts: ['sys_show_hide', 'sys_normal_disable'],
  components: { Treeselect, IconSelect },
  data() {
    return {
      // Overlay
      loading: true,
      // Show Search Conditions
      showSearch: true,
      // Menu Table Tree Data
      menuList: [],
      // Menu Tree Options
      menuOptions: [],
      // Popup Title
      title: "",
      // Whether to Show Popup
      open: false,
      // Whether to Expand, Default All Collapsed
      isExpandAll: false,
      // Re-render Table Status
      refreshTable: true,
      // Query Parameters
      queryParams: {
        menuName: undefined,
        visible: undefined
      },
      // Form Parameters
      form: {},
      // Form Validation
      rules: {
        menuName: [
          { required: true, message: "Menu name cannot be empty", trigger: "blur" }
        ],
        orderNum: [
          { required: true, message: "Menu order cannot be empty", trigger: "blur" }
        ],
        path: [
          { required: true, message: "Route address cannot be empty", trigger: "blur" }
        ]
      }
    }
  },
  created() {
    this.getList()
  },
  methods: {
    // Select Icon
    selected(name) {
      this.form.icon = name
    },
    /** Query Menu List */
    getList() {
      this.loading = true
      listMenu(this.queryParams).then(response => {
        this.menuList = this.handleTree(response.data, "menuId")
        this.loading = false
      })
    },
    /** Convert Menu Data Structure */
    normalizer(node) {
      if (node.children && !node.children.length) {
        delete node.children
      }
      return {
        id: node.menuId,
        label: node.menuName,
        children: node.children
      }
    },
    /** Query Menu Dropdown Tree Structure */
    getTreeselect() {
      listMenu().then(response => {
        this.menuOptions = []
        const menu = { menuId: 0, menuName: 'Main Category', children: [] }
        menu.children = this.handleTree(response.data, "menuId")
        this.menuOptions.push(menu)
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
        menuId: undefined,
        parentId: 0,
        menuName: undefined,
        icon: undefined,
        menuType: "M",
        orderNum: undefined,
        isFrame: "1",
        isCache: "0",
        visible: "0",
        status: "0"
      }
      this.resetForm("form")
    },
    /** Search Button Operation */
    handleQuery() {
      this.getList()
    },
    /** Reset Button Operation */
    resetQuery() {
      this.resetForm("queryForm")
      this.handleQuery()
    },
    /** Add Button Operation */
    handleAdd(row) {
      this.reset()
      this.getTreeselect()
      if (row != null && row.menuId) {
        this.form.parentId = row.menuId
      } else {
        this.form.parentId = 0
      }
      this.open = true
      this.title = "Add Menu"
    },
    /** Expand/Collapse Operation */
    toggleExpandAll() {
      this.refreshTable = false
      this.isExpandAll = !this.isExpandAll
      this.$nextTick(() => {
        this.refreshTable = true
      })
    },
    /** Modify Button Operation */
    handleUpdate(row) {
      this.reset()
      this.getTreeselect()
      getMenu(row.menuId).then(response => {
        this.form = response.data
        this.open = true
        this.title = "Modify Menu"
      })
    },
    /** Submit Button */
    submitForm: function() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          if (this.form.menuId != undefined) {
            updateMenu(this.form).then(response => {
              this.$modal.msgSuccess("Updated successfully")
              this.open = false
              this.getList()
            })
          } else {
            addMenu(this.form).then(response => {
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
      this.$modal.confirm('Are you sure to delete the item named "' + row.menuName + '"?').then(function() {
        return delMenu(row.menuId)
      }).then(() => {
        this.getList()
        this.$modal.msgSuccess("Deleted successfully")
      }).catch(() => {})
    }
  }
}
</script>
