package com.ruoyi.common.core.controller;

import java.beans.PropertyEditorSupport;
import java.util.Date;
import java.util.List;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.ruoyi.common.constant.HttpStatus;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.domain.model.LoginUser;
import com.ruoyi.common.core.page.PageDomain;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.core.page.TableSupport;
import com.ruoyi.common.utils.DateUtils;
import com.ruoyi.common.utils.PageUtils;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.common.utils.sql.SqlUtil;

/**
 * Web layer common data processing
 * 
 * @author ruoyi
 */
public class BaseController
{
    protected final Logger logger = LoggerFactory.getLogger(this.getClass());

    /**
     * Automatically convert String date format passed from frontend to Date type
     */
    @InitBinder
    public void initBinder(WebDataBinder binder)
    {
        // Date type conversion
        binder.registerCustomEditor(Date.class, new PropertyEditorSupport()
        {
            @Override
            public void setAsText(String text)
            {
                setValue(DateUtils.parseDate(text));
            }
        });
    }

    /**
     * Set request pagination data
     */
    protected void startPage()
    {
        PageUtils.startPage();
    }

    /**
     * Set request sort data
     */
    protected void startOrderBy()
    {
        PageDomain pageDomain = TableSupport.buildPageRequest();
        if (StringUtils.isNotEmpty(pageDomain.getOrderBy()))
        {
            String orderBy = SqlUtil.escapeOrderBySql(pageDomain.getOrderBy());
            PageHelper.orderBy(orderBy);
        }
    }

    /**
     * Clear pagination thread variables
     */
    protected void clearPage()
    {
        PageUtils.clearPage();
    }

    /**
     * Response request pagination data
     */
    @SuppressWarnings({ "rawtypes", "unchecked" })
    protected TableDataInfo getDataTable(List<?> list)
    {
        TableDataInfo rspData = new TableDataInfo();
        rspData.setCode(HttpStatus.SUCCESS);
        rspData.setMsg("Query successful");
        rspData.setRows(list);
        rspData.setTotal(new PageInfo(list).getTotal());
        return rspData;
    }

    /**
     * Return success
     */
    public AjaxResult success()
    {
        return AjaxResult.success();
    }

    /**
     * Return failure message
     */
    public AjaxResult error()
    {
        return AjaxResult.error();
    }

    /**
     * Return success message
     */
    public AjaxResult success(String message)
    {
        return AjaxResult.success(message);
    }
    
    /**
     * Return success message
     */
    public AjaxResult success(Object data)
    {
        return AjaxResult.success(data);
    }

    /**
     * Return failure message
     */
    public AjaxResult error(String message)
    {
        return AjaxResult.error(message);
    }

    /**
     * Return warning message
     */
    public AjaxResult warn(String message)
    {
        return AjaxResult.warn(message);
    }

    /**
     * Response return result
     * 
     * @param rows Number of affected rows
     * @return Operation result
     */
    protected AjaxResult toAjax(int rows)
    {
        return rows > 0 ? AjaxResult.success() : AjaxResult.error();
    }

    /**
     * Response return result
     * 
     * @param result Result
     * @return Operation result
     */
    protected AjaxResult toAjax(boolean result)
    {
        return result ? success() : error();
    }

    /**
     * Page redirect
     */
    public String redirect(String url)
    {
        return StringUtils.format("redirect:{}", url);
    }

    /**
     * Get user cache information
     */
    public LoginUser getLoginUser()
    {
        return SecurityUtils.getLoginUser();
    }

    /**
     * Get logged in user id
     */
    public Long getUserId()
    {
        return getLoginUser().getUserId();
    }

    /**
     * Get logged in department id
     */
    public Long getDeptId()
    {
        return getLoginUser().getDeptId();
    }

    /**
     * Get logged in username
     */
    public String getUsername()
    {
        return getLoginUser().getUsername();
    }
}
