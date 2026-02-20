package com.ruoyi.quartz.domain;

import java.util.Date;
import javax.validation.constraints.NotBlank;
import javax.validation.constraints.Size;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.annotation.Excel.ColumnType;
import com.ruoyi.common.constant.ScheduleConstants;
import com.ruoyi.common.core.domain.BaseEntity;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.quartz.util.CronUtils;

/**
 * Scheduled Task Table sys_job
 * 
 * @author ruoyi
 */
public class SysJob extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** Task ID */
    @Excel(name = "Task No.", cellType = ColumnType.NUMERIC)
    private Long jobId;

    /** Task name */
    @Excel(name = "Task Name")
    private String jobName;

    /** Task group name */
    @Excel(name = "Task Group Name")
    private String jobGroup;

    /** Invoke target string */
    @Excel(name = "Invoke Target String")
    private String invokeTarget;

    /** Cron execution expression */
    @Excel(name = "Execution Expression ")
    private String cronExpression;

    /** Cron plan policy */
    @Excel(name = "Plan Policy ", readConverterExp = "0=Default,1=Execute Immediately,2=Execute Once,3=Do Not Execute Immediately")
    private String misfirePolicy = ScheduleConstants.MISFIRE_DEFAULT;

    /** Whether to execute concurrently (0 allow 1 forbid) */
    @Excel(name = "Concurrent Execution", readConverterExp = "0=Allow,1=Forbid")
    private String concurrent;

    /** Task status (0 normal 1 pause) */
    @Excel(name = "Task Status", readConverterExp = "0=Normal,1=Pause")
    private String status;

    public Long getJobId()
    {
        return jobId;
    }

    public void setJobId(Long jobId)
    {
        this.jobId = jobId;
    }

    @NotBlank(message = "Task name cannot be empty")
    @Size(min = 0, max = 64, message = "Task name cannot exceed 64 characters")
    public String getJobName()
    {
        return jobName;
    }

    public void setJobName(String jobName)
    {
        this.jobName = jobName;
    }

    public String getJobGroup()
    {
        return jobGroup;
    }

    public void setJobGroup(String jobGroup)
    {
        this.jobGroup = jobGroup;
    }

    @NotBlank(message = "Invoke target string cannot be empty")
    @Size(min = 0, max = 500, message = "Invoke target string length cannot exceed 500 characters")
    public String getInvokeTarget()
    {
        return invokeTarget;
    }

    public void setInvokeTarget(String invokeTarget)
    {
        this.invokeTarget = invokeTarget;
    }

    @NotBlank(message = "Cron execution expression cannot be empty")
    @Size(min = 0, max = 255, message = "Cron execution expression cannot exceed 255 characters")
    public String getCronExpression()
    {
        return cronExpression;
    }

    public void setCronExpression(String cronExpression)
    {
        this.cronExpression = cronExpression;
    }

    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    public Date getNextValidTime()
    {
        if (StringUtils.isNotEmpty(cronExpression))
        {
            return CronUtils.getNextExecution(cronExpression);
        }
        return null;
    }

    public String getMisfirePolicy()
    {
        return misfirePolicy;
    }

    public void setMisfirePolicy(String misfirePolicy)
    {
        this.misfirePolicy = misfirePolicy;
    }

    public String getConcurrent()
    {
        return concurrent;
    }

    public void setConcurrent(String concurrent)
    {
        this.concurrent = concurrent;
    }

    public String getStatus()
    {
        return status;
    }

    public void setStatus(String status)
    {
        this.status = status;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this,ToStringStyle.MULTI_LINE_STYLE)
            .append("jobId", getJobId())
            .append("jobName", getJobName())
            .append("jobGroup", getJobGroup())
            .append("cronExpression", getCronExpression())
            .append("nextValidTime", getNextValidTime())
            .append("misfirePolicy", getMisfirePolicy())
            .append("concurrent", getConcurrent())
            .append("status", getStatus())
            .append("createBy", getCreateBy())
            .append("createTime", getCreateTime())
            .append("updateBy", getUpdateBy())
            .append("updateTime", getUpdateTime())
            .append("remark", getRemark())
            .toString();
    }
}
