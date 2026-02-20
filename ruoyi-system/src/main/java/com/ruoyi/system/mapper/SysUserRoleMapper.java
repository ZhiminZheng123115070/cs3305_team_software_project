package com.ruoyi.system.mapper;

import java.util.List;
import org.apache.ibatis.annotations.Param;
import com.ruoyi.system.domain.SysUserRole;

/**
 * User and Role Association Table Data Layer
 * 
 * @author ruoyi
 */
public interface SysUserRoleMapper
{
    /**
     * Delete User and Role Association by User ID
     * 
     * @param userId User ID
     * @return Result
     */
    public int deleteUserRoleByUserId(Long userId);

    /**
     * Batch Delete User and Role Associations
     * 
     * @param ids Data IDs to Delete
     * @return Result
     */
    public int deleteUserRole(Long[] ids);

    /**
     * Query Role Usage Count by Role ID
     * 
     * @param roleId Role ID
     * @return Result
     */
    public int countUserRoleByRoleId(Long roleId);

    /**
     * Batch Add User Role Information
     * 
     * @param userRoleList User Role List
     * @return Result
     */
    public int batchUserRole(List<SysUserRole> userRoleList);

    /**
     * Delete User and Role Association Information
     * 
     * @param userRole User and Role Association Information
     * @return Result
     */
    public int deleteUserRoleInfo(SysUserRole userRole);

    /**
     * Batch Unauthorize User Roles
     * 
     * @param roleId Role ID
     * @param userIds User Data IDs to Delete
     * @return Result
     */
    public int deleteUserRoleInfos(@Param("roleId") Long roleId, @Param("userIds") Long[] userIds);
}
