package com.ruoyi.common.core.page;

import java.io.Serializable;
import java.util.List;

/**
 * Table pagination data object
 * 
 * @author ruoyi
 */
public class TableDataInfo implements Serializable
{
    private static final long serialVersionUID = 1L;

    /** Total Records */
    private long total;

    /** List Data */
    private List<?> rows;

    /** Message status code */
    private int code;

    /** Message Content */
    private String msg;

    /**
     * Table data object
     */
    public TableDataInfo()
    {
    }

    /**
     * Pagination
     * 
     * @param list List Data
     * @param total Total Records
     */
    public TableDataInfo(List<?> list, long total)
    {
        this.rows = list;
        this.total = total;
    }

    public long getTotal()
    {
        return total;
    }

    public void setTotal(long total)
    {
        this.total = total;
    }

    public List<?> getRows()
    {
        return rows;
    }

    public void setRows(List<?> rows)
    {
        this.rows = rows;
    }

    public int getCode()
    {
        return code;
    }

    public void setCode(int code)
    {
        this.code = code;
    }

    public String getMsg()
    {
        return msg;
    }

    public void setMsg(String msg)
    {
        this.msg = msg;
    }
}
