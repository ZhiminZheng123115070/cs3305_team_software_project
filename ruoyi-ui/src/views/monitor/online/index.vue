<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" label-width="68px">
      <el-form-item label="Login Address" prop="ipaddr">
        <el-input
          v-model="queryParams.ipaddr"
          placeholder="Please enter login address"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="User Name" prop="userName">
        <el-input
          v-model="queryParams.userName"
          placeholder="Please enter user name"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">Search</el-button>
        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">Reset</el-button>
      </el-form-item>

    </el-form>
    <el-table
      v-loading="loading"
      :data="list.slice((pageNum-1)*pageSize,pageNum*pageSize)"
      style="width: 100%;"
    >
      <el-table-column label="No." type="index" align="center">
        <template slot-scope="scope">
          <span>{{(pageNum - 1) * pageSize + scope.$index + 1}}</span>
        </template>
      </el-table-column>
      <el-table-column label="Session ID" align="center" prop="tokenId" :show-overflow-tooltip="true" />
      <el-table-column label="Login Name" align="center" prop="userName" :show-overflow-tooltip="true" />
      <el-table-column label="Department Name" align="center" prop="deptName" />
      <el-table-column label="Host" align="center" prop="ipaddr" :show-overflow-tooltip="true" />
      <el-table-column label="Login Location" align="center" prop="loginLocation" :show-overflow-tooltip="true" />
      <el-table-column label="Browser" align="center" prop="browser" />
      <el-table-column label="Operating System" align="center" prop="os" />
      <el-table-column label="Login Time" align="center" prop="loginTime" width="180">
        <template slot-scope="scope">
          <span>{{ parseTime(scope.row.loginTime) }}</span>
        </template>
      </el-table-column>
      <el-table-column label="Operation" align="center" class-name="small-padding fixed-width">
        <template slot-scope="scope">
          <el-button
            size="mini"
            type="text"
            icon="el-icon-delete"
            @click="handleForceLogout(scope.row)"
            v-hasPermi="['monitor:online:forceLogout']"
          >Force Logout</el-button>
        </template>
      </el-table-column>
    </el-table>

    <pagination v-show="total>0" :total="total" :page.sync="pageNum" :limit.sync="pageSize" />
  </div>
</template>

<script>
import { list, forceLogout } from "@/api/monitor/online"

export default {
  name: "Online",
  data() {
    return {
      // Overlay
      loading: true,
      // Total Count
      total: 0,
      // Table Data
      list: [],
      pageNum: 1,
      pageSize: 10,
      // Query Parameters
      queryParams: {
        ipaddr: undefined,
        userName: undefined
      }
    }
  },
  created() {
    this.getList()
  },
  methods: {
    /** Query Online User List */
    getList() {
      this.loading = true
      list(this.queryParams).then(response => {
        this.list = response.rows
        this.total = response.total
        this.loading = false
      })
    },
    /** Search Button Operation */
    handleQuery() {
      this.pageNum = 1
      this.getList()
    },
    /** Reset Button Operation */
    resetQuery() {
      this.resetForm("queryForm")
      this.handleQuery()
    },
    /** Force Logout Button Operation */
    handleForceLogout(row) {
      this.$modal.confirm('Are you sure to force logout user "' + row.userName + '"?').then(function() {
        return forceLogout(row.tokenId)
      }).then(() => {
        this.getList()
        this.$modal.msgSuccess("Force logout successful")
      }).catch(() => {})
    }
  }
}
</script>

