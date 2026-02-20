<template>
  <!-- Import Table -->
  <el-dialog title="Import Table" :visible.sync="visible" width="800px" top="5vh" append-to-body>
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true">
      <el-form-item label="Table Name" prop="tableName">
        <el-input
          v-model="queryParams.tableName"
          placeholder="Please enter table name"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="Table Description" prop="tableComment">
        <el-input
          v-model="queryParams.tableComment"
          placeholder="Please enter table description"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">Search</el-button>
        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">Reset</el-button>
      </el-form-item>
    </el-form>
    <el-row>
      <el-table @row-click="clickRow" ref="table" :data="dbTableList" @selection-change="handleSelectionChange" height="260px" empty-text="No Data">
        <el-table-column type="selection" width="55"></el-table-column>
        <el-table-column prop="tableName" label="Table Name" :show-overflow-tooltip="true"></el-table-column>
        <el-table-column prop="tableComment" label="Table Description" :show-overflow-tooltip="true"></el-table-column>
        <el-table-column prop="createTime" label="Creation Time"></el-table-column>
        <el-table-column prop="updateTime" label="Update Time"></el-table-column>
      </el-table>
      <pagination
        v-show="total>0"
        :total="total"
        :page.sync="queryParams.pageNum"
        :limit.sync="queryParams.pageSize"
        @pagination="getList"
      />
    </el-row>
    <div slot="footer" class="dialog-footer">
      <el-button type="primary" @click="handleImportTable">Confirm</el-button>
      <el-button @click="visible = false">Cancel</el-button>
    </div>
  </el-dialog>
</template>

<script>
import { listDbTable, importTable } from "@/api/tool/gen"
export default {
  data() {
    return {
      // Overlay
      visible: false,
      // Selected Array Values
      tables: [],
      // Total Count
      total: 0,
      // Table Data
      dbTableList: [],
      // Query Parameters
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        tableName: undefined,
        tableComment: undefined
      }
    }
  },
  methods: {
    // Show Dialog
    show() {
      this.getList()
      this.visible = true
    },
    clickRow(row) {
      this.$refs.table.toggleRowSelection(row)
    },
    // Checkbox Selected Data
    handleSelectionChange(selection) {
      this.tables = selection.map(item => item.tableName)
    },
    // Query Table Data
    getList() {
      listDbTable(this.queryParams).then(res => {
        if (res.code === 200) {
          this.dbTableList = res.rows
          this.total = res.total
        }
      })
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
    /** Import Button Operation */
    handleImportTable() {
      const tableNames = this.tables.join(",")
      if (tableNames == "") {
        this.$modal.msgError("Please select tables to import")
        return
      }
      importTable({ tables: tableNames }).then(res => {
        this.$modal.msgSuccess(res.msg)
        if (res.code === 200) {
          this.visible = false
          this.$emit("ok")
        }
      })
    }
  }
}
</script>
