package com.team6.service.healthService;

import com.team6.pojo.DietLog;
import com.team6.response.DietLogResponse;

import java.math.BigDecimal;

/**
 * @author zhimin
 * 2026/2/18 00:24
 */
public interface IHealthInfoService {

    public DietLogResponse addDietLog(Long storageId, BigDecimal consumptionRate);
}
