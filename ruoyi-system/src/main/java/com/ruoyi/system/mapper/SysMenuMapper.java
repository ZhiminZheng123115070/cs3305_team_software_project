package com.ruoyi.system.mapper;

import java.util.List;
import org.apache.ibatis.annotations.Param;
import com.ruoyi.common.core.domain.entity.SysMenu;

/**
 * Menu Table Data Layer
 *
 * @author ruoyi
 */
public interface SysMenuMapper
{
    /**
     * Query System Menu List
     *
     * @param menu Menu Information
     * @return Menu List
     */
    public List<SysMenu> selectMenuList(SysMenu menu);

    /**
     * Query All Permissions by User
     *
     * @return Permission List
     */
    public List<String> selectMenuPerms();

    /**
     * Query System Menu List by User
     *
     * @param menu Menu Information
     * @return Menu List
     */
    public List<SysMenu> selectMenuListByUserId(SysMenu menu);

    /**
     * Query Permissions by Role ID
     * 
     * @param roleId Role ID
     * @return Permission List
     */
    public List<String> selectMenuPermsByRoleId(Long roleId);

    /**
     * Query Permissions by User ID
     *
     * @param userId User ID
     * @return Permission List
     */
    public List<String> selectMenuPermsByUserId(Long userId);

    /**
     * Query Menu by User ID
     *
     * @return Menu List
     */
    public List<SysMenu> selectMenuTreeAll();

    /**
     * Query Menu by User ID
     *
     * @param userId User ID
     * @return Menu List
     */
    public List<SysMenu> selectMenuTreeByUserId(Long userId);

    /**
     * Query Menu Tree Information by Role ID
     * 
     * @param roleId Role ID
     * @param menuCheckStrictly Whether Menu Tree Selection Items are Associated Display
     * @return Selected Menu List
     */
    public List<Long> selectMenuListByRoleId(@Param("roleId") Long roleId, @Param("menuCheckStrictly") boolean menuCheckStrictly);

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
     * @return Result
     */
    public int hasChildByMenuId(Long menuId);

    /**
     * Add Menu Information
     *
     * @param menu Menu Information
     * @return Result
     */
    public int insertMenu(SysMenu menu);

    /**
     * Modify Menu Information
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
     * @param menuName Menu Name
     * @param parentId Parent Menu ID
     * @return Result
     */
    public SysMenu checkMenuNameUnique(@Param("menuName") String menuName, @Param("parentId") Long parentId);

    /**
     * Query Menu Information by Route Path or Name (for Uniqueness Validation)
     *
     * @param path Route Address
     * @param routeName Route Name
     * @return Matching Menu List
     */
    public List<SysMenu> selectMenusByPathOrRouteName(@Param("path") String path, @Param("routeName") String routeName);
}
