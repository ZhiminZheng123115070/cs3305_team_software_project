package com.ruoyi.common.annotation;

import java.lang.annotation.Documented;
import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;
import com.ruoyi.common.constant.CacheConstants;
import com.ruoyi.common.enums.LimitType;

/**
 * Rate Limit Annotation
 * 
 * @author ruoyi
 */
@Target(ElementType.METHOD)
@Retention(RetentionPolicy.RUNTIME)
@Documented
public @interface RateLimiter
{
    /**
     * Rate limit key
     */
    public String key() default CacheConstants.RATE_LIMIT_KEY;

    /**
     * Rate limit time in seconds
     */
    public int time() default 60;

    /**
     * Rate limit count
     */
    public int count() default 100;

    /**
     * Rate limit type
     */
    public LimitType limitType() default LimitType.DEFAULT;
}
