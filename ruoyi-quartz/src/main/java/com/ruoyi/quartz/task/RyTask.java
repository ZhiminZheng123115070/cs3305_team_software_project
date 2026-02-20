package com.ruoyi.quartz.task;

import org.springframework.stereotype.Component;
import com.ruoyi.common.utils.StringUtils;

/**
 * Scheduled Task Scheduling Test
 * 
 * @author ruoyi
 */
@Component("ryTask")
public class RyTask
{
    public void ryMultipleParams(String s, Boolean b, Long l, Double d, Integer i)
    {
        System.out.println(StringUtils.format("Execute multi-parameter method: String type {}, Boolean type {}, Long type {}, Double type {}, Integer type {}", s, b, l, d, i));
    }

    public void ryParams(String params)
    {
        System.out.println("Execute parameterized method: " + params);
    }

    public void ryNoParams()
    {
        System.out.println("Execute parameterless method");
    }
}
