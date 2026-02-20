package com.ruoyi.system.service;

import java.util.List;
import com.ruoyi.common.core.domain.TreeSelect;
import com.ruoyi.common.core.domain.entity.SysDept;

/**
 * Department Management Service Layer
 * 
 * @author ruoyi
 */
public interface ISysDeptService
{
    /**
     * Query Department Management Data
     * 
     * @param dept Department Information
     * @return Department Information Collection
     */
    public List<SysDept> selectDeptList(SysDept dept);

    /**
     * Query Department Tree Structure Information
     * 
     * @param dept Department Information
     * @return Department Tree Information Collection
     */
    public List<TreeSelect> selectDeptTreeList(SysDept dept);

    /**
     * Build Tree Structure Required for Frontend
     * 
     * @param depts Department List
     * @return Tree Structure List
     */
    public List<SysDept> buildDeptTree(List<SysDept> depts);

    /**
     * Build Dropdown Tree Structure Required for Frontend
     * 
     * @param depts Department List
     * @return Dropdown Tree Structure List
     */
    public List<TreeSelect> buildDeptTreeSelect(List<SysDept> depts);

    /**
     * Query Department Tree Information by Role ID
     * 
     * @param roleId Role ID
     * @return Selected Department List
     */
    public List<Long> selectDeptListByRoleId(Long roleId);

    /**
     * Query Information by Department ID
     * 
     * @param deptId Department ID
     * @return Department Information
     */
    public SysDept selectDeptById(Long deptId);

    /**
     * Query All Sub-departments by ID (Normal Status)
     * 
     * @param deptId Department ID
     * @return Sub-department Count
     */
    public int selectNormalChildrenDeptById(Long deptId);

    /**
     * Check if Department Child Nodes Exist
     * 
     * @param deptId Department ID
     * @return Result
     */
    public boolean hasChildByDeptId(Long deptId);

    /**
     * Query if Department Has Users
     * 
     * @param deptId Department ID
     * @return Result true exists false does not exist
     */
    public boolean checkDeptExistUser(Long deptId);

    /**
     * Validate if Department Name is Unique
     * 
     * @param dept Department Information
     * @return Result
     */
    public boolean checkDeptNameUnique(SysDept dept);

    /**
     * Validate if Department has Data Permission
     * 
     * @param deptId Department ID
     */
    public void checkDeptDataScope(Long deptId);

    /**
     * Add and Save Department Information
     * 
     * @param dept Department Information
     * @return Result
     */
    public int insertDept(SysDept dept);

    /**
     * Modify and Save Department Information
     * 
     * @param dept Department Information
     * @return Result
     */
    public int updateDept(SysDept dept);

    /**
     * Delete Department Management Information
     * 
     * @param deptId Department ID
     * @return Result
     */
    public int deleteDeptById(Long deptId);
}
