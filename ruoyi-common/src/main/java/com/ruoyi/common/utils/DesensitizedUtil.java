package com.ruoyi.common.utils;

/**
 * Data desensitization utility class
 *
 * @author ruoyi
 */
public class DesensitizedUtil
{
    /**
     * Replace all characters in password with *, e.g., ******
     *
     * @param password Password
     * @return Desensitized password
     */
    public static String password(String password)
    {
        if (StringUtils.isBlank(password))
        {
            return StringUtils.EMPTY;
        }
        return StringUtils.repeat('*', password.length());
    }

    /**
     * Replace middle part of license plate with *, if license plate format is incorrect, do not process
     *
     * @param carLicense Complete license plate number
     * @return Desensitized license plate
     */
    public static String carLicense(String carLicense)
    {
        if (StringUtils.isBlank(carLicense))
        {
            return StringUtils.EMPTY;
        }
        // Regular license plate
        if (carLicense.length() == 7)
        {
            carLicense = StringUtils.hide(carLicense, 3, 6);
        }
        else if (carLicense.length() == 8)
        {
            // New energy license plate
            carLicense = StringUtils.hide(carLicense, 3, 7);
        }
        return carLicense;
    }
}
