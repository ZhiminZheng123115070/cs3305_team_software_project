package com.ruoyi.quartz.domain;

import java.util.Date;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * Scheduled Task Log Table sys_job_log
 * 
 * @author ruoyi
 */
public class SysJobLog extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** ID */
    @Excel(name = "Log No.")
    private Long jobLogId;

    /** Task name */
    @Excel(name = "Task Name")
    private String jobName;

    /** Task group name */
    @Excel(name = "Task Group Name")
    private String jobGroup;

    /** Invoke target string */
    @Excel(name = "Invoke Target String")
    private String invokeTarget;

    /** Log information */
    @Excel(name = "Log Information")
    private String jobMessage;

    /** Execution status (0 normal 1 failed) */
    @Excel(name = "Execution Status", readConverterExp = "0=Normal,1=Failed")
    private String status;

    /** Exception information */
    @Excel(name = "Exception Information")
    private String exceptionInfo;

    /** Start time */
    private Date startTime;

    /** Stop time */
    private Date stopTime;

    public Long getJobLogId()
    {
        return jobLogId;
    }

    public void setJobLogId(Long jobLogId)
    {
        this.jobLogId = jobLogId;
    }

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

    public String getInvokeTarget()
    {
        return invokeTarget;
    }

    public void setInvokeTarget(String invokeTarget)
    {
        this.invokeTarget = invokeTarget;
    }

    public String getJobMessage()
    {
        return jobMessage;
    }

    public void setJobMessage(String jobMessage)
    {
        this.jobMessage = jobMessage;
    }

    public String getStatus()
    {
        return status;
    }

    public void setStatus(String status)
    {
        this.status = status;
    }

    public String getExceptionInfo()
    {
        return exceptionInfo;
    }

    public void setExceptionInfo(String exceptionInfo)
    {
        this.exceptionInfo = exceptionInfo;
    }

    public Date getStartTime()
    {
        return startTime;
    }

    public void setStartTime(Date startTime)
    {
        this.startTime = startTime;
    }
    
    public Date getStopTime()
    {
        return stopTime;
    }

    public void setStopTime(Date stopTime)
    {
        this.stopTime = stopTime;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this,ToStringStyle.MULTI_LINE_STYLE)
            .append("jobLogId", getJobLogId())
            .append("jobName", getJobName())
            .append("jobGroup", getJobGroup())
            .append("jobMessage", getJobMessage())
            .append("status", getStatus())
            .append("exceptionInfo", getExceptionInfo())
            .append("startTime", getStartTime())
            .append("stopTime", getStopTime())
            .toString();
    }
}
