package com.ruoyi.quartz.mapper;

import java.util.List;
import com.ruoyi.quartz.domain.SysJob;

/**
 * Scheduled Task Information Data Layer
 * 
 * @author ruoyi
 */
public interface SysJobMapper
{
    /**
     * Query scheduled task log collection
     * 
     * @param job Scheduling information
     * @return Operation log collection
     */
    public List<SysJob> selectJobList(SysJob job);

    /**
     * Query all scheduled tasks
     * 
     * @return Scheduled task list
     */
    public List<SysJob> selectJobAll();

    /**
     * Query scheduled task information by scheduling ID
     * 
     * @param jobId Scheduling ID
     * @return Role object information
     */
    public SysJob selectJobById(Long jobId);

    /**
     * Delete scheduled task information by scheduling ID
     * 
     * @param jobId Scheduling ID
     * @return Result
     */
    public int deleteJobById(Long jobId);

    /**
     * Batch delete scheduled task information
     * 
     * @param ids Data IDs to delete
     * @return Result
     */
    public int deleteJobByIds(Long[] ids);

    /**
     * Modify scheduled task information
     * 
     * @param job Scheduled task information
     * @return Result
     */
    public int updateJob(SysJob job);

    /**
     * Add scheduled task information
     * 
     * @param job Scheduled task information
     * @return Result
     */
    public int insertJob(SysJob job);
}
