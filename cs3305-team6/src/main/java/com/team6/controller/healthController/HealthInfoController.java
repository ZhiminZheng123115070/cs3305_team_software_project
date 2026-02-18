package com.team6.controller.healthController;

import com.ruoyi.common.core.domain.AjaxResult;
import com.team6.service.healthService.IHealthInfoService;
import org.aspectj.weaver.loadtime.Aj;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.math.BigDecimal;

/**
 * @author zhimin
 * 2026/2/18 01:06
 */
@RestController
@RequestMapping("/user/info/health")
public class HealthInfoController {
    @Autowired
    private IHealthInfoService healthInfoService;

    @PostMapping
    public AjaxResult addDietLog(@RequestParam("storage_id")Long storageId,
                                 @RequestParam("consumption_rate")BigDecimal consumptionRate){
        return AjaxResult.success(healthInfoService.addDietLog(storageId,consumptionRate));
    }
}
