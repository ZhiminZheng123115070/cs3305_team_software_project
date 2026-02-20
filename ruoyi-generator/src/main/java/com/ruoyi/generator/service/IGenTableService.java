package com.ruoyi.generator.service;

import java.util.List;
import java.util.Map;
import com.ruoyi.generator.domain.GenTable;

/**
 * Business Service Layer
 * 
 * @author ruoyi
 */
public interface IGenTableService
{
    /**
     * Query business list
     * 
     * @param genTable Business information
     * @return Business collection
     */
    public List<GenTable> selectGenTableList(GenTable genTable);

    /**
     * Query database list
     * 
     * @param genTable Business information
     * @return Database table collection
     */
    public List<GenTable> selectDbTableList(GenTable genTable);

    /**
     * Query database list
     * 
     * @param tableNames Table name array
     * @return Database table collection
     */
    public List<GenTable> selectDbTableListByNames(String[] tableNames);

    /**
     * Query all table information
     * 
     * @return Table information collection
     */
    public List<GenTable> selectGenTableAll();

    /**
     * Query business information
     * 
     * @param id Business ID
     * @return Business information
     */
    public GenTable selectGenTableById(Long id);

    /**
     * Modify business
     * 
     * @param genTable Business information
     * @return Result
     */
    public void updateGenTable(GenTable genTable);

    /**
     * Delete business information
     * 
     * @param tableIds Table data IDs to delete
     * @return Result
     */
    public void deleteGenTableByIds(Long[] tableIds);

    /**
     * Create table
     *
     * @param sql Create table statement
     * @return Result
     */
    public boolean createTable(String sql);

    /**
     * Import table structure
     *
     * @param tableList Import table list
     * @param operName Operator
     */
    public void importGenTable(List<GenTable> tableList, String operName);

    /**
     * Preview code
     * 
     * @param tableId Table ID
     * @return Preview data list
     */
    public Map<String, String> previewCode(Long tableId);

    /**
     * Generate code (download method)
     * 
     * @param tableName Table name
     * @return Data
     */
    public byte[] downloadCode(String tableName);

    /**
     * Generate code (custom path)
     * 
     * @param tableName Table name
     * @return Data
     */
    public void generatorCode(String tableName);

    /**
     * Synchronize database
     * 
     * @param tableName Table name
     */
    public void synchDb(String tableName);

    /**
     * Batch generate code (download method)
     * 
     * @param tableNames Table array
     * @return Data
     */
    public byte[] downloadCode(String[] tableNames);

    /**
     * Modify save parameter validation
     * 
     * @param genTable Business information
     */
    public void validateEdit(GenTable genTable);
}
