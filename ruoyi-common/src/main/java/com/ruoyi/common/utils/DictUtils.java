package com.ruoyi.common.utils;

import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import com.alibaba.fastjson2.JSONArray;
import com.ruoyi.common.constant.CacheConstants;
import com.ruoyi.common.core.domain.entity.SysDictData;
import com.ruoyi.common.core.redis.RedisCache;
import com.ruoyi.common.utils.spring.SpringUtils;

/**
 * Dictionary utility class
 * 
 * @author ruoyi
 */
public class DictUtils
{
    /**
     * Separator
     */
    public static final String SEPARATOR = ",";

    /**
     * Set dictionary cache
     * 
     * @param key Parameter key
     * @param dictDatas Dictionary data list
     */
    public static void setDictCache(String key, List<SysDictData> dictDatas)
    {
        SpringUtils.getBean(RedisCache.class).setCacheObject(getCacheKey(key), dictDatas);
    }

    /**
     * Get dictionary cache
     * 
     * @param key Parameter key
     * @return dictDatas Dictionary data list
     */
    public static List<SysDictData> getDictCache(String key)
    {
        JSONArray arrayCache = SpringUtils.getBean(RedisCache.class).getCacheObject(getCacheKey(key));
        if (StringUtils.isNotNull(arrayCache))
        {
            return arrayCache.toList(SysDictData.class);
        }
        return null;
    }

    /**
     * Get dictionary label based on dictionary type and dictionary value
     * 
     * @param dictType Dictionary type
     * @param dictValue Dictionary value
     * @return Dictionary label
     */
    public static String getDictLabel(String dictType, String dictValue)
    {
        if (StringUtils.isEmpty(dictValue))
        {
            return StringUtils.EMPTY;
        }
        return getDictLabel(dictType, dictValue, SEPARATOR);
    }

    /**
     * Get dictionary value based on dictionary type and dictionary label
     * 
     * @param dictType Dictionary type
     * @param dictLabel Dictionary label
     * @return Dictionary value
     */
    public static String getDictValue(String dictType, String dictLabel)
    {
        if (StringUtils.isEmpty(dictLabel))
        {
            return StringUtils.EMPTY;
        }
        return getDictValue(dictType, dictLabel, SEPARATOR);
    }

    /**
     * Get dictionary label based on dictionary type and dictionary value
     * 
     * @param dictType Dictionary type
     * @param dictValue Dictionary value
     * @param separator Separator
     * @return Dictionary label
     */
    public static String getDictLabel(String dictType, String dictValue, String separator)
    {
        List<SysDictData> datas = getDictCache(dictType);
        if (StringUtils.isNull(datas) || StringUtils.isEmpty(dictValue))
        {
            return StringUtils.EMPTY;
        }
        Map<String, String> dictMap = datas.stream().collect(HashMap::new, (map, dict) -> map.put(dict.getDictValue(), dict.getDictLabel()), Map::putAll);
        if (!StringUtils.contains(dictValue, separator))
        {
            return dictMap.getOrDefault(dictValue, StringUtils.EMPTY);
        }
        StringBuilder labelBuilder = new StringBuilder();
        for (String seperatedValue : dictValue.split(separator))
        {
            if (dictMap.containsKey(seperatedValue))
            {
                labelBuilder.append(dictMap.get(seperatedValue)).append(separator);
            }
        }
        return StringUtils.removeEnd(labelBuilder.toString(), separator);
    }

    /**
     * Get dictionary value based on dictionary type and dictionary label
     * 
     * @param dictType Dictionary type
     * @param dictLabel Dictionary label
     * @param separator Separator
     * @return Dictionary value
     */
    public static String getDictValue(String dictType, String dictLabel, String separator)
    {
        List<SysDictData> datas = getDictCache(dictType);
        if (StringUtils.isNull(datas) || StringUtils.isEmpty(dictLabel))
        {
            return StringUtils.EMPTY;
        }
        Map<String, String> dictMap = datas.stream().collect(HashMap::new, (map, dict) -> map.put(dict.getDictLabel(), dict.getDictValue()), Map::putAll);
        if (!StringUtils.contains(dictLabel, separator))
        {
            return dictMap.getOrDefault(dictLabel, StringUtils.EMPTY);
        }
        StringBuilder valueBuilder = new StringBuilder();
        for (String seperatedValue : dictLabel.split(separator))
        {
            if (dictMap.containsKey(seperatedValue))
            {
                valueBuilder.append(dictMap.get(seperatedValue)).append(separator);
            }
        }
        return StringUtils.removeEnd(valueBuilder.toString(), separator);
    }

    /**
     * Get all dictionary values based on dictionary type
     *
     * @param dictType Dictionary type
     * @return Dictionary values
     */
    public static String getDictValues(String dictType)
    {
        StringBuilder propertyString = new StringBuilder();
        List<SysDictData> datas = getDictCache(dictType);
        if (StringUtils.isNull(datas))
        {
            return StringUtils.EMPTY;
        }
        for (SysDictData dict : datas)
        {
            propertyString.append(dict.getDictValue()).append(SEPARATOR);
        }
        return StringUtils.stripEnd(propertyString.toString(), SEPARATOR);
    }

    /**
     * Get all dictionary labels based on dictionary type
     *
     * @param dictType Dictionary type
     * @return Dictionary labels
     */
    public static String getDictLabels(String dictType)
    {
        StringBuilder propertyString = new StringBuilder();
        List<SysDictData> datas = getDictCache(dictType);
        if (StringUtils.isNull(datas))
        {
            return StringUtils.EMPTY;
        }
        for (SysDictData dict : datas)
        {
            propertyString.append(dict.getDictLabel()).append(SEPARATOR);
        }
        return StringUtils.stripEnd(propertyString.toString(), SEPARATOR);
    }

    /**
     * Remove specified dictionary cache
     * 
     * @param key Dictionary key
     */
    public static void removeDictCache(String key)
    {
        SpringUtils.getBean(RedisCache.class).deleteObject(getCacheKey(key));
    }

    /**
     * Clear dictionary cache
     */
    public static void clearDictCache()
    {
        Collection<String> keys = SpringUtils.getBean(RedisCache.class).keys(CacheConstants.SYS_DICT_KEY + "*");
        SpringUtils.getBean(RedisCache.class).deleteObject(keys);
    }

    /**
     * Set cache key
     * 
     * @param configKey Parameter key
     * @return Cache key
     */
    public static String getCacheKey(String configKey)
    {
        return CacheConstants.SYS_DICT_KEY + configKey;
    }
}
