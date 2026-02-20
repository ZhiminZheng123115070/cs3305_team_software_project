package com.ruoyi.common.constant;

import java.util.Locale;
import io.jsonwebtoken.Claims;

/**
 * Common constant information
 * 
 * @author ruoyi
 */
public class Constants
{
    /**
     * UTF-8 character set
     */
    public static final String UTF8 = "UTF-8";

    /**
     * GBK character set
     */
    public static final String GBK = "GBK";

    /**
     * System language
     */
    public static final Locale DEFAULT_LOCALE = Locale.SIMPLIFIED_CHINESE;

    /**
     * www main domain
     */
    public static final String WWW = "www.";

    /**
     * http request
     */
    public static final String HTTP = "http://";

    /**
     * https request
     */
    public static final String HTTPS = "https://";

    /**
     * Common success identifier
     */
    public static final String SUCCESS = "0";

    /**
     * Common failure identifier
     */
    public static final String FAIL = "1";

    /**
     * Login success
     */
    public static final String LOGIN_SUCCESS = "Success";

    /**
     * Logout
     */
    public static final String LOGOUT = "Logout";

    /**
     * Register
     */
    public static final String REGISTER = "Register";

    /**
     * Login failure
     */
    public static final String LOGIN_FAIL = "Error";

    /**
     * All permission identifier
     */
    public static final String ALL_PERMISSION = "*:*:*";

    /**
     * Administrator role permission identifier
     */
    public static final String SUPER_ADMIN = "admin";

    /**
     * Role permission delimiter
     */
    public static final String ROLE_DELIMITER = ",";

    /**
     * Permission identifier delimiter
     */
    public static final String PERMISSION_DELIMITER = ",";

    /**
     * Captcha expiration time (minutes)
     */
    public static final Integer CAPTCHA_EXPIRATION = 2;

    /**
     * Token
     */
    public static final String TOKEN = "token";

    /**
     * Token prefix
     */
    public static final String TOKEN_PREFIX = "Bearer ";

    /**
     * Login user key
     */
    public static final String LOGIN_USER_KEY = "login_user_key";

    /**
     * User ID
     */
    public static final String JWT_USERID = "userid";

    /**
     * User name
     */
    public static final String JWT_USERNAME = Claims.SUBJECT;

    /**
     * User avatar
     */
    public static final String JWT_AVATAR = "avatar";

    /**
     * Creation time
     */
    public static final String JWT_CREATED = "created";

    /**
     * User permissions
     */
    public static final String JWT_AUTHORITIES = "authorities";

    /**
     * Resource mapping path prefix
     */
    public static final String RESOURCE_PREFIX = "/profile";

    /**
     * RMI remote method invocation
     */
    public static final String LOOKUP_RMI = "rmi:";

    /**
     * LDAP remote method invocation
     */
    public static final String LOOKUP_LDAP = "ldap:";

    /**
     * LDAPS remote method invocation
     */
    public static final String LOOKUP_LDAPS = "ldaps:";

    /**
     * Auto-identify JSON object whitelist configuration (only allowed package names for parsing, smaller scope is safer)
     */
    public static final String[] JSON_WHITELIST_STR = { "com.ruoyi" };

    /**
     * Scheduled task whitelist configuration (only allowed package names for access, can be added as needed)
     */
    public static final String[] JOB_WHITELIST_STR = { "com.ruoyi.quartz.task" };

    /**
     * Scheduled task prohibited characters
     */
    public static final String[] JOB_ERROR_STR = { "java.net.URL", "javax.naming.InitialContext", "org.yaml.snakeyaml",
            "org.springframework", "org.apache", "com.ruoyi.common.utils.file", "com.ruoyi.common.config", "com.ruoyi.generator" };
}
