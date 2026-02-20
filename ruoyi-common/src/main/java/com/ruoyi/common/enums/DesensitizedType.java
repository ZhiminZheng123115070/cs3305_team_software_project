package com.ruoyi.common.enums;

import java.util.function.Function;
import com.ruoyi.common.utils.DesensitizedUtil;

/**
 * Desensitization Type
 *
 * @author ruoyi
 */
public enum DesensitizedType
{
    /**
     * Username, replace 2nd character with asterisk
     */
    USERNAME(s -> s.replaceAll("(\\S)\\S(\\S*)", "$1*$2")),

    /**
     * Password, replace all characters with *
     */
    PASSWORD(DesensitizedUtil::password),

    /**
     * ID card, replace middle 10 digits with asterisks
     */
    ID_CARD(s -> s.replaceAll("(\\d{4})\\d{10}(\\d{3}[Xx]|\\d{4})", "$1** **** ****$2")),

    /**
     * Phone number, replace middle 4 digits with asterisks
     */
    PHONE(s -> s.replaceAll("(\\d{3})\\d{4}(\\d{4})", "$1****$2")),

    /**
     * Email, only show first letter and address after @, replace others with asterisks
     */
    EMAIL(s -> s.replaceAll("(^.)[^@]*(@.*$)", "$1****$2")),

    /**
     * Bank card number, keep last 4 digits, replace others with asterisks
     */
    BANK_CARD(s -> s.replaceAll("\\d{15}(\\d{3})", "**** **** **** **** $1")),

    /**
     * Car license plate number, including regular vehicles and new energy vehicles
     */
    CAR_LICENSE(DesensitizedUtil::carLicense);

    private final Function<String, String> desensitizer;

    DesensitizedType(Function<String, String> desensitizer)
    {
        this.desensitizer = desensitizer;
    }

    public Function<String, String> desensitizer()
    {
        return desensitizer;
    }
}
