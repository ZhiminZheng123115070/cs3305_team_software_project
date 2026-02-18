package com.team6.service.healthService.impl;

import com.ruoyi.common.utils.SecurityUtils;
import com.team6.mapper.DietLogMapper;
import com.team6.mapper.NutritionRecordMapper;
import com.team6.pojo.DietLog;
import com.team6.pojo.NutritionRecord;
import com.team6.response.DietLogResponse;
import com.team6.response.StorageResponse;
import com.ruoyi.common.exception.ServiceException;
import com.team6.service.healthService.IHealthInfoService;
import com.team6.service.productService.IProductService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * @author zhimin
 * 2026/2/18 00:25
 */

@Service
public class HealthInfoService implements IHealthInfoService {

    @Autowired
    private DietLogMapper dietLogMapper;

    @Autowired
    private IProductService productService;

    @Autowired
    private NutritionRecordMapper nutritionRecordMapper;

    /** 安全计算 value * rate，null 视为 0，结果保留 2 位小数 */
    private static BigDecimal multiplyScale(BigDecimal value, BigDecimal rate) {
        if (value == null || rate == null) return BigDecimal.ZERO;
        return value.multiply(rate).setScale(2, RoundingMode.HALF_UP);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public DietLogResponse addDietLog(Long storageId, BigDecimal consumptionRate) {
        Long userId = SecurityUtils.getUserId();

        StorageResponse storage = productService.findStorageById(storageId);
        if (storage == null) {
            throw new ServiceException("Storage not found");
        }
        // 越权校验：只能操作自己的库存
        if (!userId.equals(storage.getUserId())) {
            throw new ServiceException("Storage does not belong to current user");
        }
        if (storage.getConsumption() == null || consumptionRate == null) {
            throw new ServiceException("Consumption data is invalid");
        }
        if (consumptionRate.compareTo(BigDecimal.ZERO) <= 0) {
            throw new ServiceException("Consumption rate must be positive");
        }
        if (storage.getConsumption().compareTo(consumptionRate) < 0) {
            throw new ServiceException("Insufficient stock in storage");
        }

        // totalKcal = storage total energy × consumption rate (e.g. 0.5 = half portion)
        BigDecimal energyKcal = storage.getEnergyKcal() != null ? storage.getEnergyKcal() : BigDecimal.ZERO;
        BigDecimal totalKcal = energyKcal.multiply(consumptionRate).setScale(2, RoundingMode.HALF_UP);

        // 先写饮食记录和营养记录，最后再扣库存，避免扣了库存但写库失败导致数据不一致
        NutritionRecord record = new NutritionRecord();
        record.setUserId(userId);
        record.setRecordDate(LocalDate.now());
        record.setEnergyKcal(totalKcal);
        record.setFat(multiplyScale(storage.getFat(), consumptionRate));
        record.setSaturatedFat(multiplyScale(storage.getSaturatedFat(), consumptionRate));
        record.setCarbohydrates(multiplyScale(storage.getCarbohydrates(), consumptionRate));
        record.setSugars(multiplyScale(storage.getSugars(), consumptionRate));
        record.setFiber(multiplyScale(storage.getFiber(), consumptionRate));
        record.setProteins(multiplyScale(storage.getProteins(), consumptionRate));
        record.setSalt(multiplyScale(storage.getSalt(), consumptionRate));
        nutritionRecordMapper.insert(record);

        DietLog log = new DietLog();
        log.setCaloriesKcal(totalKcal);
        log.setProductId(storage.getProductId());
        log.setUserId(userId);
        log.setEatenAt(LocalDateTime.now());
        dietLogMapper.addDietLog(log);

        productService.updateStorage(storageId, consumptionRate);

        return DietLogResponse.from(log);
    }
}
