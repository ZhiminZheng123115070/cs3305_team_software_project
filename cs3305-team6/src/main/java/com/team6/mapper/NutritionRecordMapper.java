package com.team6.mapper;

import com.team6.pojo.NutritionRecord;
import org.apache.ibatis.annotations.Mapper;

/**
 * @author zhimin
 * 2026/2/18 00:59
 */
@Mapper
public interface NutritionRecordMapper {

    int insert(NutritionRecord record);
}
