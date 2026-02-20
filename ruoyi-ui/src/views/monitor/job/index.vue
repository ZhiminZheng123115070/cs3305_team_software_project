<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="Job Name" prop="jobName">
        <el-input
          v-model="queryParams.jobName"
          placeholder="Please enter job name"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="Job Group" prop="jobGroup">
        <el-select v-model="queryParams.jobGroup" placeholder="Please select job group" clearable>
          <el-option
            v-for="dict in dict.type.sys_job_group"
            :key="dict.value"
            :label="dict.label"
            :value="dict.value"
          />
        </el-select>
      </el-form-item>
      <el-form-item label="Job Status" prop="status">
        <el-select v-model="queryParams.status" placeholder="Please select job status" clearable>
          <el-option
            v-for="dict in dict.type.sys_job_status"
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
          v-hasPermi="['monitor:job:add']"
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
          v-hasPermi="['monitor:job:edit']"
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
          v-hasPermi="['monitor:job:remove']"
        >Delete</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="warning"
          plain
          icon="el-icon-download"
          size="mini"
          @click="handleExport"
          v-hasPermi="['monitor:job:export']"
        >Export</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="info"
          plain
          icon="el-icon-s-operation"
          size="mini"
          @click="handleJobLog"
          v-hasPermi="['monitor:job:query']"
        >Log</el-button>
      </el-col>
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="jobList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="Job ID" width="100" align="center" prop="jobId" />
      <el-table-column label="Job Name" align="center" prop="jobName" :show-overflow-tooltip="true" />
      <el-table-column label="Job Group" align="center" prop="jobGroup">
        <template slot-scope="scope">
          <dict-tag :options="dict.type.sys_job_group" :value="scope.row.jobGroup"/>
        </template>
      </el-table-column>
      <el-table-column label="Invoke Target String" align="center" prop="invokeTarget" :show-overflow-tooltip="true" />
      <el-table-column label="Cron Expression" align="center" prop="cronExpression" :show-overflow-tooltip="true" />
      <el-table-column label="Status" align="center">
        <template slot-scope="scope">
          <el-switch
            v-model="scope.row.status"
            active-value="0"
            inactive-value="1"
            @change="handleStatusChange(scope.row)"
          ></el-switch>
        </template>
      </el-table-column>
      <el-table-column label="Operation" align="center" class-name="small-padding fixed-width">
        <template slot-scope="scope">
          <el-button
            size="mini"
            type="text"
            icon="el-icon-edit"
            @click="handleUpdate(scope.row)"
            v-hasPermi="['monitor:job:edit']"
          >Modify</el-button>
          <el-button
            size="mini"
            type="text"
            icon="el-icon-delete"
            @click="handleDelete(scope.row)"
            v-hasPermi="['monitor:job:remove']"
          >Delete</el-button>
          <el-dropdown size="mini" @command="(command) => handleCommand(command, scope.row)" v-hasPermi="['monitor:job:changeStatus', 'monitor:job:query']">
            <el-button size="mini" type="text" icon="el-icon-d-arrow-right">More</el-button>
            <el-dropdown-menu slot="dropdown">
              <el-dropdown-item command="handleRun" icon="el-icon-caret-right"
                v-hasPermi="['monitor:job:changeStatus']">Execute Once</el-dropdown-item>
              <el-dropdown-item command="handleView" icon="el-icon-view"
                v-hasPermi="['monitor:job:query']">Job Details</el-dropdown-item>
              <el-dropdown-item command="handleJobLog" icon="el-icon-s-operation"
                v-hasPermi="['monitor:job:query']">Scheduler Log</el-dropdown-item>
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

    <!-- Add or Modify Scheduled Task Dialog -->
    <el-dialog :title="title" :visible.sync="open" width="800px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="120px">
        <el-row>
          <el-col :span="12">
            <el-form-item label="Job Name" prop="jobName">
              <el-input v-model="form.jobName" placeholder="Please enter job name" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="Job Group" prop="jobGroup">
              <el-select v-model="form.jobGroup" placeholder="Please select job group">
                <el-option
                  v-for="dict in dict.type.sys_job_group"
                  :key="dict.value"
                  :label="dict.label"
                  :value="dict.value"
                ></el-option>
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="24">
            <el-form-item prop="invokeTarget">
              <span slot="label">
                Invoke Method
                <el-tooltip placement="top">
                  <div slot="content">
                    Bean invocation example: ryTask.ryParams('ry')
                    <br />Class invocation example: com.ruoyi.quartz.task.RyTask.ryParams('ry')
                    <br />Parameter description: supports string, boolean, long, float, integer
                  </div>
                  <i class="el-icon-question"></i>
                </el-tooltip>
              </span>
              <el-input v-model="form.invokeTarget" placeholder="Please enter invoke target string" />
            </el-form-item>
          </el-col>
          <el-col :span="24">
            <el-form-item label="Cron Expression" prop="cronExpression">
              <el-input v-model="form.cronExpression" placeholder="Please enter cron expression">
                <template slot="append">
                  <el-button type="primary" @click="handleShowCron">
                    Generate Expression
                    <i class="el-icon-time el-icon--right"></i>
                  </el-button>
                </template>
              </el-input>
            </el-form-item>
          </el-col>
          <el-col :span="24" v-if="form.jobId !== undefined">
            <el-form-item label="Status">
              <el-radio-group v-model="form.status">
                <el-radio
                  v-for="dict in dict.type.sys_job_status"
                  :key="dict.value"
                  :label="dict.value"
                >{{dict.label}}</el-radio>
              </el-radio-group>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="Execution Policy" prop="misfirePolicy">
              <el-radio-group v-model="form.misfirePolicy" size="small">
                <el-radio-button label="1">Execute Immediately</el-radio-button>
                <el-radio-button label="2">Execute Once</el-radio-button>
                <el-radio-button label="3">Abandon Execution</el-radio-button>
              </el-radio-group>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="Concurrent" prop="concurrent">
              <el-radio-group v-model="form.concurrent" size="small">
                <el-radio-button label="0">Allow</el-radio-button>
                <el-radio-button label="1">Forbid</el-radio-button>
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

    <el-dialog title="Cron Expression Generator" :visible.sync="openCron" append-to-body destroy-on-close class="scrollbar">
      <crontab @hide="openCron=false" @fill="crontabFill" :expression="expression"></crontab>
    </el-dialog>

    <!-- Job Details -->
    <el-dialog title="Job Details" :visible.sync="openView" width="700px" append-to-body>
      <el-form ref="form" :model="form" label-width="120px" size="mini">
        <el-row>
          <el-col :span="12">
            <el-form-item label="Job ID:">{{ form.jobId }}</el-form-item>
            <el-form-item label="Job Name:">{{ form.jobName }}</el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="Job Group:">{{ jobGroupFormat(form) }}</el-form-item>
            <el-form-item label="Creation Time:">{{ form.createTime }}</el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="Cron Expression:">{{ form.cronExpression }}</el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="Next Execution Time:">{{ parseTime(form.nextValidTime) }}</el-form-item>
          </el-col>
          <el-col :span="24">
            <el-form-item label="Invoke Target Method:">{{ form.invokeTarget }}</el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="Job Status:">
              <div v-if="form.status == 0">Normal</div>
              <div v-else-if="form.status == 1">Paused</div>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="Concurrent:">
              <div v-if="form.concurrent == 0">Allow</div>
              <div v-else-if="form.concurrent == 1">Forbid</div>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="Execution Policy:">
              <div v-if="form.misfirePolicy == 0">Default Policy</div>
              <div v-else-if="form.misfirePolicy == 1">Execute Immediately</div>
              <div v-else-if="form.misfirePolicy == 2">Execute Once</div>
              <div v-else-if="form.misfirePolicy == 3">Abandon Execution</div>
            </el-form-item>
          </el-col>
        </el-row>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="openView = false">Close</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { listJob, getJob, delJob, addJob, updateJob, runJob, changeJobStatus } from "@/api/monitor/job"
