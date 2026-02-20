package com.ruoyi.system.service;

import java.util.List;
import com.ruoyi.common.core.domain.entity.SysDictData;

/**
 * Dictionary Business Layer
 * 
 * @author ruoyi
 */
public interface ISysDictDataService
{
    /**
     * Query Dictionary Data by Conditions with Pagination
     * 
     * @param dictData Dictionary Data Information
     * @return Dictionary Data Collection
     */
    public List<SysDictData> selectDictDataList(SysDictData dictData);

    /**
     * Query Dictionary Data Information by Dictionary Type and Dictionary Key Value
     * 
     * @param dictType Dictionary Type
     * @param dictValue Dictionary Key Value
     * @return Dictionary Label
     */
    public String selectDictLabel(String dictType, String dictValue);

    /**
     * Query Information by Dictionary Data ID
     * 
     * @param dictCode Dictionary Data ID
     * @return Dictionary Data
     */
    public SysDictData selectDictDataById(Long dictCode);

    /**
     * Batch Delete Dictionary Data Information
     * 
     * @param dictCodes Dictionary Data IDs to Delete
     */
    public void deleteDictDataByIds(Long[] dictCodes);

    /**
     * Add and Save Dictionary Data Information
     * 
     * @param dictData Dictionary Data Information
     * @return Result
     */
    public int insertDictData(SysDictData dictData);

    /**
     * Modify and Save Dictionary Data Information
     * 
     * @param dictData Dictionary Data Information
     * @return Result
     */
    public int updateDictData(SysDictData dictData);
}
