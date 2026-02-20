package com.ruoyi.system.mapper;

import java.util.List;
import com.ruoyi.system.domain.SysOperLog;

/**
 * Operation Log Data Layer
 * 
 * @author ruoyi
 */
public interface SysOperLogMapper
{
    /**
     * Add Operation Log
     * 
     * @param operLog Operation Log Object
     */
    public void insertOperlog(SysOperLog operLog);

    /**
     * Query System Operation Log Collection
     * 
     * @param operLog Operation Log Object
     * @return Operation Log Collection
     */
    public List<SysOperLog> selectOperLogList(SysOperLog operLog);

    /**
     * Batch Delete System Operation Logs
     * 
     * @param operIds Operation Log IDs to Delete
     * @return Result
     */
    public int deleteOperLogByIds(Long[] operIds);

    /**
     * Query Operation Log Details
     * 
     * @param operId Operation ID
     * @return Operation Log Object
     */
    public SysOperLog selectOperLogById(Long operId);

    /**
     * Clear Operation Logs
     */
    public void cleanOperLog();
}
