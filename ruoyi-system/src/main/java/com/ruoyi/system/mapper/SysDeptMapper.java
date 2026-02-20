package com.ruoyi.system.mapper;

import java.util.List;
import org.apache.ibatis.annotations.Param;
import com.ruoyi.common.core.domain.entity.SysDept;

/**
 * Department Management Data Layer
 * 
 * @author ruoyi
 */
public interface SysDeptMapper
{
    /**
     * Query Department Management Data
     * 
     * @param dept Department Information
     * @return Department Information Collection
     */
    public List<SysDept> selectDeptList(SysDept dept);

    /**
     * Query Department Tree Information by Role ID
     * 
     * @param roleId Role ID
     * @param deptCheckStrictly Whether Department Tree Selection Items are Associated Display
     * @return Selected Department List
     */
    public List<Long> selectDeptListByRoleId(@Param("roleId") Long roleId, @Param("deptCheckStrictly") boolean deptCheckStrictly);

    /**
     * Query Information by Department ID
     * 
     * @param deptId Department ID
     * @return Department Information
     */
    public SysDept selectDeptById(Long deptId);

    /**
     * Query All Sub-departments by ID
     * 
     * @param deptId Department ID
     * @return Department List
     */
    public List<SysDept> selectChildrenDeptById(Long deptId);

    /**
     * Query All Sub-departments by ID (Normal Status)
     * 
     * @param deptId Department ID
     * @return Sub-department Count
     */
    public int selectNormalChildrenDeptById(Long deptId);

    /**
     * Check if Child Nodes Exist
     * 
     * @param deptId Department ID
     * @return Result
     */
    public int hasChildByDeptId(Long deptId);

    /**
     * Query if Department Has Users
     * 
     * @param deptId Department ID
     * @return Result
     */
    public int checkDeptExistUser(Long deptId);

    /**
     * Validate if Department Name is Unique
     * 
     * @param deptName Department Name
     * @param parentId Parent Department ID
     * @return Result
     */
    public SysDept checkDeptNameUnique(@Param("deptName") String deptName, @Param("parentId") Long parentId);

    /**
     * Add Department Information
     * 
     * @param dept Department Information
     * @return Result
     */
    public int insertDept(SysDept dept);

    /**
     * Modify Department Information
     * 
     * @param dept Department Information
     * @return Result
     */
    public int updateDept(SysDept dept);

    /**
     * Modify Department Normal Status
     * 
     * @param deptIds Department ID Group
     */
    public void updateDeptStatusNormal(Long[] deptIds);

    /**
     * Modify Child Element Relationships
     * 
     * @param depts Child Elements
     * @return Result
     */
    public int updateDeptChildren(@Param("depts") List<SysDept> depts);

    /**
     * Delete Department Management Information
     * 
     * @param deptId Department ID
     * @return Result
     */
    public int deleteDeptById(Long deptId);
}
