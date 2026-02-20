package com.ruoyi.common.utils;

import org.springframework.context.MessageSource;
import org.springframework.context.i18n.LocaleContextHolder;
import com.ruoyi.common.utils.spring.SpringUtils;

/**
 * Get i18n Resource File
 * 
 * @author ruoyi
 */
public class MessageUtils
{
    /**
     * Get message based on message key and parameters, delegate to spring messageSource
     *
     * @param code Message key
     * @param args Parameters
     * @return Get internationalized translation value
     */
    public static String message(String code, Object... args)
    {
        MessageSource messageSource = SpringUtils.getBean(MessageSource.class);
        return messageSource.getMessage(code, args, LocaleContextHolder.getLocale());
    }
}
