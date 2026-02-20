package com.ruoyi.system.service.impl;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.ruoyi.common.annotation.DataScope;
import com.ruoyi.common.constant.UserConstants;
import com.ruoyi.common.core.domain.entity.SysRole;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.common.utils.spring.SpringUtils;
import com.ruoyi.system.domain.SysRoleDept;
import com.ruoyi.system.domain.SysRoleMenu;
import com.ruoyi.system.domain.SysUserRole;
import com.ruoyi.system.mapper.SysRoleDeptMapper;
import com.ruoyi.system.mapper.SysRoleMapper;
import com.ruoyi.system.mapper.SysRoleMenuMapper;
import com.ruoyi.system.mapper.SysUserRoleMapper;
import com.ruoyi.system.service.ISysRoleService;

/**
 * Role Business Layer Processing
 * 
 * @author ruoyi
 */
@Service
public class SysRoleServiceImpl implements ISysRoleService
{
    @Autowired
    private SysRoleMapper roleMapper;

    @Autowired
    private SysRoleMenuMapper roleMenuMapper;

    @Autowired
    private SysUserRoleMapper userRoleMapper;

    @Autowired
    private SysRoleDeptMapper roleDeptMapper;

    /**
     * Query Role Data by Conditions with Pagination
     * 
     * @param role Role Information
     * @return Role Data Collection Information
     */
    @Override
    @DataScope(deptAlias = "d")
    public List<SysRole> selectRoleList(SysRole role)
    {
        return roleMapper.selectRoleList(role);
    }

    /**
     * Query Roles by User ID
     * 
     * @param userId User ID
     * @return Role List
     */
    @Override
    public List<SysRole> selectRolesByUserId(Long userId)
    {
        List<SysRole> userRoles = roleMapper.selectRolePermissionByUserId(userId);
        List<SysRole> roles = selectRoleAll();
        for (SysRole role : roles)
        {
            for (SysRole userRole : userRoles)
            {
                if (role.getRoleId().longValue() == userRole.getRoleId().longValue())
                {
                    role.setFlag(true);
                    break;
                }
            }
        }
        return roles;
    }

    /**
     * Query Permissions by User ID
     * 
     * @param userId User ID
     * @return Permission List
     */
    @Override
    public Set<String> selectRolePermissionByUserId(Long userId)
    {
        List<SysRole> perms = roleMapper.selectRolePermissionByUserId(userId);
        Set<String> permsSet = new HashSet<>();
        for (SysRole perm : perms)
        {
            if (StringUtils.isNotNull(perm))
            {
                permsSet.addAll(Arrays.asList(perm.getRoleKey().trim().split(",")));
            }
        }
        return permsSet;
    }

    /**
     * Query All Roles
     * 
     * @return Role List
     */
    @Override
    public List<SysRole> selectRoleAll()
    {
        return SpringUtils.getAopProxy(this).selectRoleList(new SysRole());
    }

    /**
     * Get Role Selection List by User ID
     * 
     * @param userId User ID
     * @return Selected Role ID List
     */
    @Override
    public List<Long> selectRoleListByUserId(Long userId)
    {
        return roleMapper.selectRoleListByUserId(userId);
    }

    /**
     * Query Role by Role ID
     * 
     * @param roleId Role ID
     * @return Role Object Information
     */
    @Override
    public SysRole selectRoleById(Long roleId)
    {
        return roleMapper.selectRoleById(roleId);
    }

    /**
     * Check if Role Name is Unique
     * 
     * @param role Role Information
     * @return Result
     */
    @Override
    public boolean checkRoleNameUnique(SysRole role)
    {
        Long roleId = StringUtils.isNull(role.getRoleId()) ? -1L : role.getRoleId();
        SysRole info = roleMapper.checkRoleNameUnique(role.getRoleName());
        if (StringUtils.isNotNull(info) && info.getRoleId().longValue() != roleId.longValue())
        {
            return UserConstants.NOT_UNIQUE;
        }
        return UserConstants.UNIQUE;
    }

    /**
     * Check if Role Permission is Unique
     * 
     * @param role Role Information
     * @return Result
     */
    @Override
    public boolean checkRoleKeyUnique(SysRole role)
    {
        Long roleId = StringUtils.isNull(role.getRoleId()) ? -1L : role.getRoleId();
        SysRole info = roleMapper.checkRoleKeyUnique(role.getRoleKey());
        if (StringUtils.isNotNull(info) && info.getRoleId().longValue() != roleId.longValue())
        {
            return UserConstants.NOT_UNIQUE;
        }
        return UserConstants.UNIQUE;
    }

    /**
     * Check if Role Operation is Allowed
     * 
     * @param role Role Information
     */
    @Override
    public void checkRoleAllowed(SysRole role)
    {
        if (StringUtils.isNotNull(role.getRoleId()) && role.isAdmin())
        {
            throw new ServiceException("Operation on super administrator role is not allowed");
        }
    }

    /**
     * Check if Role has Data Permission
     * 
     * @param roleIds Role IDs
     */
    @Override
    public void checkRoleDataScope(Long... roleIds)
    {
        if (!SecurityUtils.isAdmin())
        {
            for (Long roleId : roleIds)
            {
                SysRole role = new SysRole();
                role.setRoleId(roleId);
                List<SysRole> roles = SpringUtils.getAopProxy(this).selectRoleList(role);
                if (StringUtils.isEmpty(roles))
                {
                    throw new ServiceException("No permission to access role data!");
                }
            }
        }
    }

