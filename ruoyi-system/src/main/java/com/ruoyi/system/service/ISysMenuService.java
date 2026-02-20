package com.ruoyi.system.service;

import java.util.List;
import java.util.Set;
import com.ruoyi.common.core.domain.TreeSelect;
import com.ruoyi.common.core.domain.entity.SysMenu;
import com.ruoyi.system.domain.vo.RouterVo;

/**
 * Menu Business Layer
 * 
 * @author ruoyi
 */
public interface ISysMenuService
{
    /**
     * Query System Menu List by User
     * 
     * @param userId User ID
     * @return Menu List
     */
    public List<SysMenu> selectMenuList(Long userId);

    /**
     * Query System Menu List by User
     * 
     * @param menu Menu Information
     * @param userId User ID
     * @return Menu List
     */
    public List<SysMenu> selectMenuList(SysMenu menu, Long userId);

    /**
     * Query Permissions by User ID
     * 
     * @param userId User ID
     * @return Permission List
     */
    public Set<String> selectMenuPermsByUserId(Long userId);

    /**
     * Query Permissions by Role ID
     * 
     * @param roleId Role ID
     * @return Permission List
     */
    public Set<String> selectMenuPermsByRoleId(Long roleId);

    /**
     * Query Menu Tree Information by User ID
     * 
     * @param userId User ID
     * @return Menu List
     */
    public List<SysMenu> selectMenuTreeByUserId(Long userId);

    /**
     * Query Menu Tree Information by Role ID
     * 
     * @param roleId Role ID
     * @return Selected Menu List
     */
    public List<Long> selectMenuListByRoleId(Long roleId);

    /**
     * Build Menus Required for Frontend Routes
     * 
     * @param menus Menu List
     * @return Route List
     */
    public List<RouterVo> buildMenus(List<SysMenu> menus);

    /**
     * Build Tree Structure Required for Frontend
     * 
     * @param menus Menu List
     * @return Tree Structure List
     */
    public List<SysMenu> buildMenuTree(List<SysMenu> menus);

    /**
     * Build Dropdown Tree Structure Required for Frontend
     * 
     * @param menus Menu List
     * @return Dropdown Tree Structure List
     */
    public List<TreeSelect> buildMenuTreeSelect(List<SysMenu> menus);

    /**
     * Query Information by Menu ID
     * 
     * @param menuId Menu ID
     * @return Menu Information
     */
    public SysMenu selectMenuById(Long menuId);

    /**
     * Check if Menu Child Nodes Exist
     * 
     * @param menuId Menu ID
     * @return Result true exists false does not exist
     */
    public boolean hasChildByMenuId(Long menuId);

    /**
     * Query if Menu Exists in Roles
     * 
     * @param menuId Menu ID
     * @return Result true exists false does not exist
     */
    public boolean checkMenuExistRole(Long menuId);

    /**
     * Add and Save Menu Information
     * 
     * @param menu Menu Information
     * @return Result
     */
    public int insertMenu(SysMenu menu);

    /**
     * Modify and Save Menu Information
     * 
     * @param menu Menu Information
     * @return Result
     */
    public int updateMenu(SysMenu menu);

    /**
     * Delete Menu Management Information
     * 
     * @param menuId Menu ID
     * @return Result
     */
    public int deleteMenuById(Long menuId);

    /**
     * Validate if Menu Name is Unique
     * 
     * @param menu Menu Information
     * @return Result
     */
    public boolean checkMenuNameUnique(SysMenu menu);

    /**
     * Validate if Route Combination is Unique
     *
     * @param menu Menu Information
     * @return Result
     */
    public boolean checkRouteConfigUnique(SysMenu menu);
}
