package com.ruoyi.common.core.text;

import com.ruoyi.common.utils.StringUtils;

/**
 * String formatting
 * 
 * @author ruoyi
 */
public class StrFormatter
{
    public static final String EMPTY_JSON = "{}";
    public static final char C_BACKSLASH = '\\';
    public static final char C_DELIM_START = '{';
    public static final char C_DELIM_END = '}';

    /**
     * Format string<br>
     * This method simply replaces placeholder {} with parameters in order<br>
     * To output {}, use \\ to escape {, to output \ before {}, use double escape \\\\<br>
     * Example：<br>
     * Usually used：format("this is {} for {}", "a", "b") -> this is a for b<br>
     * Escape {}： format("this is \\{} for {}", "a", "b") -> this is \{} for a<br>
     * Escape \： format("this is \\\\{} for {}", "a", "b") -> this is \a for b<br>
     * 
     * @param strPattern String template
     * @param argArray Parameter list
     * @return Result
     */
    public static String format(final String strPattern, final Object... argArray)
    {
        if (StringUtils.isEmpty(strPattern) || StringUtils.isEmpty(argArray))
        {
            return strPattern;
        }
        final int strPatternLength = strPattern.length();

        // Initialize defined length for better performance
        StringBuilder sbuf = new StringBuilder(strPatternLength + 50);

        int handledPosition = 0;
        int delimIndex;// Placeholder position
        for (int argIndex = 0; argIndex < argArray.length; argIndex++)
        {
            delimIndex = strPattern.indexOf(EMPTY_JSON, handledPosition);
            if (delimIndex == -1)
            {
                if (handledPosition == 0)
                {
                    return strPattern;
                }
                else
                { // Remaining part of string template no longer contains placeholders, append remaining part and return result
                    sbuf.append(strPattern, handledPosition, strPatternLength);
                    return sbuf.toString();
                }
            }
            else
            {
                if (delimIndex > 0 && strPattern.charAt(delimIndex - 1) == C_BACKSLASH)
                {
                    if (delimIndex > 1 && strPattern.charAt(delimIndex - 2) == C_BACKSLASH)
                    {
                        // There is another escape character before the escape character, placeholder is still valid
                        sbuf.append(strPattern, handledPosition, delimIndex - 1);
                        sbuf.append(Convert.utf8Str(argArray[argIndex]));
                        handledPosition = delimIndex + 2;
                    }
                    else
                    {
                        // Placeholder is escaped
                        argIndex--;
                        sbuf.append(strPattern, handledPosition, delimIndex - 1);
                        sbuf.append(C_DELIM_START);
                        handledPosition = delimIndex + 1;
                    }
                }
                else
                {
                    // Normal placeholder
                    sbuf.append(strPattern, handledPosition, delimIndex);
                    sbuf.append(Convert.utf8Str(argArray[argIndex]));
                    handledPosition = delimIndex + 2;
                }
            }
        }
        // Add all characters after the last placeholder
        sbuf.append(strPattern, handledPosition, strPattern.length());

        return sbuf.toString();
    }
}