    /**
     * Query Role Usage Count by Role ID
     * 
     * @param roleId Role ID
     * @return Result
     */
    @Override
    public int countUserRoleByRoleId(Long roleId)
    {
        return userRoleMapper.countUserRoleByRoleId(roleId);
    }

    /**
     * Add and Save Role Information
     * 
     * @param role Role Information
     * @return Result
     */
    @Override
    @Transactional
    public int insertRole(SysRole role)
    {
        // Add Role Information
        roleMapper.insertRole(role);
        return insertRoleMenu(role);
    }

    /**
     * Modify and Save Role Information
     * 
     * @param role Role Information
     * @return Result
     */
    @Override
    @Transactional
    public int updateRole(SysRole role)
    {
        // Modify Role Information
        roleMapper.updateRole(role);
        // Delete Role-Menu Association
        roleMenuMapper.deleteRoleMenuByRoleId(role.getRoleId());
        return insertRoleMenu(role);
    }

    /**
     * Modify Role Status
     * 
     * @param role Role Information
     * @return Result
     */
    @Override
    public int updateRoleStatus(SysRole role)
    {
        return roleMapper.updateRole(role);
    }

    /**
     * Modify Data Permission Information
     * 
     * @param role Role Information
     * @return Result
     */
    @Override
    @Transactional
    public int authDataScope(SysRole role)
    {
        // Modify Role Information
        roleMapper.updateRole(role);
        // Delete Role-Department Association
        roleDeptMapper.deleteRoleDeptByRoleId(role.getRoleId());
        // Add Role and Department Information (Data Permission)
        return insertRoleDept(role);
    }

    /**
     * Add Role-Menu Information
     * 
     * @param role Role Object
     */
    public int insertRoleMenu(SysRole role)
    {
        int rows = 1;
        // Add User-Role Management
        List<SysRoleMenu> list = new ArrayList<SysRoleMenu>();
        for (Long menuId : role.getMenuIds())
        {
            SysRoleMenu rm = new SysRoleMenu();
            rm.setRoleId(role.getRoleId());
            rm.setMenuId(menuId);
            list.add(rm);
        }
        if (list.size() > 0)
        {
            rows = roleMenuMapper.batchRoleMenu(list);
        }
        return rows;
    }

    /**
     * Add Role-Department Information (Data Permission)
     *
     * @param role Role Object
     */
    public int insertRoleDept(SysRole role)
    {
        int rows = 1;
        // Add Role-Department (Data Permission) Management
        List<SysRoleDept> list = new ArrayList<SysRoleDept>();
        for (Long deptId : role.getDeptIds())
        {
            SysRoleDept rd = new SysRoleDept();
            rd.setRoleId(role.getRoleId());
            rd.setDeptId(deptId);
            list.add(rd);
        }
        if (list.size() > 0)
        {
            rows = roleDeptMapper.batchRoleDept(list);
        }
        return rows;
    }

    /**
     * Delete Role by Role ID
     * 
     * @param roleId Role ID
     * @return Result
     */
    @Override
    @Transactional
    public int deleteRoleById(Long roleId)
    {
        // Delete Role-Menu Association
        roleMenuMapper.deleteRoleMenuByRoleId(roleId);
        // Delete Role-Department Association
        roleDeptMapper.deleteRoleDeptByRoleId(roleId);
        return roleMapper.deleteRoleById(roleId);
    }

    /**
     * Batch Delete Role Information
     * 
     * @param roleIds Role IDs to Delete
     * @return Result
     */
    @Override
    @Transactional
    public int deleteRoleByIds(Long[] roleIds)
    {
        for (Long roleId : roleIds)
        {
            checkRoleAllowed(new SysRole(roleId));
            checkRoleDataScope(roleId);
            SysRole role = selectRoleById(roleId);
            if (countUserRoleByRoleId(roleId) > 0)
            {
                throw new ServiceException(String.format("%1$s has been assigned, cannot delete", role.getRoleName()));
            }
        }
        // Delete Role-Menu Association
        roleMenuMapper.deleteRoleMenu(roleIds);
        // Delete Role-Department Association
        roleDeptMapper.deleteRoleDept(roleIds);
        return roleMapper.deleteRoleByIds(roleIds);
    }

    /**
     * Cancel User Role Authorization
     * 
     * @param userRole User-Role Association Information
     * @return Result
     */
    @Override
    public int deleteAuthUser(SysUserRole userRole)
    {
        return userRoleMapper.deleteUserRoleInfo(userRole);
    }

    /**
     * Batch Cancel User Role Authorization
     * 
     * @param roleId Role ID
     * @param userIds User Data IDs to Cancel Authorization
     * @return Result
     */
    @Override
    public int deleteAuthUsers(Long roleId, Long[] userIds)
    {
        return userRoleMapper.deleteUserRoleInfos(roleId, userIds);
    }

    /**
     * Batch Select and Authorize User Roles
     * 
     * @param roleId Role ID
     * @param userIds User Data IDs to Authorize
     * @return Result
     */
    @Override
    public int insertAuthUsers(Long roleId, Long[] userIds)
    {
        // Add User-Role Management
        List<SysUserRole> list = new ArrayList<SysUserRole>();
        for (Long userId : userIds)
        {
            SysUserRole ur = new SysUserRole();
            ur.setUserId(userId);
            ur.setRoleId(roleId);
            list.add(ur);
        }
        return userRoleMapper.batchUserRole(list);
    }
}
