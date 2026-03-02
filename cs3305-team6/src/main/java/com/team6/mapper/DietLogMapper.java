package com.team6.mapper;

import com.team6.pojo.DietLog;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * @author zhimin
 *  2026/2/18 00:58
 */
@Mapper
public interface DietLogMapper {

    default DietLog addDietLog(DietLog log) {
        insertDietLog(log);
        return log;
    }

    int insertDietLog(DietLog log);

    List<DietLog> selectByUserIdOrderByEatenAtDesc(@Param("userId") Long userId);

    List<com.team6.response.DietLogResponse> selectByUserIdOrderByEatenAtDescWithProduct(@Param("userId") Long userId);
}
