package com.ruoyi.web.controller.system;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.ruoyi.common.config.RuoYiConfig;
import com.ruoyi.common.utils.StringUtils;

/**
 * Homepage
 *
 * @author ruoyi
 */
@RestController
public class SysIndexController
{
    /** System Basic Configuration */
    @Autowired
    private RuoYiConfig ruoyiConfig;

    /**
     * Access Homepage, Prompt Message
     */
    @RequestMapping("/")
    public String index()
    {
        return StringUtils.format("Welcome to use {} backend management framework, current version: v{}, please access through the frontend address.", ruoyiConfig.getName(), ruoyiConfig.getVersion());
    }
}
