<template>
  <el-form ref="genInfoForm" :model="info" :rules="rules" label-width="150px">
    <el-row>
      <el-col :span="12">
        <el-form-item prop="tplCategory">
          <span slot="label">Generation Template</span>
          <el-select v-model="info.tplCategory" @change="tplSelectChange">
            <el-option label="Single Table (CRUD)" value="crud" />
            <el-option label="Tree Table (CRUD)" value="tree" />
            <el-option label="Master-Sub Table (CRUD)" value="sub" />
          </el-select>
        </el-form-item>
      </el-col>
      <el-col :span="12">
        <el-form-item prop="tplWebType">
          <span slot="label">Frontend Type</span>
          <el-select v-model="info.tplWebType">
            <el-option label="Vue2 Element UI Template" value="element-ui" />
            <el-option label="Vue3 Element Plus Template" value="element-plus" />
          </el-select>
        </el-form-item>
      </el-col>
      <el-col :span="12">
        <el-form-item prop="packageName">
          <span slot="label">
            Generation Package Path
            <el-tooltip content="Which Java package to generate under, e.g. com.ruoyi.system" placement="top">
              <i class="el-icon-question"></i>
            </el-tooltip>
          </span>
          <el-input v-model="info.packageName" />
        </el-form-item>
      </el-col>

      <el-col :span="12">
        <el-form-item prop="moduleName">
          <span slot="label">
            Generation Module Name
            <el-tooltip content="Can be understood as subsystem name, e.g. system" placement="top">
              <i class="el-icon-question"></i>
            </el-tooltip>
          </span>
          <el-input v-model="info.moduleName" />
        </el-form-item>
      </el-col>

      <el-col :span="12">
        <el-form-item prop="businessName">
          <span slot="label">
            Generation Business Name
            <el-tooltip content="Can be understood as function English name, e.g. user" placement="top">
              <i class="el-icon-question"></i>
            </el-tooltip>
          </span>
          <el-input v-model="info.businessName" />
        </el-form-item>
      </el-col>

      <el-col :span="12">
        <el-form-item prop="functionName">
          <span slot="label">
            Generation Function Name
            <el-tooltip content="Used as class description, e.g. User" placement="top">
              <i class="el-icon-question"></i>
            </el-tooltip>
          </span>
          <el-input v-model="info.functionName" />
        </el-form-item>
      </el-col>

      <el-col :span="12">
        <el-form-item prop="genType">
          <span slot="label">
            Code Generation Method
            <el-tooltip content="Default is zip package download, can also customize generation path" placement="top">
              <i class="el-icon-question"></i>
            </el-tooltip>
          </span>
          <el-radio v-model="info.genType" label="0">Zip Package</el-radio>
          <el-radio v-model="info.genType" label="1">Custom Path</el-radio>
        </el-form-item>
      </el-col>

      <el-col :span="12">
        <el-form-item>
          <span slot="label">
            Parent Menu
            <el-tooltip content="Assign to specified menu, e.g. System Management" placement="top">
              <i class="el-icon-question"></i>
            </el-tooltip>
          </span>
          <treeselect
            :append-to-body="true"
            v-model="info.parentMenuId"
            :options="menus"
            :normalizer="normalizer"
            :show-count="true"
            placeholder="Please select system menu"
          />
        </el-form-item>
      </el-col>

      <el-col :span="24" v-if="info.genType == '1'">
        <el-form-item prop="genPath">
          <span slot="label">
            Custom Path
            <el-tooltip content="Enter absolute disk path, if not filled, generate under current Web project" placement="top">
              <i class="el-icon-question"></i>
            </el-tooltip>
          </span>
          <el-input v-model="info.genPath">
            <el-dropdown slot="append">
              <el-button type="primary">
                Quick Select Recent Path
                <i class="el-icon-arrow-down el-icon--right"></i>
              </el-button>
              <el-dropdown-menu slot="dropdown">
                <el-dropdown-item @click.native="info.genPath = '/'">Restore Default Generation Base Path</el-dropdown-item>
              </el-dropdown-menu>
            </el-dropdown>
          </el-input>
        </el-form-item>
      </el-col>
    </el-row>

    <el-row v-show="info.tplCategory == 'tree'">
      <h4 class="form-header">Other Information</h4>
      <el-col :span="12">
        <el-form-item>
          <span slot="label">
            Tree Code Field
            <el-tooltip content="Tree display code field name, e.g. dept_id" placement="top">
              <i class="el-icon-question"></i>
            </el-tooltip>
          </span>
          <el-select v-model="info.treeCode" placeholder="Please select">
            <el-option
              v-for="(column, index) in info.columns"
              :key="index"
              :label="column.columnName + ': ' + column.columnComment"
              :value="column.columnName"
            ></el-option>
          </el-select>
        </el-form-item>
      </el-col>
      <el-col :span="12">
        <el-form-item>
          <span slot="label">
            Tree Parent Code Field
            <el-tooltip content="Tree display parent code field name, e.g. parent_Id" placement="top">
              <i class="el-icon-question"></i>
            </el-tooltip>
          </span>
          <el-select v-model="info.treeParentCode" placeholder="Please select">
            <el-option
              v-for="(column, index) in info.columns"
              :key="index"
              :label="column.columnName + ': ' + column.columnComment"
              :value="column.columnName"
            ></el-option>
          </el-select>
        </el-form-item>
      </el-col>
      <el-col :span="12">
        <el-form-item>
          <span slot="label">
            Tree Name Field
            <el-tooltip content="Tree node display name field name, e.g. dept_name" placement="top">
              <i class="el-icon-question"></i>
            </el-tooltip>
          </span>
          <el-select v-model="info.treeName" placeholder="Please select">
            <el-option
              v-for="(column, index) in info.columns"
              :key="index"
              :label="column.columnName + ': ' + column.columnComment"
              :value="column.columnName"
            ></el-option>
          </el-select>
        </el-form-item>
      </el-col>
    </el-row>
    <el-row v-show="info.tplCategory == 'sub'">
      <h4 class="form-header">Association Information</h4>
      <el-col :span="12">
        <el-form-item>
          <span slot="label">
            Associated Sub-table Name
            <el-tooltip content="Associated sub-table name, e.g. sys_user" placement="top">
              <i class="el-icon-question"></i>
            </el-tooltip>
          </span>
          <el-select v-model="info.subTableName" placeholder="Please select" @change="subSelectChange">
            <el-option
              v-for="(table, index) in tables"
              :key="index"
              :label="table.tableName + ': ' + table.tableComment"
              :value="table.tableName"
            ></el-option>
          </el-select>
        </el-form-item>
      </el-col>
      <el-col :span="12">
        <el-form-item>
          <span slot="label">
            Sub-table Foreign Key Name
            <el-tooltip content="Sub-table foreign key name, e.g. user_id" placement="top">
              <i class="el-icon-question"></i>
            </el-tooltip>
          </span>
          <el-select v-model="info.subTableFkName" placeholder="Please select">
            <el-option
              v-for="(column, index) in subColumns"
              :key="index"
              :label="column.columnName + ': ' + column.columnComment"
              :value="column.columnName"
            ></el-option>
          </el-select>
        </el-form-item>
      </el-col>
    </el-row>
  </el-form>
