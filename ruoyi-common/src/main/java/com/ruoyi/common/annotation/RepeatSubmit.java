package com.ruoyi.common.annotation;

import java.lang.annotation.Documented;
import java.lang.annotation.ElementType;
import java.lang.annotation.Inherited;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**
 * Custom annotation to prevent duplicate form submission
 * 
 * @author ruoyi
 *
 */
@Inherited
@Target(ElementType.METHOD)
@Retention(RetentionPolicy.RUNTIME)
@Documented
public @interface RepeatSubmit
{
    /**
     * Interval time (ms), submissions within this time are considered duplicate
     */
    public int interval() default 5000;

    /**
     * Prompt message
     */
    public String message() default "Duplicate submission is not allowed, please try again later";
}
