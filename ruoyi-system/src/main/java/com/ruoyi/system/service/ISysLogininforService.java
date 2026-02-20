package com.ruoyi.system.service;

import java.util.List;
import com.ruoyi.system.domain.SysLogininfor;

/**
 * System Access Log Information Service Layer
 * 
 * @author ruoyi
 */
public interface ISysLogininforService
{
    /**
     * Add System Login Log
     * 
     * @param logininfor Access Log Object
     */
    public void insertLogininfor(SysLogininfor logininfor);

    /**
     * Query System Login Log Collection
     * 
     * @param logininfor Access Log Object
     * @return Login Record Collection
     */
    public List<SysLogininfor> selectLogininforList(SysLogininfor logininfor);

    /**
     * Batch Delete System Login Logs
     * 
     * @param infoIds Login Log IDs to Delete
     * @return Result
     */
    public int deleteLogininforByIds(Long[] infoIds);

    /**
     * Clear System Login Logs
     */
    public void cleanLogininfor();
}
