package com.ruoyi.common.exception.user;

/**
 * Blacklist IP exception class
 * 
 * @author ruoyi
 */
public class BlackListException extends UserException
{
    private static final long serialVersionUID = 1L;

    public BlackListException()
    {
        super("login.blocked", null);
    }
}
