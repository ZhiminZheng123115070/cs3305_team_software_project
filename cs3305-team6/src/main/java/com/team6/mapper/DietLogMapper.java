package com.team6.mapper;

import com.team6.pojo.DietLog;
import org.apache.ibatis.annotations.Mapper;

/**
 * @author zhimin
 *  2026/2/18 00:58
 */
@Mapper
public interface DietLogMapper {

    /** 插入一条饮食记录，useGeneratedKeys 会回填 log.id；返回插入后的 log（含 id）便于转 Response */
    default DietLog addDietLog(DietLog log) {
        insertDietLog(log);
        return log;
    }

    int insertDietLog(DietLog log);
}
