package com.ruoyi.generator.mapper;

import java.util.List;
import com.ruoyi.generator.domain.GenTable;

/**
 * Business Data Layer
 * 
 * @author ruoyi
 */
public interface GenTableMapper
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
     * Query business information by table ID
     * 
     * @param id Business ID
     * @return Business information
     */
    public GenTable selectGenTableById(Long id);

    /**
     * Query business information by table name
     * 
     * @param tableName Table name
     * @return Business information
     */
    public GenTable selectGenTableByName(String tableName);

    /**
     * Add business
     * 
     * @param genTable Business information
     * @return Result
     */
    public int insertGenTable(GenTable genTable);

    /**
     * Update business
     * 
     * @param genTable Business information
     * @return Result
     */
    public int updateGenTable(GenTable genTable);

    /**
     * Batch delete business
     * 
     * @param ids Data IDs to delete
     * @return Result
     */
    public int deleteGenTableByIds(Long[] ids);

    /**
     * Create table
     *
     * @param sql Table structure
     * @return Result
     */
    public int createTable(String sql);
}
