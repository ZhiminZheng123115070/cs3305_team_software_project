package com.team6.mapper;

import com.team6.pojo.NutritionRecord;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.math.BigDecimal;
import java.time.LocalDate;

/**
 * @author zhimin
 * 2026/2/18 00:59
 */
@Mapper
public interface NutritionRecordMapper {

    int insert(NutritionRecord record);

    BigDecimal sumEnergyKcalByUserIdAndRecordDate(@Param("userId") Long userId, @Param("recordDate") LocalDate recordDate);

    NutritionRecord sumByUserIdAndRecordDate(@Param("userId") Long userId, @Param("recordDate") LocalDate recordDate);
}
