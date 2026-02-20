<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="Notice Title" prop="noticeTitle">
        <el-input
          v-model="queryParams.noticeTitle"
          placeholder="Please enter notice title"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="Operator" prop="createBy">
        <el-input
          v-model="queryParams.createBy"
          placeholder="Please enter operator"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="Type" prop="noticeType">
        <el-select v-model="queryParams.noticeType" placeholder="Notice Type" clearable>
          <el-option
            v-for="dict in dict.type.sys_notice_type"
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
          v-hasPermi="['system:notice:add']"
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
          v-hasPermi="['system:notice:edit']"
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
          v-hasPermi="['system:notice:remove']"
        >Delete</el-button>
      </el-col>
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="noticeList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="No." align="center" prop="noticeId" width="100" />
      <el-table-column
        label="Notice Title"
        align="center"
        prop="noticeTitle"
        :show-overflow-tooltip="true"
      />
      <el-table-column label="Notice Type" align="center" prop="noticeType" width="100">
        <template slot-scope="scope">
          <dict-tag :options="dict.type.sys_notice_type" :value="scope.row.noticeType"/>
        </template>
      </el-table-column>
      <el-table-column label="Status" align="center" prop="status" width="100">
        <template slot-scope="scope">
          <dict-tag :options="dict.type.sys_notice_status" :value="scope.row.status"/>
        </template>
      </el-table-column>
      <el-table-column label="Creator" align="center" prop="createBy" width="100" />
      <el-table-column label="Creation Time" align="center" prop="createTime" width="100">
        <template slot-scope="scope">
          <span>{{ parseTime(scope.row.createTime, '{y}-{m}-{d}') }}</span>
        </template>
      </el-table-column>
      <el-table-column label="Operation" align="center" class-name="small-padding fixed-width">
        <template slot-scope="scope">
          <el-button
            size="mini"
            type="text"
            icon="el-icon-edit"
            @click="handleUpdate(scope.row)"
            v-hasPermi="['system:notice:edit']"
          >Edit</el-button>
          <el-button
            size="mini"
            type="text"
            icon="el-icon-delete"
            @click="handleDelete(scope.row)"
            v-hasPermi="['system:notice:remove']"
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

    <!-- Add or Modify Notice Dialog -->
    <el-dialog :title="title" :visible.sync="open" width="780px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="80px">
        <el-row>
          <el-col :span="12">
            <el-form-item label="Notice Title" prop="noticeTitle">
              <el-input v-model="form.noticeTitle" placeholder="Please enter notice title" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="Notice Type" prop="noticeType">
              <el-select v-model="form.noticeType" placeholder="Please select notice type">
                <el-option
                  v-for="dict in dict.type.sys_notice_type"
                  :key="dict.value"
                  :label="dict.label"
                  :value="dict.value"
                ></el-option>
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="24">
            <el-form-item label="Status">
              <el-radio-group v-model="form.status">
                <el-radio
                  v-for="dict in dict.type.sys_notice_status"
                  :key="dict.value"
                  :label="dict.value"
                >{{dict.label}}</el-radio>
              </el-radio-group>
            </el-form-item>
          </el-col>
          <el-col :span="24">
            <el-form-item label="Content">
              <editor v-model="form.noticeContent" :min-height="192"/>
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
import { listNotice, getNotice, delNotice, addNotice, updateNotice } from "@/api/system/notice"

export default {
  name: "Notice",
  dicts: ['sys_notice_status', 'sys_notice_type'],
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
      // Notice Table Data
      noticeList: [],
      // Popup Title
      title: "",
      // Whether to Show Popup
      open: false,
      // Query Parameters
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        noticeTitle: undefined,
        createBy: undefined,
        status: undefined
      },
      // Form Parameters
      form: {},
      // Form Validation
      rules: {
        noticeTitle: [
          { required: true, message: "Notice title cannot be empty", trigger: "blur" }
        ],
        noticeType: [
          { required: true, message: "Notice type cannot be empty", trigger: "change" }
        ]
      }
    }
  },
  created() {
    this.getList()
  },
  methods: {
    /** Query Notice List */
    getList() {
      this.loading = true
      listNotice(this.queryParams).then(response => {
        this.noticeList = response.rows
        this.total = response.total
        this.loading = false
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
        noticeId: undefined,
        noticeTitle: undefined,
        noticeType: undefined,
        noticeContent: undefined,
        status: "0"
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
      this.resetForm("queryForm")
      this.handleQuery()
    },
    // Multi-select Selected Data
    handleSelectionChange(selection) {
      this.ids = selection.map(item => item.noticeId)
      this.single = selection.length!=1
      this.multiple = !selection.length
    },
    /** Add Button Operation */
    handleAdd() {
      this.reset()
      this.open = true
      this.title = "Add Notice"
    },
    /** Modify Button Operation */
    handleUpdate(row) {
      this.reset()
      const noticeId = row.noticeId || this.ids
      getNotice(noticeId).then(response => {
        this.form = response.data
        this.open = true
        this.title = "Modify Notice"
      })
    },
    /** Submit Button */
    submitForm: function() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          if (this.form.noticeId != undefined) {
            updateNotice(this.form).then(response => {
              this.$modal.msgSuccess("Updated successfully")
              this.open = false
              this.getList()
            })
          } else {
            addNotice(this.form).then(response => {
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
      const noticeIds = row.noticeId || this.ids
      this.$modal.confirm('Are you sure to delete notice ID "' + noticeIds + '" data items?').then(function() {
        return delNotice(noticeIds)
      }).then(() => {
        this.getList()
        this.$modal.msgSuccess("Deleted successfully")
      }).catch(() => {})
    }
  }
}
</script>
