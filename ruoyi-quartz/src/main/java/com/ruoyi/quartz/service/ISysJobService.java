package com.ruoyi.quartz.service;

import java.util.List;
import org.quartz.SchedulerException;
import com.ruoyi.common.exception.job.TaskException;
import com.ruoyi.quartz.domain.SysJob;

/**
 * Scheduled Task Scheduling Information Service Layer
 * 
 * @author ruoyi
 */
public interface ISysJobService
{
    /**
     * Get quartz scheduler scheduled tasks
     * 
     * @param job Scheduling information
     * @return Scheduled task collection
     */
    public List<SysJob> selectJobList(SysJob job);

    /**
     * Query scheduling information by scheduled task ID
     * 
     * @param jobId Scheduled task ID
     * @return Scheduled task object information
     */
    public SysJob selectJobById(Long jobId);

    /**
     * Pause task
     * 
     * @param job Scheduling information
     * @return Result
     */
    public int pauseJob(SysJob job) throws SchedulerException;

    /**
     * Resume task
     * 
     * @param job Scheduling information
     * @return Result
     */
    public int resumeJob(SysJob job) throws SchedulerException;

    /**
     * After deleting task, the corresponding trigger will also be deleted
     * 
     * @param job Scheduling information
     * @return Result
     */
    public int deleteJob(SysJob job) throws SchedulerException;

    /**
     * Batch delete scheduling information
     * 
     * @param jobIds Task IDs to delete
     * @return Result
     */
    public void deleteJobByIds(Long[] jobIds) throws SchedulerException;

    /**
     * Task scheduling status modification
     * 
     * @param job Scheduling information
     * @return Result
     */
    public int changeStatus(SysJob job) throws SchedulerException;

    /**
     * Run task immediately
     * 
     * @param job Scheduling information
     * @return Result
     */
    public boolean run(SysJob job) throws SchedulerException;

    /**
     * Add task
     * 
     * @param job Scheduling information
     * @return Result
     */
    public int insertJob(SysJob job) throws SchedulerException, TaskException;

    /**
     * Update task
     * 
     * @param job Scheduling information
     * @return Result
     */
    public int updateJob(SysJob job) throws SchedulerException, TaskException;

    /**
     * Validate if cron expression is valid
     * 
     * @param cronExpression Expression
     * @return Result
     */
    public boolean checkCronExpressionIsValid(String cronExpression);
}
