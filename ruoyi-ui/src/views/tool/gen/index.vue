<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="68px">
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
          icon="el-icon-download"
          size="mini"
          :disabled="multiple"
          @click="handleGenTable"
          v-hasPermi="['tool:gen:code']"
        >Generate</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="primary"
          plain
          icon="el-icon-plus"
          size="mini"
          @click="openCreateTable"
          v-hasRole="['admin']"
        >Create</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="info"
          plain
          icon="el-icon-upload"
          size="mini"
          @click="openImportTable"
          v-hasPermi="['tool:gen:import']"
        >Import</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="success"
          plain
          icon="el-icon-edit"
          size="mini"
          :disabled="single"
          @click="handleEditTable"
          v-hasPermi="['tool:gen:edit']"
        >Modify</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="danger"
          plain
          icon="el-icon-delete"
          size="mini"
          :disabled="multiple"
          @click="handleDelete"
          v-hasPermi="['tool:gen:remove']"
        >Delete</el-button>
      </el-col>
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table ref="tables" v-loading="loading" :data="tableList" @selection-change="handleSelectionChange" :default-sort="defaultSort" @sort-change="handleSortChange" empty-text="No Data">
      <el-table-column type="selection" align="center" width="55"></el-table-column>
      <el-table-column label="No." type="index" width="50" align="center">
        <template slot-scope="scope">
          <span>{{(queryParams.pageNum - 1) * queryParams.pageSize + scope.$index + 1}}</span>
        </template>
      </el-table-column>
      <el-table-column label="Table Name" align="center" prop="tableName" :show-overflow-tooltip="true" width="120" />
      <el-table-column label="Table Description" align="center" prop="tableComment" :show-overflow-tooltip="true" width="120" />
      <el-table-column label="Entity" align="center" prop="className" :show-overflow-tooltip="true" width="120" />
      <el-table-column label="Creation Time" align="center" prop="createTime" sortable="custom" :sort-orders="['descending', 'ascending']" width="160" />
      <el-table-column label="Update Time" align="center" prop="updateTime" sortable="custom" :sort-orders="['descending', 'ascending']" width="160" />
      <el-table-column label="Operation" align="center" class-name="small-padding fixed-width">
        <template slot-scope="scope">
          <el-button
            type="text"
            size="small"
            icon="el-icon-view"
            @click="handlePreview(scope.row)"
            v-hasPermi="['tool:gen:preview']"
          >Preview</el-button>
          <el-button
            type="text"
            size="small"
            icon="el-icon-edit"
            @click="handleEditTable(scope.row)"
            v-hasPermi="['tool:gen:edit']"
          >Edit</el-button>
          <el-button
            type="text"
            size="small"
            icon="el-icon-delete"
            @click="handleDelete(scope.row)"
            v-hasPermi="['tool:gen:remove']"
          >Delete</el-button>
          <el-button
            type="text"
            size="small"
            icon="el-icon-refresh"
            @click="handleSynchDb(scope.row)"
            v-hasPermi="['tool:gen:edit']"
          >Synchronize</el-button>
          <el-button
            type="text"
            size="small"
            icon="el-icon-download"
            @click="handleGenTable(scope.row)"
            v-hasPermi="['tool:gen:code']"
          >Generate Code</el-button>
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
    <!-- Preview Interface -->
    <el-dialog :title="preview.title" :visible.sync="preview.open" width="80%" top="5vh" append-to-body class="scrollbar">
      <el-tabs v-model="preview.activeName">
        <el-tab-pane
          v-for="(value, key) in preview.data"
          :label="key.substring(key.lastIndexOf('/')+1,key.indexOf('.vm'))"
          :name="key.substring(key.lastIndexOf('/')+1,key.indexOf('.vm'))"
          :key="key"
        >
          <el-link :underline="false" icon="el-icon-document-copy" v-clipboard:copy="value" v-clipboard:success="clipboardSuccess" style="float:right">Copy</el-link>
          <pre><code class="hljs" v-html="highlightedCode(value, key)"></code></pre>
        </el-tab-pane>
      </el-tabs>
    </el-dialog>
    <import-table ref="import" @ok="handleQuery" />
    <create-table ref="create" @ok="handleQuery" />
  </div>
</template>

<script>
import { listTable, previewTable, delTable, genCode, synchDb } from "@/api/tool/gen"
import importTable from "./importTable"
import createTable from "./createTable"
import hljs from "highlight.js/lib/highlight"
import "highlight.js/styles/github-gist.css"
hljs.registerLanguage("java", require("highlight.js/lib/languages/java"))
hljs.registerLanguage("xml", require("highlight.js/lib/languages/xml"))
hljs.registerLanguage("html", require("highlight.js/lib/languages/xml"))
hljs.registerLanguage("vue", require("highlight.js/lib/languages/xml"))
hljs.registerLanguage("javascript", require("highlight.js/lib/languages/javascript"))
hljs.registerLanguage("sql", require("highlight.js/lib/languages/sql"))

