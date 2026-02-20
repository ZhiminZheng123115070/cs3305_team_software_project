package com.ruoyi.system.mapper;

import java.util.List;
import com.ruoyi.system.domain.SysLogininfor;

/**
 * System Access Log Information Data Layer
 * 
 * @author ruoyi
 */
public interface SysLogininforMapper
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
     * 
     * @return Result
     */
    public int cleanLogininfor();
}
