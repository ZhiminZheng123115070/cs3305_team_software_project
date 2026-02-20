package com.ruoyi.system.service;

import java.util.List;
import java.util.Set;
import com.ruoyi.common.core.domain.entity.SysRole;
import com.ruoyi.system.domain.SysUserRole;

/**
 * Role Business Layer
 * 
 * @author ruoyi
 */
public interface ISysRoleService
{
    /**
     * Query Role Data by Conditions with Pagination
     * 
     * @param role Role Information
     * @return Role Data Collection
     */
    public List<SysRole> selectRoleList(SysRole role);

    /**
     * Query Role List by User ID
     * 
     * @param userId User ID
     * @return Role List
     */
    public List<SysRole> selectRolesByUserId(Long userId);

    /**
     * Query Role Permissions by User ID
     * 
     * @param userId User ID
     * @return Permission List
     */
    public Set<String> selectRolePermissionByUserId(Long userId);

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
     * Validate if Role Name is Unique
     * 
     * @param role Role Information
     * @return Result
     */
    public boolean checkRoleNameUnique(SysRole role);

    /**
     * Validate if Role Permission is Unique
     * 
     * @param role Role Information
     * @return Result
     */
    public boolean checkRoleKeyUnique(SysRole role);

    /**
     * Validate if Role Operation is Allowed
     * 
     * @param role Role Information
     */
    public void checkRoleAllowed(SysRole role);

    /**
     * Validate if Role has Data Permission
     * 
     * @param roleIds Role IDs
     */
    public void checkRoleDataScope(Long... roleIds);

    /**
     * Query Role Usage Count by Role ID
     * 
     * @param roleId Role ID
     * @return Result
     */
    public int countUserRoleByRoleId(Long roleId);

    /**
     * Add and Save Role Information
     * 
     * @param role Role Information
     * @return Result
     */
    public int insertRole(SysRole role);

    /**
     * Modify and Save Role Information
     * 
     * @param role Role Information
     * @return Result
     */
    public int updateRole(SysRole role);

    /**
     * Modify Role Status
     * 
     * @param role Role Information
     * @return Result
     */
    public int updateRoleStatus(SysRole role);

    /**
     * Modify Data Permission Information
     * 
     * @param role Role Information
     * @return Result
     */
    public int authDataScope(SysRole role);

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

    /**
     * Unauthorize User Role
     * 
     * @param userRole User and Role Association Information
     * @return Result
     */
    public int deleteAuthUser(SysUserRole userRole);

    /**
     * Batch Unauthorize User Roles
     * 
     * @param roleId Role ID
     * @param userIds User Data IDs to Unauthorize
     * @return Result
     */
    public int deleteAuthUsers(Long roleId, Long[] userIds);

    /**
     * Batch Select and Authorize User Roles
     * 
     * @param roleId Role ID
     * @param userIds User Data IDs to Delete
     * @return Result
     */
    public int insertAuthUsers(Long roleId, Long[] userIds);
}
