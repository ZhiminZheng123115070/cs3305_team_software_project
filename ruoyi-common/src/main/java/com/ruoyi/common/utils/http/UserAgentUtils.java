package com.ruoyi.common.utils.http;

import java.util.regex.Matcher;
import java.util.regex.Pattern;
import com.ruoyi.common.utils.StringUtils;
import nl.basjes.parse.useragent.UserAgent;
import nl.basjes.parse.useragent.UserAgentAnalyzer;

/**
 * UserAgent parsing utility class
 * 
 * @author ruoyi
 */
public class UserAgentUtils
{
    public static final String UNKNOWN = "";

    // Browser regular expression patterns
    private static final Pattern CHROME_PATTERN = Pattern.compile("Chrome/(\\d+)(?:\\.\\d+)*");
    private static final Pattern FIREFOX_PATTERN = Pattern.compile("Firefox/(\\d+)(?:\\.\\d+)*");
    private static final Pattern EDGE_PATTERN = Pattern.compile("Edg(?:e)?/(\\d+)(?:\\.\\d+)*");
    private static final Pattern SAFARI_PATTERN = Pattern.compile("Version/(\\d+)(?:\\.\\d+)*");
    private static final Pattern OPERA_PATTERN = Pattern.compile("Opera/(\\d+)(?:\\.\\d+)*");
    private static final Pattern IE_PATTERN = Pattern.compile("(?:MSIE |Trident/.*rv:)(\\d+)(?:\\.\\d+)*");
    private static final Pattern SAMSUNG_PATTERN = Pattern.compile("SamsungBrowser/(\\d+)(?:\\.\\d+)*");
    private static final Pattern UC_PATTERN = Pattern.compile("UCBrowser/(\\d+)(?:\\.\\d+)*");
    private static final Pattern QQ_PATTERN = Pattern.compile("QQBrowser/(\\d+)(?:\\.\\d+)*");
    private static final Pattern WECHAT_PATTERN = Pattern.compile("MicroMessenger/(\\d+)(?:\\.\\d+)*");
    private static final Pattern BAIDU_PATTERN = Pattern.compile("baidubrowser/(\\d+)(?:\\.\\d+)*");

    // Operating system regular expression patterns
    private static final Pattern WINDOWS_PATTERN = Pattern.compile("Windows NT (\\d+\\.\\d+)");
    private static final Pattern MACOS_PATTERN = Pattern.compile("Mac OS X (\\d+[_\\d]*)");
    private static final Pattern ANDROID_PATTERN = Pattern.compile("Android (\\d+)(?:\\.\\d+)*");
    private static final Pattern IOS_PATTERN = Pattern.compile("OS[\\s_](\\d+)(?:_\\d+)*");
    private static final Pattern LINUX_PATTERN = Pattern.compile("Linux");
    private static final Pattern CHROMEOS_PATTERN = Pattern.compile("CrOS");

    private static final UserAgentAnalyzer userAgentAnalyzer = UserAgentAnalyzer
            .newBuilder().hideMatcherLoadStats()
            .withCache(5000)
            .showMinimalVersion()
            .withField(UserAgent.AGENT_NAME_VERSION)
            .withField(UserAgent.OPERATING_SYSTEM_NAME_VERSION)
            .build();

    /**
     * Get client browser
     */
    public static String getBrowser(String userAgent)
    {
        UserAgent.ImmutableUserAgent iua = userAgentAnalyzer.parse(userAgent);
        String agentNameVersion = iua.get(UserAgent.AGENT_NAME_VERSION).getValue();
        if (StringUtils.isBlank(agentNameVersion) || agentNameVersion.contains("??"))
        {
            return formatBrowser(userAgent);
        }
        return agentNameVersion;
    }

    /**
     * Get client operating system
     */
    public static String getOperatingSystem(String userAgent)
    {
        UserAgent.ImmutableUserAgent iua = userAgentAnalyzer.parse(userAgent);
        String operatingSystemNameVersion = iua.get(UserAgent.OPERATING_SYSTEM_NAME_VERSION).getValue();
        if (StringUtils.isBlank(operatingSystemNameVersion) || operatingSystemNameVersion.contains("??"))
        {
            return formatOperatingSystem(userAgent);
        }
        return operatingSystemNameVersion;
    }