</template>

<script>
import Treeselect from "@riophae/vue-treeselect"
import "@riophae/vue-treeselect/dist/vue-treeselect.css"

export default {
  components: { Treeselect },
  props: {
    info: {
      type: Object,
      default: null
    },
    tables: {
      type: Array,
      default: null
    },
    menus: {
      type: Array,
      default: []
    }
  },
  data() {
    return {
      subColumns: [],
      rules: {
        tplCategory: [
          { required: true, message: "Please select generation template", trigger: "blur" }
        ],
        packageName: [
          { required: true, message: "Please enter generation package path", trigger: "blur" }
        ],
        moduleName: [
          { required: true, message: "Please enter generation module name", trigger: "blur" }
        ],
        businessName: [
          { required: true, message: "Please enter generation business name", trigger: "blur" }
        ],
        functionName: [
          { required: true, message: "Please enter generation function name", trigger: "blur" }
        ]
      }
    }
  },
  watch: {
    'info.subTableName': function(val) {
      this.setSubTableColumns(val)
    },
    'info.tplWebType': function(val) {
      if (val === '') {
        this.info.tplWebType = "element-ui"
      }
    }
  },
  methods: {
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
    /** Sub-table Name Selection Trigger */
    subSelectChange(value) {
      this.info.subTableFkName = ''
    },
    /** Generation Template Selection Trigger */
    tplSelectChange(value) {
      if(value !== 'sub') {
        this.info.subTableName = ''
        this.info.subTableFkName = ''
      }
    },
    /** Set Associated Foreign Key */
    setSubTableColumns(value) {
      for (var item in this.tables) {
        const name = this.tables[item].tableName
        if (value === name) {
          this.subColumns = this.tables[item].columns
          break
        }
      }
    }
  }
}
</script>
