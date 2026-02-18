package com.team6.mapper;

import com.team6.pojo.HealthInfoRecord;
import com.team6.response.HealthInfoRecordResponse;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

/**
 * @author zhimin
 * 2026/2/18 01:02
 */
@Mapper
public interface HealthInfoRecordMapper {

    int insert(HealthInfoRecord record);

    List<HealthInfoRecord> getRecordsByUserId(Long userId);
}
