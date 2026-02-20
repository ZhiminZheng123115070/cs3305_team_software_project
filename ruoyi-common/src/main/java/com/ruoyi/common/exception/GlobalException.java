package com.ruoyi.common.exception;

/**
 * Global Exception
 * 
 * @author ruoyi
 */
public class GlobalException extends RuntimeException
{
    private static final long serialVersionUID = 1L;

    /**
     * Error message
     */
    private String message;

    /**
     * Error details, internal debugging error
     *
     * Consistent design with {@link CommonResult#getDetailMessage()}
     */
    private String detailMessage;

    /**
     * Empty constructor to avoid deserialization issues
     */
    public GlobalException()
    {
    }

    public GlobalException(String message)
    {
        this.message = message;
    }

    public String getDetailMessage()
    {
        return detailMessage;
    }

    public GlobalException setDetailMessage(String detailMessage)
    {
        this.detailMessage = detailMessage;
        return this;
    }

    @Override
    public String getMessage()
    {
        return message;
    }

    public GlobalException setMessage(String message)
    {
        this.message = message;
        return this;
    }
}