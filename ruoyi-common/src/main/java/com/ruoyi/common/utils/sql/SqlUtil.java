package com.ruoyi.common.utils.sql;

import com.ruoyi.common.exception.UtilException;
import com.ruoyi.common.utils.StringUtils;

/**
 * SQL Operation Utility Class
 * 
 * @author ruoyi
 */
public class SqlUtil
{
    /**
     * Define commonly used SQL keywords
     */
    public static String SQL_REGEX = "\u000B|and |extractvalue|updatexml|sleep|information_schema|exec |insert |select |delete |update |drop |count |chr |mid |master |truncate |char |declare |or |union |like |+|/*|user()";

    /**
     * Only supports letters, numbers, underscores, spaces, commas, decimal points (supports multiple field sorting)
     */
    public static String SQL_PATTERN = "[a-zA-Z0-9_\\ \\,\\.]+";

    /**
     * Limit orderBy maximum length
     */
    private static final int ORDER_BY_MAX_LENGTH = 500;

    /**
     * Check characters to prevent injection bypass
     */
    public static String escapeOrderBySql(String value)
    {
        if (StringUtils.isNotEmpty(value) && !isValidOrderBySql(value))
        {
            throw new UtilException("Parameter does not meet the specification, cannot perform query");
        }
        if (StringUtils.length(value) > ORDER_BY_MAX_LENGTH)
        {
            throw new UtilException("Parameter exceeds maximum limit, cannot perform query");
        }
        return value;
    }

    /**
     * Validate whether order by syntax meets the specification
     */
    public static boolean isValidOrderBySql(String value)
    {
        return value.matches(SQL_PATTERN);
    }

    /**
     * SQL keyword check
     */
    public static void filterKeyword(String value)
    {
        if (StringUtils.isEmpty(value))
        {
            return;
        }
        String[] sqlKeywords = StringUtils.split(SQL_REGEX, "\\|");
        for (String sqlKeyword : sqlKeywords)
        {
            if (StringUtils.indexOfIgnoreCase(value, sqlKeyword) > -1)
            {
                throw new UtilException("Parameter has SQL injection risk");
            }
        }
    }
}
