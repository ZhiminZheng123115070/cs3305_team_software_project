package com.team6.service.healthService.impl;

import com.ruoyi.common.utils.SecurityUtils;
import com.team6.mapper.DietLogMapper;
import com.team6.mapper.NutritionRecordMapper;
import com.team6.pojo.DietLog;
import com.team6.pojo.NutritionRecord;
import com.team6.response.DietLogResponse;
import com.team6.response.NutritionRecordResponse;
import com.team6.response.StorageResponse;
import com.team6.response.UserInfoResponse;
import com.ruoyi.common.exception.ServiceException;
import com.team6.service.healthService.IHealthInfoService;
import com.team6.service.healthService.IUserInfoService;
import com.team6.service.productService.IProductService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;

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

    @Autowired
    private IUserInfoService userInfoService;

    private static final BigDecimal DEFAULT_DAILY_TARGET_KCAL = new BigDecimal("2000");

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
        log.setConsumptionRate(consumptionRate);
        log.setProductId(storage.getProductId());
        log.setUserId(userId);
        log.setEatenAt(LocalDateTime.now());
        dietLogMapper.addDietLog(log);

        productService.updateStorage(storageId, consumptionRate);

        return DietLogResponse.from(log);
    }

    @Override
    public NutritionRecordResponse getDailyCalories(String date) {
        Long userId = SecurityUtils.getUserId();
        LocalDate recordDate = (date == null || date.isEmpty()) ? LocalDate.now() : LocalDate.parse(date);

        NutritionRecord sum = nutritionRecordMapper.sumByUserIdAndRecordDate(userId, recordDate);
        NutritionRecordResponse resp = new NutritionRecordResponse();
        resp.setRecordDate(recordDate);
        resp.setEnergyKcal(toScale(sum != null && sum.getEnergyKcal() != null ? sum.getEnergyKcal() : BigDecimal.ZERO));
        resp.setFat(toScale(sum != null && sum.getFat() != null ? sum.getFat() : BigDecimal.ZERO));
        resp.setSaturatedFat(toScale(sum != null && sum.getSaturatedFat() != null ? sum.getSaturatedFat() : BigDecimal.ZERO));
        resp.setCarbohydrates(toScale(sum != null && sum.getCarbohydrates() != null ? sum.getCarbohydrates() : BigDecimal.ZERO));
        resp.setSugars(toScale(sum != null && sum.getSugars() != null ? sum.getSugars() : BigDecimal.ZERO));
        resp.setFiber(toScale(sum != null && sum.getFiber() != null ? sum.getFiber() : BigDecimal.ZERO));
        resp.setProteins(toScale(sum != null && sum.getProteins() != null ? sum.getProteins() : BigDecimal.ZERO));
        resp.setSalt(toScale(sum != null && sum.getSalt() != null ? sum.getSalt() : BigDecimal.ZERO));

        BigDecimal target = DEFAULT_DAILY_TARGET_KCAL;
        UserInfoResponse userInfo = userInfoService.getUserInfoByUserId();
        if (userInfo != null && userInfo.getBmr() != null && userInfo.getBmr().compareTo(BigDecimal.ZERO) > 0) {
            target = userInfo.getBmr();
        }
        resp.setTargetKcal(target.setScale(2, RoundingMode.HALF_UP));
        BigDecimal consumed = resp.getEnergyKcal();
        int percentage = target.compareTo(BigDecimal.ZERO) > 0
                ? consumed.multiply(BigDecimal.valueOf(100)).divide(target, 0, RoundingMode.HALF_UP).intValue()
                : 0;
        resp.setPercentage(Math.min(percentage, 100));
        return resp;
    }

    @Override
    public List<DietLogResponse> getDietLogList() {
        Long userId = SecurityUtils.getUserId();
        List<DietLogResponse> list = dietLogMapper.selectByUserIdOrderByEatenAtDescWithProduct(userId);
        return list == null ? Collections.emptyList() : list;
    }

    private static BigDecimal toScale(BigDecimal v) {
        return v == null ? BigDecimal.ZERO : v.setScale(2, RoundingMode.HALF_UP);
    }
}
