package com.ruoyi.system.mapper;

import java.util.List;
import com.ruoyi.system.domain.SysRoleMenu;

/**
 * Role and Menu Association Table Data Layer
 * 
 * @author ruoyi
 */
public interface SysRoleMenuMapper
{
    /**
     * Query Menu Usage Count
     * 
     * @param menuId Menu ID
     * @return Result
     */
    public int checkMenuExistRole(Long menuId);

    /**
     * Delete Role and Menu Association by Role ID
     * 
     * @param roleId Role ID
     * @return Result
     */
    public int deleteRoleMenuByRoleId(Long roleId);

    /**
     * Batch Delete Role Menu Association Information
     * 
     * @param ids Data IDs to Delete
     * @return Result
     */
    public int deleteRoleMenu(Long[] ids);

    /**
     * Batch Add Role Menu Information
     * 
     * @param roleMenuList Role Menu List
     * @return Result
     */
    public int batchRoleMenu(List<SysRoleMenu> roleMenuList);
}
