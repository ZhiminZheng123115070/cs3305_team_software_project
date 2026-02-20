package com.ruoyi.common.annotation;

import java.lang.annotation.Documented;
import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**
 * Data permission filtering annotation
 * 
 * @author ruoyi
 */
@Target(ElementType.METHOD)
@Retention(RetentionPolicy.RUNTIME)
@Documented
public @interface DataScope
{
    /**
     * Department table alias
     */
    public String deptAlias() default "";

    /**
     * User table alias
     */
    public String userAlias() default "";

    /**
     * Permission string (used for multiple roles to match required permissions), default is obtained from permission annotation @ss, multiple permissions separated by commas
     */
    public String permission() default "";
}
