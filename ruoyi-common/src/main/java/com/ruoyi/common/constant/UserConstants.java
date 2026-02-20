package com.ruoyi.common.constant;

/**
 * User Constants Information
 * 
 * @author ruoyi
 */
public class UserConstants
{
    /**
     * Unique identifier for system users within the platform
     */
    public static final String SYS_USER = "SYS_USER";

    /** Normal status */
    public static final String NORMAL = "0";

    /** Exception status */
    public static final String EXCEPTION = "1";

    /** User disabled status */
    public static final String USER_DISABLE = "1";

    /** Role normal status */
    public static final String ROLE_NORMAL = "0";

    /** Role disabled status */
    public static final String ROLE_DISABLE = "1";

    /** Department normal status */
    public static final String DEPT_NORMAL = "0";

    /** Department disabled status */
    public static final String DEPT_DISABLE = "1";

    /** Dictionary normal status */
    public static final String DICT_NORMAL = "0";

    /** Whether system default (Yes) */
    public static final String YES = "Y";

    /** Whether menu external link (Yes) */
    public static final String YES_FRAME = "0";

    /** Whether menu external link (No) */
    public static final String NO_FRAME = "1";

    /** Menu type (Directory) */
    public static final String TYPE_DIR = "M";

    /** Menu type (Menu) */
    public static final String TYPE_MENU = "C";

    /** Menu type (Button) */
    public static final String TYPE_BUTTON = "F";

    /** Layout component identifier */
    public final static String LAYOUT = "Layout";
    
    /** ParentView component identifier */
    public final static String PARENT_VIEW = "ParentView";

    /** InnerLink component identifier */
    public final static String INNER_LINK = "InnerLink";

    /** Return identifier for validation whether unique */
    public final static boolean UNIQUE = true;
    public final static boolean NOT_UNIQUE = false;

    /**
     * Username length limit
     */
    public static final int USERNAME_MIN_LENGTH = 2;
    public static final int USERNAME_MAX_LENGTH = 20;

    /**
     * Password length limit
     */
    public static final int PASSWORD_MIN_LENGTH = 5;
    public static final int PASSWORD_MAX_LENGTH = 20;
}
