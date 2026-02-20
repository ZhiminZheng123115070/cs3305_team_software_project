<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="Post Code" prop="postCode">
        <el-input
          v-model="queryParams.postCode"
          placeholder="Please enter post code"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="Post Name" prop="postName">
        <el-input
          v-model="queryParams.postName"
          placeholder="Please enter post name"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="Status" prop="status">
        <el-select v-model="queryParams.status" placeholder="Post Status" clearable>
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
          v-hasPermi="['system:post:add']"
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
          v-hasPermi="['system:post:edit']"
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
          v-hasPermi="['system:post:remove']"
        >Delete</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="warning"
          plain
          icon="el-icon-download"
          size="mini"
          @click="handleExport"
          v-hasPermi="['system:post:export']"
        >Export</el-button>
      </el-col>
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="postList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="Post ID" align="center" prop="postId" />
      <el-table-column label="Post Code" align="center" prop="postCode" />
      <el-table-column label="Post Name" align="center" prop="postName" />
      <el-table-column label="Post Order" align="center" prop="postSort" />
      <el-table-column label="Status" align="center" prop="status">
        <template slot-scope="scope">
          <dict-tag :options="dict.type.sys_normal_disable" :value="scope.row.status"/>
        </template>
      </el-table-column>
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
            v-hasPermi="['system:post:edit']"
          >Edit</el-button>
          <el-button
            size="mini"
            type="text"
            icon="el-icon-delete"
            @click="handleDelete(scope.row)"
            v-hasPermi="['system:post:remove']"
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

    <!-- Add or Modify Post Dialog -->
    <el-dialog :title="title" :visible.sync="open" width="500px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="80px">
        <el-form-item label="Post Name" prop="postName">
          <el-input v-model="form.postName" placeholder="Please enter post name" />
        </el-form-item>
        <el-form-item label="Post Code" prop="postCode">
          <el-input v-model="form.postCode" placeholder="Please enter code name" />
        </el-form-item>
        <el-form-item label="Post Order" prop="postSort">
          <el-input-number v-model="form.postSort" controls-position="right" :min="0" />
        </el-form-item>
        <el-form-item label="Post Status" prop="status">
          <el-radio-group v-model="form.status">
            <el-radio
              v-for="dict in dict.type.sys_normal_disable"
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
import { listPost, getPost, delPost, addPost, updatePost } from "@/api/system/post"

export default {
  name: "Post",
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
      // Post Table Data
      postList: [],
      // Popup Title
      title: "",
      // Whether to Show Popup
      open: false,
      // Query Parameters
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        postCode: undefined,
        postName: undefined,
        status: undefined
      },
      // Form Parameters
      form: {},
      // Form Validation
      rules: {
        postName: [
          { required: true, message: "Post name cannot be empty", trigger: "blur" }
        ],
        postCode: [
          { required: true, message: "Post code cannot be empty", trigger: "blur" }
        ],
        postSort: [
          { required: true, message: "Post order cannot be empty", trigger: "blur" }
        ]
      }
    }
  },
  created() {
    this.getList()
  },
  methods: {
    /** Query Post List */
    getList() {
      this.loading = true
      listPost(this.queryParams).then(response => {
        this.postList = response.rows
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
        postId: undefined,
        postCode: undefined,
        postName: undefined,
        postSort: 0,
        status: "0",
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
      this.resetForm("queryForm")
      this.handleQuery()
    },
    // Multi-select Selected Data
    handleSelectionChange(selection) {
      this.ids = selection.map(item => item.postId)
      this.single = selection.length!=1
      this.multiple = !selection.length
    },
    /** Add Button Operation */
    handleAdd() {
      this.reset()
      this.open = true
      this.title = "Add Post"
    },
    /** Modify Button Operation */
    handleUpdate(row) {
      this.reset()
      const postId = row.postId || this.ids
      getPost(postId).then(response => {
        this.form = response.data
        this.open = true
        this.title = "Modify Post"
      })
    },
    /** Submit Button */
    submitForm: function() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          if (this.form.postId != undefined) {
            updatePost(this.form).then(response => {
              this.$modal.msgSuccess("Updated successfully")
              this.open = false
              this.getList()
            })
          } else {
            addPost(this.form).then(response => {
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
      const postIds = row.postId || this.ids
      this.$modal.confirm('Are you sure to delete post ID "' + postIds + '" data items?').then(function() {
        return delPost(postIds)
      }).then(() => {
        this.getList()
        this.$modal.msgSuccess("Deleted successfully")
      }).catch(() => {})
    },
    /** Export Button Operation */
    handleExport() {
      this.download('system/post/export', {
        ...this.queryParams
      }, `post_${new Date().getTime()}.xlsx`)
    }
  }
}
</script>