    /**
     * Comprehensive browser detection
     */
    private static String formatBrowser(String browser)
    {
        // Chrome browser series
        Matcher chromeMatcher = CHROME_PATTERN.matcher(browser);
        if (chromeMatcher.find() && (browser.contains("Chrome") || browser.contains("CriOS")))
        {
            return "Chrome" + chromeMatcher.group(1);
        }
        // Firefox
        Matcher firefoxMatcher = FIREFOX_PATTERN.matcher(browser);
        if (firefoxMatcher.find())
        {
            return "Firefox" + firefoxMatcher.group(1);
        }
        // Edge browser
        Matcher edgeMatcher = EDGE_PATTERN.matcher(browser);
        if (edgeMatcher.find())
        {
            return "Edge" + edgeMatcher.group(1);
        }
        // Safari browser (need to exclude Chrome)
        Matcher safariMatcher = SAFARI_PATTERN.matcher(browser);
        if (safariMatcher.find() && !browser.contains("Chrome"))
        {
            return "Safari" + safariMatcher.group(1);
        }
        // WeChat built-in browser
        Matcher wechatMatcher = WECHAT_PATTERN.matcher(browser);
        if (wechatMatcher.find())
        {
            return "WeChat" + wechatMatcher.group(1);
        }
        // UC browser
        Matcher ucMatcher = UC_PATTERN.matcher(browser);
        if (ucMatcher.find())
        {
            return "UC Browser" + ucMatcher.group(1);
        }
        // QQ browser
        Matcher qqMatcher = QQ_PATTERN.matcher(browser);
        if (qqMatcher.find())
        {
            return "QQ Browser" + qqMatcher.group(1);
        }
        // Baidu browser
        Matcher baiduMatcher = BAIDU_PATTERN.matcher(browser);
        if (baiduMatcher.find())
        {
            return "Baidu Browser" + baiduMatcher.group(1);
        }
        // Samsung browser
        Matcher samsungMatcher = SAMSUNG_PATTERN.matcher(browser);
        if (samsungMatcher.find())
        {
            return "Samsung Browser" + samsungMatcher.group(1);
        }
        // Opera browser
        Matcher operaMatcher = OPERA_PATTERN.matcher(browser);
        if (operaMatcher.find())
        {
            return "Opera" + operaMatcher.group(1);
        }
        // IE browser
        Matcher ieMatcher = IE_PATTERN.matcher(browser);
        if (ieMatcher.find())
        {
            return "Internet Explorer" + ieMatcher.group(1);
        }
        return UNKNOWN;
    }

    /**
     * Detect operating system
     */
    private static String formatOperatingSystem(String operatingSystem)
    {
        // Windows system
        Matcher windowsMatcher = WINDOWS_PATTERN.matcher(operatingSystem);
        if (windowsMatcher.find())
        {
            return "Windows" + getWindowsVersionDisplay(windowsMatcher.group(1));
        }
        // macOS system
        Matcher macMatcher = MACOS_PATTERN.matcher(operatingSystem);
        if (macMatcher.find())
        {
            String version = macMatcher.group(1).replace("_", ".");
            return "macOS" + extractMajorVersion(version);
        }
        // Android system
        Matcher androidMatcher = ANDROID_PATTERN.matcher(operatingSystem);
        if (androidMatcher.find())
        {
            return "Android" + extractMajorVersion(androidMatcher.group(1));
        }
        // iOS system
        Matcher iosMatcher = IOS_PATTERN.matcher(operatingSystem);
        if (iosMatcher.find() && (operatingSystem.contains("iPhone") || operatingSystem.contains("iPad")))
        {
            return "iOS" + extractMajorVersion(iosMatcher.group(1));
        }
        // Linux system
        if (LINUX_PATTERN.matcher(operatingSystem).find() && !operatingSystem.contains("Android"))
        {
            return "Linux";
        }
        // Chrome OS
        if (CHROMEOS_PATTERN.matcher(operatingSystem).find())
        {
            return "Chrome OS";
        }
        return UNKNOWN;
    }

    /**
     * Extract optimized major version number
     */
    private static String extractMajorVersion(String fullVersion)
    {
        if (StringUtils.isEmpty(fullVersion))
        {
            return StringUtils.EMPTY;
        }
        try
        {
            // Clean non-numeric characters from version number
            String cleanVersion = fullVersion.replaceAll("[^0-9.]", "");
            String[] parts = cleanVersion.split("\\.");
            if (parts.length > 0)
            {
                String firstPart = parts[0];
                if (firstPart.matches("\\d+"))
                {
                    int version = Integer.parseInt(firstPart);

                    // Handle three-digit version numbers (e.g., 142 -> 14)
                    if (version >= 100)
                    {
                        return String.valueOf(version / 10);
                    }
                    return firstPart;
                }
            }
        }
        catch (NumberFormatException e)
        {
            // Version number parsing failed, return original value
        }
        return fullVersion;
    }

    /**
     * Windows version number display optimization
     */
    private static String getWindowsVersionDisplay(String version)
    {
        switch (version)
        {
            case "10.0":
                return "10";
            case "6.3":
                return "8.1";
            case "6.2":
                return "8";
            case "6.1":
                return "7";
            case "6.0":
                return "Vista";
            case "5.1":
                return "XP";
            case "5.0":
                return "2000";
            default:
                return extractMajorVersion(version);
        }
    }
}
