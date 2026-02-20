package com.ruoyi.quartz.util;

import java.text.ParseException;
import java.util.Date;
import org.quartz.CronExpression;

/**
 * Cron Expression Utility Class
 * 
 * @author ruoyi
 *
 */
public class CronUtils
{
    /**
     * Return a boolean value representing the validity of a given Cron expression
     *
     * @param cronExpression Cron expression
     * @return boolean Whether the expression is valid
     */
    public static boolean isValid(String cronExpression)
    {
        return CronExpression.isValidExpression(cronExpression);
    }

    /**
     * Return a string value indicating the validity message for an invalid Cron expression
     *
     * @param cronExpression Cron expression
     * @return String Returns expression error description when invalid, returns null if valid
     */
    public static String getInvalidMessage(String cronExpression)
    {
        try
        {
            new CronExpression(cronExpression);
            return null;
        }
        catch (ParseException pe)
        {
            return pe.getMessage();
        }
    }

    /**
     * Return the next execution time based on the given Cron expression
     *
     * @param cronExpression Cron expression
     * @return Date Next Cron expression execution time
     */
    public static Date getNextExecution(String cronExpression)
    {
        try
        {
            CronExpression cron = new CronExpression(cronExpression);
            return cron.getNextValidTimeAfter(new Date(System.currentTimeMillis()));
        }
        catch (ParseException e)
        {
            throw new IllegalArgumentException(e.getMessage());
        }
    }
}
