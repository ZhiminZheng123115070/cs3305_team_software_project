package com.team6.service.healthService;

import com.team6.pojo.DietLog;
import com.team6.response.DietLogResponse;
import com.team6.response.NutritionRecordResponse;

import java.math.BigDecimal;
import java.util.List;

/**
 * @author zhimin
 * 2026/2/18 00:24
 */
public interface IHealthInfoService {

    DietLogResponse addDietLog(Long storageId, BigDecimal consumptionRate);

    NutritionRecordResponse getDailyCalories(String date);

    List<DietLogResponse> getDietLogList();
}