import Crontab from '@/components/Crontab'

export default {
  components: { Crontab },
  name: "Job",
  dicts: ['sys_job_group', 'sys_job_status'],
  data() {
    return {
      // Overlay
      loading: true,
      // Selected Array
      ids: [],
      // Disable for Single Selection
      single: true,
      // Disable for Multiple Selection
      multiple: true,
      // Show Search Conditions
      showSearch: true,
      // Total Count
      total: 0,
      // Scheduled Task Table Data
      jobList: [],
      // Dialog Title
      title: "",
      // Whether to Show Dialog
      open: false,
      // Whether to Show Details Dialog
      openView: false,
      // Whether to Show Cron Expression Dialog
      openCron: false,
      // Expression to Pass
      expression: "",
      // Query Parameters
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        jobName: undefined,
        jobGroup: undefined,
        status: undefined
      },
      // Form Parameters
      form: {},
      // Form Validation
      rules: {
        jobName: [
          { required: true, message: "Job name cannot be empty", trigger: "blur" }
        ],
        invokeTarget: [
          { required: true, message: "Invoke target string cannot be empty", trigger: "blur" }
        ],
        cronExpression: [
          { required: true, message: "Cron expression cannot be empty", trigger: "blur" }
        ]
      }
    }
  },
  created() {
    this.getList()
  },
  methods: {
    /** Query Scheduled Task List */
    getList() {
      this.loading = true
      listJob(this.queryParams).then(response => {
        this.jobList = response.rows
        this.total = response.total
        this.loading = false
      })
    },
    // Job Group Dictionary Translation
    jobGroupFormat(row, column) {
      return this.selectDictLabel(this.dict.type.sys_job_group, row.jobGroup)
    },
    // Cancel Button
    cancel() {
      this.open = false
      this.reset()
    },
    // Form Reset
    reset() {
      this.form = {
        jobId: undefined,
        jobName: undefined,
        jobGroup: undefined,
        invokeTarget: undefined,
        cronExpression: undefined,
        misfirePolicy: 1,
        concurrent: 1,
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
    // Checkbox Selected Data
    handleSelectionChange(selection) {
      this.ids = selection.map(item => item.jobId)
      this.single = selection.length != 1
      this.multiple = !selection.length
    },
    // More Operations Trigger
    handleCommand(command, row) {
      switch (command) {
        case "handleRun":
          this.handleRun(row)
          break
        case "handleView":
          this.handleView(row)
          break
        case "handleJobLog":
          this.handleJobLog(row)
          break
        default:
          break
      }
    },
    // Job Status Change
    handleStatusChange(row) {
      let text = row.status === "0" ? "Enable" : "Disable"
      this.$modal.confirm('Are you sure to "' + text + '" job "' + row.jobName + '"?').then(function() {
        return changeJobStatus(row.jobId, row.status)
      }).then(() => {
        this.$modal.msgSuccess(text + " successful")
      }).catch(function() {
        row.status = row.status === "0" ? "1" : "0"
      })
    },
    /* Execute Once Immediately */
    handleRun(row) {
      this.$modal.confirm('Are you sure to execute job "' + row.jobName + '" once immediately?').then(function() {
        return runJob(row.jobId, row.jobGroup)
      }).then(() => {
        this.$modal.msgSuccess("Execution successful")
      }).catch(() => {})
    },
    /** Job Details */
    handleView(row) {
      getJob(row.jobId).then(response => {
        this.form = response.data
        this.openView = true
      })
    },
    /** Cron Expression Button Operation */
    handleShowCron() {
      this.expression = this.form.cronExpression
      this.openCron = true
    },
    /** Return Value After Confirmation */
    crontabFill(value) {
      this.form.cronExpression = value
    },
    /** Task Log List Query */
    handleJobLog(row) {
      const jobId = row.jobId || 0
      this.$router.push('/monitor/job-log/index/' + jobId)
    },
    /** Add Button Operation */
    handleAdd() {
      this.reset()
      this.open = true
      this.title = "Add Task"
    },
    /** Modify Button Operation */
    handleUpdate(row) {
      this.reset()
      const jobId = row.jobId || this.ids
      getJob(jobId).then(response => {
        this.form = response.data
        this.open = true
        this.title = "Modify Task"
      })
    },
    /** Submit Button */
    submitForm: function() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          if (this.form.jobId != undefined) {
            updateJob(this.form).then(response => {
              this.$modal.msgSuccess("Modification successful")
              this.open = false
              this.getList()
            })
          } else {
            addJob(this.form).then(response => {
              this.$modal.msgSuccess("Add successful")
              this.open = false
              this.getList()
            })
          }
        }
      })
    },
    /** Delete Button Operation */
    handleDelete(row) {
      const jobIds = row.jobId || this.ids
      this.$modal.confirm('Are you sure to delete scheduled task ID "' + jobIds + '"?').then(function() {
        return delJob(jobIds)
      }).then(() => {
        this.getList()
        this.$modal.msgSuccess("Delete successful")
      }).catch(() => {})
    },
    /** Export Button Operation */
    handleExport() {
      this.download('monitor/job/export', {
        ...this.queryParams
      }, `job_${new Date().getTime()}.xlsx`)
    }
  }
}
</script>
