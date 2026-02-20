package com.ruoyi.quartz.mapper;

import java.util.List;
import com.ruoyi.quartz.domain.SysJobLog;

/**
 * Scheduled Task Log Information Data Layer
 * 
 * @author ruoyi
 */
public interface SysJobLogMapper
{
    /**
     * Get quartz scheduler log scheduled tasks
     * 
     * @param jobLog Scheduling log information
     * @return Scheduled task log collection
     */
    public List<SysJobLog> selectJobLogList(SysJobLog jobLog);

    /**
     * Query all scheduled task logs
     *
     * @return Scheduled task log list
     */
    public List<SysJobLog> selectJobLogAll();

    /**
     * Query scheduling information by scheduled task log ID
     * 
     * @param jobLogId Scheduled task log ID
     * @return Scheduled task log object information
     */
    public SysJobLog selectJobLogById(Long jobLogId);

    /**
     * Add task log
     * 
     * @param jobLog Scheduling log information
     * @return Result
     */
    public int insertJobLog(SysJobLog jobLog);

    /**
     * Batch delete scheduling log information
     * 
     * @param logIds Data IDs to delete
     * @return Result
     */
    public int deleteJobLogByIds(Long[] logIds);

    /**
     * Delete task log
     * 
     * @param jobId Scheduling log ID
     * @return Result
     */
    public int deleteJobLogById(Long jobId);

    /**
     * Clear task log
     */
    public void cleanJobLog();
}
