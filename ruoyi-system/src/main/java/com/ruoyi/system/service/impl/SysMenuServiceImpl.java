package com.ruoyi.system.service.impl;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashSet;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.common.constant.Constants;
import com.ruoyi.common.constant.UserConstants;
import com.ruoyi.common.core.domain.TreeSelect;
import com.ruoyi.common.core.domain.entity.SysMenu;
import com.ruoyi.common.core.domain.entity.SysRole;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.system.domain.vo.MetaVo;
import com.ruoyi.system.domain.vo.RouterVo;
import com.ruoyi.system.mapper.SysMenuMapper;
import com.ruoyi.system.mapper.SysRoleMapper;
import com.ruoyi.system.mapper.SysRoleMenuMapper;
import com.ruoyi.system.service.ISysMenuService;

/**
 * Menu Business Layer Processing
 * 
 * @author ruoyi
 */
@Service
public class SysMenuServiceImpl implements ISysMenuService
{
    private static final Logger log = LoggerFactory.getLogger(SysMenuServiceImpl.class);

    public static final String PREMISSION_STRING = "perms[\"{0}\"]";

    public static final Long MENU_ROOT_ID = 0L;

    @Autowired
    private SysMenuMapper menuMapper;

    @Autowired
    private SysRoleMapper roleMapper;

    @Autowired
    private SysRoleMenuMapper roleMenuMapper;

    /**
     * Query System Menu List by User
     * 
     * @param userId User ID
     * @return Menu List
     */
    @Override
    public List<SysMenu> selectMenuList(Long userId)
    {
        return selectMenuList(new SysMenu(), userId);
    }

    /**
     * Query System Menu List
     * 
     * @param menu Menu Information
     * @return Menu List
     */
    @Override
    public List<SysMenu> selectMenuList(SysMenu menu, Long userId)
    {
        List<SysMenu> menuList = null;
        // Administrator displays all menu information
        if (SecurityUtils.isAdmin(userId))
        {
            menuList = menuMapper.selectMenuList(menu);
        }
        else
        {
            menu.getParams().put("userId", userId);
            menuList = menuMapper.selectMenuListByUserId(menu);
        }
        return menuList;
    }

    /**
     * Query Permissions by User ID
     * 
     * @param userId User ID
     * @return Permission List
     */
    @Override
    public Set<String> selectMenuPermsByUserId(Long userId)
    {
        List<String> perms = menuMapper.selectMenuPermsByUserId(userId);
        Set<String> permsSet = new HashSet<>();
        for (String perm : perms)
        {
            if (StringUtils.isNotEmpty(perm))
            {
                permsSet.addAll(Arrays.asList(perm.trim().split(",")));
            }
        }
        return permsSet;
    }

    /**
     * Query Permissions by Role ID
     * 
     * @param roleId Role ID
     * @return Permission List
     */
    @Override
    public Set<String> selectMenuPermsByRoleId(Long roleId)
    {
        List<String> perms = menuMapper.selectMenuPermsByRoleId(roleId);
        Set<String> permsSet = new HashSet<>();
        for (String perm : perms)
        {
            if (StringUtils.isNotEmpty(perm))
            {
                permsSet.addAll(Arrays.asList(perm.trim().split(",")));
            }
        }
        return permsSet;
    }

    /**
     * Query Menu by User ID
     * 
     * @param userId User ID
     * @return Menu List
     */
    @Override
    public List<SysMenu> selectMenuTreeByUserId(Long userId)
    {
        List<SysMenu> menus = null;
        if (SecurityUtils.isAdmin(userId))
        {
            menus = menuMapper.selectMenuTreeAll();
        }
        else
        {
            menus = menuMapper.selectMenuTreeByUserId(userId);
        }
        return getChildPerms(menus, MENU_ROOT_ID);
    }

    /**
     * Query Menu Tree Information by Role ID
     * 
     * @param roleId Role ID
     * @return Selected Menu List
     */
    @Override
    public List<Long> selectMenuListByRoleId(Long roleId)
    {
        SysRole role = roleMapper.selectRoleById(roleId);
        return menuMapper.selectMenuListByRoleId(roleId, role.isMenuCheckStrictly());
    }

