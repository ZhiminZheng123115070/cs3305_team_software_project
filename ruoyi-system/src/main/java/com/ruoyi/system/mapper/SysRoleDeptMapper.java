package com.ruoyi.system.mapper;

import java.util.List;
import com.ruoyi.system.domain.SysRoleDept;

/**
 * Role and Department Association Table Data Layer
 * 
 * @author ruoyi
 */
public interface SysRoleDeptMapper
{
    /**
     * Delete Role and Department Association by Role ID
     * 
     * @param roleId Role ID
     * @return Result
     */
    public int deleteRoleDeptByRoleId(Long roleId);

    /**
     * Batch Delete Role Department Association Information
     * 
     * @param ids Data IDs to Delete
     * @return Result
     */
    public int deleteRoleDept(Long[] ids);

    /**
     * Query Department Usage Count
     * 
     * @param deptId Department ID
     * @return Result
     */
    public int selectCountRoleDeptByDeptId(Long deptId);

    /**
     * Batch Add Role Department Information
     * 
     * @param roleDeptList Role Department List
     * @return Result
     */
    public int batchRoleDept(List<SysRoleDept> roleDeptList);
}
