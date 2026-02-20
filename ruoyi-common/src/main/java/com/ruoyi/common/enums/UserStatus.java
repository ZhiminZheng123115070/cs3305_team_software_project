package com.ruoyi.common.enums;

/**
 * User Status
 * 
 * @author ruoyi
 */
public enum UserStatus
{
    OK("0", "Normal"), DISABLE("1", "Disabled"), DELETED("2", "Deleted");

    private final String code;
    private final String info;

    UserStatus(String code, String info)
    {
        this.code = code;
        this.info = info;
    }

    public String getCode()
    {
        return code;
    }

    public String getInfo()
    {
        return info;
    }
}
