package com.ruoyi.common.utils.uuid;

/**
 * ID Generator Utility Class
 * 
 * @author ruoyi
 */
public class IdUtils
{
    /**
     * Get random UUID
     * 
     * @return Random UUID
     */
    public static String randomUUID()
    {
        return UUID.randomUUID().toString();
    }

    /**
     * Simplified UUID with hyphens removed
     * 
     * @return Simplified UUID with hyphens removed
     */
    public static String simpleUUID()
    {
        return UUID.randomUUID().toString(true);
    }

    /**
     * Get random UUID using ThreadLocalRandom for better performance
     * 
     * @return Random UUID
     */
    public static String fastUUID()
    {
        return UUID.fastUUID().toString();
    }

    /**
     * Simplified UUID with hyphens removed, using ThreadLocalRandom for better performance
     * 
     * @return Simplified UUID with hyphens removed
     */
    public static String fastSimpleUUID()
    {
        return UUID.fastUUID().toString(true);
    }
}
