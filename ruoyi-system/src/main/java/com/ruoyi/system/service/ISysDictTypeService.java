package com.ruoyi.system.service;

import java.util.List;
import com.ruoyi.common.core.domain.entity.SysDictData;
import com.ruoyi.common.core.domain.entity.SysDictType;

/**
 * Dictionary Business Layer
 * 
 * @author ruoyi
 */
public interface ISysDictTypeService
{
    /**
     * Query Dictionary Type by Conditions with Pagination
     * 
     * @param dictType Dictionary Type Information
     * @return Dictionary Type Collection
     */
    public List<SysDictType> selectDictTypeList(SysDictType dictType);

    /**
     * Query All Dictionary Types
     * 
     * @return Dictionary Type Collection
     */
    public List<SysDictType> selectDictTypeAll();

    /**
     * Query Dictionary Data by Dictionary Type
     * 
     * @param dictType Dictionary Type
     * @return Dictionary Data Collection
     */
    public List<SysDictData> selectDictDataByType(String dictType);

    /**
     * Query Information by Dictionary Type ID
     * 
     * @param dictId Dictionary Type ID
     * @return Dictionary Type
     */
    public SysDictType selectDictTypeById(Long dictId);

    /**
     * Query Information by Dictionary Type
     * 
     * @param dictType Dictionary Type
     * @return Dictionary Type
     */
    public SysDictType selectDictTypeByType(String dictType);

    /**
     * Batch Delete Dictionary Information
     * 
     * @param dictIds Dictionary IDs to Delete
     */
    public void deleteDictTypeByIds(Long[] dictIds);

    /**
     * Load Dictionary Cache Data
     */
    public void loadingDictCache();

    /**
     * Clear Dictionary Cache Data
     */
    public void clearDictCache();

    /**
     * Reset Dictionary Cache Data
     */
    public void resetDictCache();

    /**
     * Add and Save Dictionary Type Information
     * 
     * @param dictType Dictionary Type Information
     * @return Result
     */
    public int insertDictType(SysDictType dictType);

    /**
     * Modify and Save Dictionary Type Information
     * 
     * @param dictType Dictionary Type Information
     * @return Result
     */
    public int updateDictType(SysDictType dictType);

    /**
     * Validate if Dictionary Type Name is Unique
     * 
     * @param dictType Dictionary Type
     * @return Result
     */
    public boolean checkDictTypeUnique(SysDictType dictType);
}