    /**
     * Build Menus Required for Frontend Routes
     * 
     * @param menus Menu List
     * @return Route List
     */
    @Override
    public List<RouterVo> buildMenus(List<SysMenu> menus)
    {
        List<RouterVo> routers = new LinkedList<RouterVo>();
        for (SysMenu menu : menus)
        {
            RouterVo router = new RouterVo();
            router.setHidden("1".equals(menu.getVisible()));
            router.setName(getRouteName(menu));
            router.setPath(getRouterPath(menu));
            router.setComponent(getComponent(menu));
            router.setQuery(menu.getQuery());
            router.setMeta(new MetaVo(menu.getMenuName(), menu.getIcon(), StringUtils.equals("1", menu.getIsCache()), menu.getPath()));
            List<SysMenu> cMenus = menu.getChildren();
            if (StringUtils.isNotEmpty(cMenus) && UserConstants.TYPE_DIR.equals(menu.getMenuType()))
            {
                router.setAlwaysShow(true);
                router.setRedirect("noRedirect");
                router.setChildren(buildMenus(cMenus));
            }
            else if (isMenuFrame(menu))
            {
                router.setMeta(null);
                List<RouterVo> childrenList = new ArrayList<RouterVo>();
                RouterVo children = new RouterVo();
                children.setPath(menu.getPath());
                children.setComponent(menu.getComponent());
                children.setName(getRouteName(menu.getRouteName(), menu.getPath()));
                children.setMeta(new MetaVo(menu.getMenuName(), menu.getIcon(), StringUtils.equals("1", menu.getIsCache()), menu.getPath()));
                children.setQuery(menu.getQuery());
                childrenList.add(children);
                router.setChildren(childrenList);
            }
            else if (menu.getParentId().intValue() == MENU_ROOT_ID && isInnerLink(menu))
            {
                router.setMeta(new MetaVo(menu.getMenuName(), menu.getIcon()));
                router.setPath("/");
                List<RouterVo> childrenList = new ArrayList<RouterVo>();
                RouterVo children = new RouterVo();
                String routerPath = innerLinkReplaceEach(menu.getPath());
                children.setPath(routerPath);
                children.setComponent(UserConstants.INNER_LINK);
                children.setName(getRouteName(menu.getRouteName(), routerPath));
                children.setMeta(new MetaVo(menu.getMenuName(), menu.getIcon(), menu.getPath()));
                childrenList.add(children);
                router.setChildren(childrenList);
            }
            routers.add(router);
        }
        return routers;
    }

    /**
     * Build Tree Structure Required for Frontend
     * 
     * @param menus Menu List
     * @return Tree Structure List
     */
    @Override
    public List<SysMenu> buildMenuTree(List<SysMenu> menus)
    {
        List<SysMenu> returnList = new ArrayList<SysMenu>();
        List<Long> tempList = menus.stream().map(SysMenu::getMenuId).collect(Collectors.toList());
        for (Iterator<SysMenu> iterator = menus.iterator(); iterator.hasNext();)
        {
            SysMenu menu = (SysMenu) iterator.next();
            // If it is a top-level node, traverse all child nodes of that parent node
            if (!tempList.contains(menu.getParentId()))
            {
                recursionFn(menus, menu);
                returnList.add(menu);
            }
        }
        if (returnList.isEmpty())
        {
            returnList = menus;
        }
        return returnList;
    }

    /**
     * Build Dropdown Tree Structure Required for Frontend
     * 
     * @param menus Menu List
     * @return Dropdown Tree Structure List
     */
    @Override
    public List<TreeSelect> buildMenuTreeSelect(List<SysMenu> menus)
    {
        List<SysMenu> menuTrees = buildMenuTree(menus);
        return menuTrees.stream().map(TreeSelect::new).collect(Collectors.toList());
    }

    /**
     * Query Information by Menu ID
     * 
     * @param menuId Menu ID
     * @return Menu Information
     */
    @Override
    public SysMenu selectMenuById(Long menuId)
    {
        return menuMapper.selectMenuById(menuId);
    }

    /**
     * Check if Menu has Child Nodes
     * 
     * @param menuId Menu ID
     * @return Result
     */
    @Override
    public boolean hasChildByMenuId(Long menuId)
    {
        int result = menuMapper.hasChildByMenuId(menuId);
        return result > 0;
    }

    /**
     * Query Menu Usage Count
     * 
     * @param menuId Menu ID
     * @return Result
     */
    @Override
    public boolean checkMenuExistRole(Long menuId)
    {
        int result = roleMenuMapper.checkMenuExistRole(menuId);
        return result > 0;
    }

