package com.ruoyi.common.exception.user;

/**
 * User does not exist exception class
 * 
 * @author ruoyi
 */
public class UserNotExistsException extends UserException
{
    private static final long serialVersionUID = 1L;

    public UserNotExistsException()
    {
        super("user.not.exists", null);
    }
}