export default {
  name: "Gen",
  components: { importTable, createTable },
  data() {
    return {
      // Overlay
      loading: true,
      // Unique Identifier
      uniqueId: "",
      // Selected Array
      ids: [],
      // Selected Table Array
      tableNames: [],
      // Not Single Disabled
      single: true,
      // Not Multiple Disabled
      multiple: true,
      // Show Search Conditions
      showSearch: true,
      // Total Count
      total: 0,
      // Table Data
      tableList: [],
      // Date Range
      dateRange: "",
      // Default Sort
      defaultSort: { prop: "createTime", order: "descending" },
      // Query Parameters
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        tableName: undefined,
        tableComment: undefined
      },
      // Preview Parameters
      preview: {
        open: false,
        title: "Code Preview",
        data: {},
        activeName: "domain.java"
      }
    }
  },
  created() {
    this.queryParams.orderByColumn = this.defaultSort.prop
    this.queryParams.isAsc = this.defaultSort.order
    this.getList()
  },
  activated() {
    const time = this.$route.query.t
    if (time != null && time != this.uniqueId) {
      this.uniqueId = time
      this.queryParams.pageNum = Number(this.$route.query.pageNum)
      this.getList()
    }
  },
  methods: {
    /** Query Table Collection */
    getList() {
      this.loading = true
      listTable(this.addDateRange(this.queryParams, this.dateRange)).then(response => {
          this.tableList = response.rows
          this.total = response.total
          this.loading = false
        }
      )
    },
    /** Search Button Operation */
    handleQuery() {
      this.queryParams.pageNum = 1
      this.getList()
    },
    /** Generate Code Operation */
    handleGenTable(row) {
      const tableNames = row.tableName || this.tableNames
      if (tableNames == "") {
        this.$modal.msgError("Please select data to generate")
        return
      }
      if(row.genType === "1") {
        genCode(row.tableName).then(response => {
          this.$modal.msgSuccess("Successfully generated to custom path: " + row.genPath)
        })
      } else {
        const zipName = Array.isArray(tableNames) ? "ruoyi.zip" : tableNames + ".zip"
        this.$download.zip("/tool/gen/batchGenCode?tables=" + tableNames, zipName)
      }
    },
    /** Synchronize Database Operation */
    handleSynchDb(row) {
      const tableName = row.tableName
      this.$modal.confirm('Confirm to force synchronize "' + tableName + '" table structure?').then(function() {
        return synchDb(tableName)
      }).then(() => {
        this.$modal.msgSuccess("Synchronized successfully")
      }).catch(() => {})
    },
    /** Open Import Table Dialog */
    openImportTable() {
      this.$refs.import.show()
    },
    /** Open Create Table Dialog */
    openCreateTable() {
      this.$refs.create.show()
    },
    /** Reset Button Operation */
    resetQuery() {
      this.dateRange = []
      this.resetForm("queryForm")
      this.queryParams.pageNum = 1
      this.$refs.tables.sort(this.defaultSort.prop, this.defaultSort.order)
    },
    /** Preview Button */
    handlePreview(row) {
      previewTable(row.tableId).then(response => {
        this.preview.data = response.data
        this.preview.open = true
        this.preview.activeName = "domain.java"
      })
    },
    /** Highlight Display */
    highlightedCode(code, key) {
      const vmName = key.substring(key.lastIndexOf("/") + 1, key.indexOf(".vm"))
      var language = vmName.substring(vmName.indexOf(".") + 1, vmName.length)
      const result = hljs.highlight(language, code || "", true)
      return result.value || '&nbsp;'
    },
    /** Copy Code Success */
    clipboardSuccess() {
      this.$modal.msgSuccess("Copied successfully")
    },
    // Multi-select Selected Data
    handleSelectionChange(selection) {
      this.ids = selection.map(item => item.tableId)
      this.tableNames = selection.map(item => item.tableName)
      this.single = selection.length != 1
      this.multiple = !selection.length
    },
    /** Sort Trigger Event */
    handleSortChange(column, prop, order) {
      this.queryParams.orderByColumn = column.prop
      this.queryParams.isAsc = column.order
      this.getList()
    },
    /** Modify Button Operation */
    handleEditTable(row) {
      const tableId = row.tableId || this.ids[0]
      const tableName = row.tableName || this.tableNames[0]
      const params = { pageNum: this.queryParams.pageNum }
      this.$tab.openPage("Modify [" + tableName + "] Generation Configuration", '/tool/gen-edit/index/' + tableId, params)
    },
    /** Delete Button Operation */
    handleDelete(row) {
      const tableIds = row.tableId || this.ids
      this.$modal.confirm('Are you sure to delete table ID "' + tableIds + '" data items?').then(function() {
        return delTable(tableIds)
      }).then(() => {
        this.getList()
        this.$modal.msgSuccess("Deleted successfully")
      }).catch(() => {})
    }
  }
}
</script>