    /**
     * Add and Save Menu Information
     * 
     * @param menu Menu Information
     * @return Result
     */
    @Override
    public int insertMenu(SysMenu menu)
    {
        return menuMapper.insertMenu(menu);
    }

    /**
     * Modify and Save Menu Information
     * 
     * @param menu Menu Information
     * @return Result
     */
    @Override
    public int updateMenu(SysMenu menu)
    {
        return menuMapper.updateMenu(menu);
    }

    /**
     * Delete Menu Management Information
     * 
     * @param menuId Menu ID
     * @return Result
     */
    @Override
    public int deleteMenuById(Long menuId)
    {
        return menuMapper.deleteMenuById(menuId);
    }

    /**
     * Check if Menu Name is Unique
     * 
     * @param menu Menu Information
     * @return Result
     */
    @Override
    public boolean checkMenuNameUnique(SysMenu menu)
    {
        Long menuId = StringUtils.isNull(menu.getMenuId()) ? -1L : menu.getMenuId();
        SysMenu info = menuMapper.checkMenuNameUnique(menu.getMenuName(), menu.getParentId());
        if (StringUtils.isNotNull(info) && info.getMenuId().longValue() != menuId.longValue())
        {
            return UserConstants.NOT_UNIQUE;
        }
        return UserConstants.UNIQUE;
    }

    /**
     * Check if Route Name is Unique
     *
     * @param menu Menu Information
     * @return Result
     */
    @Override
    public boolean checkRouteConfigUnique(SysMenu menu)
    {
        Long menuId = StringUtils.isNull(menu.getMenuId()) ? -1L : menu.getMenuId();
        Long parentId = menu.getParentId();
        String path = menu.getPath();
        String routeName = StringUtils.isEmpty(menu.getRouteName()) ? path : menu.getRouteName();
        List<SysMenu> sysMenuList = menuMapper.selectMenusByPathOrRouteName(path, routeName);
        for (SysMenu sysMenu : sysMenuList)
        {
            if (sysMenu.getMenuId().longValue() != menuId.longValue())
            {
                Long dbParentId = sysMenu.getParentId();
                String dbPath = sysMenu.getPath();
                String dbRouteName = StringUtils.isEmpty(sysMenu.getRouteName()) ? dbPath : sysMenu.getRouteName();
                if (StringUtils.equalsAnyIgnoreCase(path, dbPath) && parentId.longValue() == dbParentId.longValue())
                {
                    log.warn("[Same Level Route Conflict] Same route path '{}' already exists at the same level, conflicting menu: {}", dbPath, sysMenu.getMenuName());
                    return UserConstants.NOT_UNIQUE;
                }
                else if (StringUtils.equalsAnyIgnoreCase(path, dbPath) && parentId.longValue() == MENU_ROOT_ID)
                {
                    log.warn("[Root Directory Route Conflict] Route '{}' under root directory must be unique, already occupied by menu '{}'", path, sysMenu.getMenuName());
                    return UserConstants.NOT_UNIQUE;
                }
                else if (StringUtils.equalsAnyIgnoreCase(routeName, dbRouteName))
                {
                    log.warn("[Route Name Conflict] Route name '{}' must be globally unique, already used by menu '{}'", routeName, sysMenu.getMenuName());
                    return UserConstants.NOT_UNIQUE;
                }
            }
        }
        return UserConstants.UNIQUE;
    }

    /**
     * Get Route Name
     * 
     * @param menu Menu Information
     * @return Route Name
     */
    public String getRouteName(SysMenu menu)
    {
        // Not external link and is a first-level directory (type is directory)
        if (isMenuFrame(menu))
        {
            return StringUtils.EMPTY;
        }
        return getRouteName(menu.getRouteName(), menu.getPath());
    }

    /**
     * Get Route Name, if route name is not configured, use route address
     * 
     * @param name Route Name
     * @param path Route Address
     * @return Route Name (Camel Case Format)
     */
    public String getRouteName(String name, String path)
    {
        String routerName = StringUtils.isNotEmpty(name) ? name : path;
        return StringUtils.capitalize(routerName);
    }

