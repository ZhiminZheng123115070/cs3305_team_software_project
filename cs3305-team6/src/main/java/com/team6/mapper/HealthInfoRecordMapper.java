package com.team6.mapper;

import com.team6.pojo.HealthInfoRecord;
import org.apache.ibatis.annotations.Mapper;

/**
 * @author zhimin
 * 2026/2/18 01:02
 */
@Mapper
public interface HealthInfoRecordMapper {

    int insert(HealthInfoRecord record);
}
