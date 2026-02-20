package com.ruoyi.quartz.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.quartz.domain.SysJobLog;
import com.ruoyi.quartz.mapper.SysJobLogMapper;
import com.ruoyi.quartz.service.ISysJobLogService;

/**
 * Scheduled Task Log Information Service Layer
 * 
 * @author ruoyi
 */
@Service
public class SysJobLogServiceImpl implements ISysJobLogService
{
    @Autowired
    private SysJobLogMapper jobLogMapper;

    /**
     * Get quartz scheduler log scheduled tasks
     * 
     * @param jobLog Scheduling log information
     * @return Scheduled task log collection
     */
    @Override
    public List<SysJobLog> selectJobLogList(SysJobLog jobLog)
    {
        return jobLogMapper.selectJobLogList(jobLog);
    }

    /**
     * Query scheduling information by scheduled task log ID
     * 
     * @param jobLogId Scheduled task log ID
     * @return Scheduled task log object information
     */
    @Override
    public SysJobLog selectJobLogById(Long jobLogId)
    {
        return jobLogMapper.selectJobLogById(jobLogId);
    }

    /**
     * Add task log
     * 
     * @param jobLog Scheduling log information
     */
    @Override
    public void addJobLog(SysJobLog jobLog)
    {
        jobLogMapper.insertJobLog(jobLog);
    }

    /**
     * Batch delete scheduling log information
     * 
     * @param logIds Data IDs to delete
     * @return Result
     */
    @Override
    public int deleteJobLogByIds(Long[] logIds)
    {
        return jobLogMapper.deleteJobLogByIds(logIds);
    }

    /**
     * Delete task log
     * 
     * @param jobId Scheduling log ID
     */
    @Override
    public int deleteJobLogById(Long jobId)
    {
        return jobLogMapper.deleteJobLogById(jobId);
    }

    /**
     * Clear task log
     */
    @Override
    public void cleanJobLog()
    {
        jobLogMapper.cleanJobLog();
    }
}
