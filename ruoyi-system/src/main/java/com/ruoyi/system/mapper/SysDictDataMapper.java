package com.ruoyi.system.mapper;

import java.util.List;
import org.apache.ibatis.annotations.Param;
import com.ruoyi.common.core.domain.entity.SysDictData;

/**
 * Dictionary Table Data Layer
 * 
 * @author ruoyi
 */
public interface SysDictDataMapper
{
    /**
     * Query Dictionary Data by Conditions with Pagination
     * 
     * @param dictData Dictionary Data Information
     * @return Dictionary Data Collection
     */
    public List<SysDictData> selectDictDataList(SysDictData dictData);

    /**
     * Query Dictionary Data by Dictionary Type
     * 
     * @param dictType Dictionary Type
     * @return Dictionary Data Collection
     */
    public List<SysDictData> selectDictDataByType(String dictType);

    /**
     * Query Dictionary Data Information by Dictionary Type and Dictionary Key Value
     * 
     * @param dictType Dictionary Type
     * @param dictValue Dictionary Key Value
     * @return Dictionary Label
     */
    public String selectDictLabel(@Param("dictType") String dictType, @Param("dictValue") String dictValue);

    /**
     * Query Information by Dictionary Data ID
     * 
     * @param dictCode Dictionary Data ID
     * @return Dictionary Data
     */
    public SysDictData selectDictDataById(Long dictCode);

    /**
     * Query Dictionary Data
     * 
     * @param dictType Dictionary Type
     * @return Dictionary Data
     */
    public int countDictDataByType(String dictType);

    /**
     * Delete Dictionary Data Information by Dictionary ID
     * 
     * @param dictCode Dictionary Data ID
     * @return Result
     */
    public int deleteDictDataById(Long dictCode);

    /**
     * Batch Delete Dictionary Data Information
     * 
     * @param dictCodes Dictionary Data IDs to Delete
     * @return Result
     */
    public int deleteDictDataByIds(Long[] dictCodes);

    /**
     * Add Dictionary Data Information
     * 
     * @param dictData Dictionary Data Information
     * @return Result
     */
    public int insertDictData(SysDictData dictData);

    /**
     * Modify Dictionary Data Information
     * 
     * @param dictData Dictionary Data Information
     * @return Result
     */
    public int updateDictData(SysDictData dictData);

    /**
     * Synchronously Modify Dictionary Type
     * 
     * @param oldDictType Old Dictionary Type
     * @param newDictType New Dictionary Type
     * @return Result
     */
    public int updateDictDataType(@Param("oldDictType") String oldDictType, @Param("newDictType") String newDictType);
}
