package com.ruoyi.common.core.domain.model;

/**
 * User login object
 * 
 * @author ruoyi
 */
public class LoginBody
{
    /**
     * Username
     */
    private String username;

    /**
     * User Password
     */
    private String password;

    /**
     * Captcha
     */
    private String code;

    /**
     * Unique identifier
     */
    private String uuid;

    public String getUsername()
    {
        return username;
    }

    public void setUsername(String username)
    {
        this.username = username;
    }

    public String getPassword()
    {
        return password;
    }

    public void setPassword(String password)
    {
        this.password = password;
    }

    public String getCode()
    {
        return code;
    }

    public void setCode(String code)
    {
        this.code = code;
    }

    public String getUuid()
    {
        return uuid;
    }

    public void setUuid(String uuid)
    {
        this.uuid = uuid;
    }
}
