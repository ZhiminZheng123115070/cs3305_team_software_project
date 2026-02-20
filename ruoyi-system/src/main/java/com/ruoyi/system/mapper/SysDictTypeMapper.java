package com.ruoyi.system.mapper;

import java.util.List;
import com.ruoyi.common.core.domain.entity.SysDictType;

/**
 * Dictionary Table Data Layer
 * 
 * @author ruoyi
 */
public interface SysDictTypeMapper
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
     * Delete Dictionary Information by Dictionary ID
     * 
     * @param dictId Dictionary ID
     * @return Result
     */
    public int deleteDictTypeById(Long dictId);

    /**
     * Batch Delete Dictionary Type Information
     * 
     * @param dictIds Dictionary IDs to Delete
     * @return Result
     */
    public int deleteDictTypeByIds(Long[] dictIds);

    /**
     * Add Dictionary Type Information
     * 
     * @param dictType Dictionary Type Information
     * @return Result
     */
    public int insertDictType(SysDictType dictType);

    /**
     * Modify Dictionary Type Information
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
    public SysDictType checkDictTypeUnique(String dictType);
}
