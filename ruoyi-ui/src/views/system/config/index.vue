<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="Parameter Name" prop="configName">
        <el-input
          v-model="queryParams.configName"
          placeholder="Please enter parameter name"
          clearable
          style="width: 240px"
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="Parameter Key" prop="configKey">
        <el-input
          v-model="queryParams.configKey"
          placeholder="Please enter parameter key"
          clearable
          style="width: 240px"
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="System Built-in" prop="configType">
        <el-select v-model="queryParams.configType" placeholder="System Built-in" clearable>
          <el-option
            v-for="dict in dict.type.sys_yes_no"
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
          v-hasPermi="['system:config:add']"
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
          v-hasPermi="['system:config:edit']"
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
          v-hasPermi="['system:config:remove']"
        >Delete</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="warning"
          plain
          icon="el-icon-download"
          size="mini"
          @click="handleExport"
          v-hasPermi="['system:config:export']"
        >Export</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="danger"
          plain
          icon="el-icon-refresh"
          size="mini"
          @click="handleRefreshCache"
          v-hasPermi="['system:config:remove']"
        >Refresh Cache</el-button>
      </el-col>
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="configList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="Parameter ID" align="center" prop="configId" />
      <el-table-column label="Parameter Name" align="center" prop="configName" :show-overflow-tooltip="true" />
      <el-table-column label="Parameter Key" align="center" prop="configKey" :show-overflow-tooltip="true" />
      <el-table-column label="Parameter Value" align="center" prop="configValue" :show-overflow-tooltip="true" />
      <el-table-column label="System Built-in" align="center" prop="configType">
        <template slot-scope="scope">
          <dict-tag :options="dict.type.sys_yes_no" :value="scope.row.configType"/>
        </template>
      </el-table-column>
      <el-table-column label="Remark" align="center" prop="remark" :show-overflow-tooltip="true" />
      <el-table-column label="Creation Time" align="center" prop="createTime" width="180">
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
            v-hasPermi="['system:config:edit']"
          >Edit</el-button>
          <el-button
            size="mini"
            type="text"
            icon="el-icon-delete"
            @click="handleDelete(scope.row)"
            v-hasPermi="['system:config:remove']"
          >Delete</el-button>
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

    <!-- Add or Modify Parameter Configuration Dialog -->
    <el-dialog :title="title" :visible.sync="open" width="500px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="80px">
        <el-form-item label="Parameter Name" prop="configName">
          <el-input v-model="form.configName" placeholder="Please enter parameter name" />
        </el-form-item>
        <el-form-item label="Parameter Key" prop="configKey">
          <el-input v-model="form.configKey" placeholder="Please enter parameter key" />
        </el-form-item>
        <el-form-item label="Parameter Value" prop="configValue">
          <el-input v-model="form.configValue" type="textarea" placeholder="Please enter parameter value" />
        </el-form-item>
        <el-form-item label="System Built-in" prop="configType">
          <el-radio-group v-model="form.configType">
            <el-radio
              v-for="dict in dict.type.sys_yes_no"
              :key="dict.value"
              :label="dict.value"
            >{{dict.label}}</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="Remark" prop="remark">
          <el-input v-model="form.remark" type="textarea" placeholder="Please enter content" />
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitForm">Confirm</el-button>
        <el-button @click="cancel">Cancel</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { listConfig, getConfig, delConfig, addConfig, updateConfig, refreshCache } from "@/api/system/config"

export default {
  name: "Config",
  dicts: ['sys_yes_no'],
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
      // Parameter Table Data
      configList: [],
      // Popup Title
      title: "",
      // Whether to Show Popup
      open: false,
      // Date Range
      dateRange: [],
      // Query Parameters
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        configName: undefined,
        configKey: undefined,
        configType: undefined
      },
      // Form Parameters
      form: {},
      // Form Validation
      rules: {
        configName: [
          { required: true, message: "Parameter name cannot be empty", trigger: "blur" }
        ],
        configKey: [
          { required: true, message: "Parameter key cannot be empty", trigger: "blur" }
        ],
        configValue: [
          { required: true, message: "Parameter value cannot be empty", trigger: "blur" }
        ]
      }
    }
  },
  created() {
    this.getList()
  },
  methods: {
    /** Query Parameter List */
    getList() {
      this.loading = true
      listConfig(this.addDateRange(this.queryParams, this.dateRange)).then(response => {
          this.configList = response.rows
          this.total = response.total
          this.loading = false
        }
      )
    },
    // Cancel Button
    cancel() {
      this.open = false
      this.reset()
    },
    // Form Reset
    reset() {
      this.form = {
        configId: undefined,
        configName: undefined,
        configKey: undefined,
        configValue: undefined,
        configType: "Y",
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
    /** Add Button Operation */
    handleAdd() {
      this.reset()
      this.open = true
      this.title = "Add Parameter"
    },
    // Multi-select Selected Data
    handleSelectionChange(selection) {
      this.ids = selection.map(item => item.configId)
      this.single = selection.length!=1
      this.multiple = !selection.length
    },
    /** Modify Button Operation */
    handleUpdate(row) {
      this.reset()
      const configId = row.configId || this.ids
      getConfig(configId).then(response => {
        this.form = response.data
        this.open = true
        this.title = "Modify Parameter"
      })
    },
    /** Submit Button */
    submitForm: function() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          if (this.form.configId != undefined) {
            updateConfig(this.form).then(response => {
              this.$modal.msgSuccess("Updated successfully")
              this.open = false
              this.getList()
            })
          } else {
            addConfig(this.form).then(response => {
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
      const configIds = row.configId || this.ids
      this.$modal.confirm('Are you sure to delete parameter ID "' + configIds + '" data items?').then(function() {
        return delConfig(configIds)
      }).then(() => {
        this.getList()
        this.$modal.msgSuccess("Deleted successfully")
      }).catch(() => {})
    },
    /** Export Button Operation */
    handleExport() {
      this.download('system/config/export', {
        ...this.queryParams
      }, `config_${new Date().getTime()}.xlsx`)
    },
    /** Refresh Cache Button Operation */
    handleRefreshCache() {
      refreshCache().then(() => {
        this.$modal.msgSuccess("Refreshed successfully")
      })
    }
  }
}
</script>
