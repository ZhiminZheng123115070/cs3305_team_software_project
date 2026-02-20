package com.ruoyi.system.mapper;

import java.util.List;
import com.ruoyi.common.core.domain.entity.SysRole;

/**
 * Role Table Data Layer
 * 
 * @author ruoyi
 */
public interface SysRoleMapper
{
    /**
     * Query Role Data by Conditions with Pagination
     * 
     * @param role Role Information
     * @return Role Data Collection
     */
    public List<SysRole> selectRoleList(SysRole role);

    /**
     * Query Roles by User ID
     * 
     * @param userId User ID
     * @return Role List
     */
    public List<SysRole> selectRolePermissionByUserId(Long userId);

    /**
     * Query All Roles
     * 
     * @return Role List
     */
    public List<SysRole> selectRoleAll();

    /**
     * Get Role Select Box List by User ID
     * 
     * @param userId User ID
     * @return Selected Role ID List
     */
    public List<Long> selectRoleListByUserId(Long userId);

    /**
     * Query Role by Role ID
     * 
     * @param roleId Role ID
     * @return Role Object Information
     */
    public SysRole selectRoleById(Long roleId);

    /**
     * Query Roles by User ID
     * 
     * @param userName Username
     * @return Role List
     */
    public List<SysRole> selectRolesByUserName(String userName);

    /**
     * Validate if Role Name is Unique
     * 
     * @param roleName Role Name
     * @return Role Information
     */
    public SysRole checkRoleNameUnique(String roleName);

    /**
     * Validate if Role Permission is Unique
     * 
     * @param roleKey Role Permission
     * @return Role Information
     */
    public SysRole checkRoleKeyUnique(String roleKey);

    /**
     * Modify Role Information
     * 
     * @param role Role Information
     * @return Result
     */
    public int updateRole(SysRole role);

    /**
     * Add Role Information
     * 
     * @param role Role Information
     * @return Result
     */
    public int insertRole(SysRole role);

    /**
     * Delete Role by Role ID
     * 
     * @param roleId Role ID
     * @return Result
     */
    public int deleteRoleById(Long roleId);

    /**
     * Batch Delete Role Information
     * 
     * @param roleIds Role IDs to Delete
     * @return Result
     */
    public int deleteRoleByIds(Long[] roleIds);
}
