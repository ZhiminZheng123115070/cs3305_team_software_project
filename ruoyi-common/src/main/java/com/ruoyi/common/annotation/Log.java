package com.ruoyi.common.annotation;

import java.lang.annotation.Documented;
import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.common.enums.OperatorType;

/**
 * Custom operation log recording annotation
 * 
 * @author ruoyi
 *
 */
@Target({ ElementType.PARAMETER, ElementType.METHOD })
@Retention(RetentionPolicy.RUNTIME)
@Documented
public @interface Log
{
    /**
     * Module
     */
    public String title() default "";

    /**
     * Function
     */
    public BusinessType businessType() default BusinessType.OTHER;

    /**
     * Operator type
     */
    public OperatorType operatorType() default OperatorType.MANAGE;

    /**
     * Whether to save request parameters
     */
    public boolean isSaveRequestData() default true;

    /**
     * Whether to save response parameters
     */
    public boolean isSaveResponseData() default true;

    /**
     * Exclude specified request parameters
     */
    public String[] excludeParamNames() default {};
}
