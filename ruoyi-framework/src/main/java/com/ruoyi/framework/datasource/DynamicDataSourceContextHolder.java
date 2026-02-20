package com.ruoyi.framework.datasource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Data source switching processing
 * 
 * @author ruoyi
 */
public class DynamicDataSourceContextHolder
{
    public static final Logger log = LoggerFactory.getLogger(DynamicDataSourceContextHolder.class);

    /**
     * Use ThreadLocal to maintain variables. ThreadLocal provides independent variable copies for each thread that uses the variable,
     * so each thread can independently change its own copy without affecting the copies corresponding to other threads.
     */
    private static final ThreadLocal<String> CONTEXT_HOLDER = new ThreadLocal<>();

    /**
     * Set data source variable
     */
    public static void setDataSourceType(String dsType)
    {
        log.info("Switch to {} data source", dsType);
        CONTEXT_HOLDER.set(dsType);
    }

    /**
     * Get data source variable
     */
    public static String getDataSourceType()
    {
        return CONTEXT_HOLDER.get();
    }

    /**
     * Clear data source variable
     */
    public static void clearDataSourceType()
    {
        CONTEXT_HOLDER.remove();
    }
}
