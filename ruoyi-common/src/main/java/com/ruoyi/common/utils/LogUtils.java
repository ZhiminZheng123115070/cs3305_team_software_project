package com.ruoyi.common.utils;

/**
 * Process and record log files
 * 
 * @author ruoyi
 */
public class LogUtils
{
    public static String getBlock(Object msg)
    {
        if (msg == null)
        {
            msg = "";
        }
        return "[" + msg.toString() + "]";
    }
}
