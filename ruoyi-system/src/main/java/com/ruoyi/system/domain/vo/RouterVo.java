package com.ruoyi.system.domain.vo;

import com.fasterxml.jackson.annotation.JsonInclude;
import java.util.List;

/**
 * Route Configuration Information
 * 
 * @author ruoyi
 */
@JsonInclude(JsonInclude.Include.NON_EMPTY)
public class RouterVo
{
    /**
     * Route Name
     */
    private String name;

    /**
     * Route Address
     */
    private String path;

    /**
     * Whether to Hide Route, when set to true, the route will not appear in the sidebar
     */
    private boolean hidden;

    /**
     * Redirect Address, when set to noRedirect, the route cannot be clicked in breadcrumb navigation
     */
    private String redirect;

    /**
     * Component Address
     */
    private String component;

    /**
     * Route Parameters: e.g., {"id": 1, "name": "ry"}
     */
    private String query;

    /**
     * When a route has more than 1 child routes declared, it will automatically become nested mode--like component pages
     */
    private Boolean alwaysShow;

    /**
     * Other Elements
     */
    private MetaVo meta;

    /**
     * Child Routes
     */
    private List<RouterVo> children;

    public String getName()
    {
        return name;
    }

    public void setName(String name)
    {
        this.name = name;
    }

    public String getPath()
    {
        return path;
    }

    public void setPath(String path)
    {
        this.path = path;
    }

    public boolean getHidden()
    {
        return hidden;
    }

    public void setHidden(boolean hidden)
    {
        this.hidden = hidden;
    }

    public String getRedirect()
    {
        return redirect;
    }

    public void setRedirect(String redirect)
    {
        this.redirect = redirect;
    }

    public String getComponent()
    {
        return component;
    }

    public void setComponent(String component)
    {
        this.component = component;
    }

    public String getQuery()
    {
        return query;
    }

    public void setQuery(String query)
    {
        this.query = query;
    }

    public Boolean getAlwaysShow()
    {
        return alwaysShow;
    }

    public void setAlwaysShow(Boolean alwaysShow)
    {
        this.alwaysShow = alwaysShow;
    }

    public MetaVo getMeta()
    {
        return meta;
    }

    public void setMeta(MetaVo meta)
    {
        this.meta = meta;
    }

    public List<RouterVo> getChildren()
    {
        return children;
    }

    public void setChildren(List<RouterVo> children)
    {
        this.children = children;
    }
}