    /**
     * Get Route Address
     * 
     * @param menu Menu Information
     * @return Route Address
     */
    public String getRouterPath(SysMenu menu)
    {
        String routerPath = menu.getPath();
        // Internal link opens external network method
        if (menu.getParentId().intValue() != MENU_ROOT_ID && isInnerLink(menu))
        {
            routerPath = innerLinkReplaceEach(routerPath);
        }
        // Not external link and is a first-level directory (type is directory)
        if (MENU_ROOT_ID == menu.getParentId().intValue() && UserConstants.TYPE_DIR.equals(menu.getMenuType())
                && UserConstants.NO_FRAME.equals(menu.getIsFrame()))
        {
            routerPath = "/" + menu.getPath();
        }
        // Not external link and is a first-level directory (type is menu)
        else if (isMenuFrame(menu))
        {
            routerPath = "/";
        }
        return routerPath;
    }

    /**
     * Get Component Information
     * 
     * @param menu Menu Information
     * @return Component Information
     */
    public String getComponent(SysMenu menu)
    {
        String component = UserConstants.LAYOUT;
        if (StringUtils.isNotEmpty(menu.getComponent()) && !isMenuFrame(menu))
        {
            component = menu.getComponent();
        }
        else if (StringUtils.isEmpty(menu.getComponent()) && menu.getParentId().intValue() != MENU_ROOT_ID && isInnerLink(menu))
        {
            component = UserConstants.INNER_LINK;
        }
        else if (StringUtils.isEmpty(menu.getComponent()) && isParentView(menu))
        {
            component = UserConstants.PARENT_VIEW;
        }
        return component;
    }

    /**
     * Check if it is Menu Internal Jump
     * 
     * @param menu Menu Information
     * @return Result
     */
    public boolean isMenuFrame(SysMenu menu)
    {
        return menu.getParentId().intValue() == MENU_ROOT_ID && UserConstants.TYPE_MENU.equals(menu.getMenuType())
                && menu.getIsFrame().equals(UserConstants.NO_FRAME);
    }

    /**
     * Check if it is parent_view Component
     * 
     * @param menu Menu Information
     * @return Result
     */
    public boolean isParentView(SysMenu menu)
    {
        return menu.getParentId().intValue() != MENU_ROOT_ID && UserConstants.TYPE_DIR.equals(menu.getMenuType());
    }

    /**
     * Check if it is Internal Link Component
     * 
     * @param menu Menu Information
     * @return Result
     */
    public boolean isInnerLink(SysMenu menu)
    {
        return menu.getIsFrame().equals(UserConstants.NO_FRAME) && StringUtils.ishttp(menu.getPath());
    }

    /**
     * Get All Child Nodes by Parent Node ID
     * 
     * @param list Category Table
     * @param parentId Parent Node ID Passed In
     * @return String
     */
    public List<SysMenu> getChildPerms(List<SysMenu> list, long parentId)
    {
        List<SysMenu> returnList = new ArrayList<SysMenu>();
        for (Iterator<SysMenu> iterator = list.iterator(); iterator.hasNext();)
        {
            SysMenu t = (SysMenu) iterator.next();
            // First, based on the passed parent node ID, traverse all child nodes of that parent node
            if (t.getParentId() == parentId)
            {
                recursionFn(list, t);
                returnList.add(t);
            }
        }
        return returnList;
    }

    /**
     * Recursive List
     * 
     * @param list Category Table
     * @param t Child Node
     */
    private void recursionFn(List<SysMenu> list, SysMenu t)
    {
        // Get Child Node List
        List<SysMenu> childList = getChildList(list, t);
        t.setChildren(childList);
        for (SysMenu tChild : childList)
        {
            if (hasChild(list, tChild))
            {
                recursionFn(list, tChild);
            }
        }
    }

    /**
     * Get Child Node List
     */
    private List<SysMenu> getChildList(List<SysMenu> list, SysMenu t)
    {
        List<SysMenu> tlist = new ArrayList<SysMenu>();
        Iterator<SysMenu> it = list.iterator();
        while (it.hasNext())
        {
            SysMenu n = (SysMenu) it.next();
            if (n.getParentId().longValue() == t.getMenuId().longValue())
            {
                tlist.add(n);
            }
        }
        return tlist;
    }

    /**
     * Check if it has Child Nodes
     */
    private boolean hasChild(List<SysMenu> list, SysMenu t)
    {
        return getChildList(list, t).size() > 0;
    }

    /**
     * Replace Special Characters in Internal Link Domain
     * 
     * @return Replaced Internal Link Domain
     */
    public String innerLinkReplaceEach(String path)
    {
        return StringUtils.replaceEach(path, new String[] { Constants.HTTP, Constants.HTTPS, Constants.WWW, ".", ":" },
                new String[] { "", "", "", "/", "/" });
    }
}
