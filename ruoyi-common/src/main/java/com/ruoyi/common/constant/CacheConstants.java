package com.ruoyi.common.constant;

/**
 * Cache Key Constants
 * 
 * @author ruoyi
 */
public class CacheConstants
{
    /**
     * Login user redis key
     */
    public static final String LOGIN_TOKEN_KEY = "login_tokens:";

    /**
     * Captcha redis key
     */
    public static final String CAPTCHA_CODE_KEY = "captcha_codes:";

    /**
     * Parameter management cache key
     */
    public static final String SYS_CONFIG_KEY = "sys_config:";

    /**
     * Dictionary management cache key
     */
    public static final String SYS_DICT_KEY = "sys_dict:";

    /**
     * Repeat submit prevention redis key
     */
    public static final String REPEAT_SUBMIT_KEY = "repeat_submit:";

    /**
     * Rate limit redis key
     */
    public static final String RATE_LIMIT_KEY = "rate_limit:";

    /**
     * Login account password error count redis key
     */
    public static final String PWD_ERR_CNT_KEY = "pwd_err_cnt:";
}
