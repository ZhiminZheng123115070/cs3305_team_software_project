package com.ruoyi.generator.mapper;

import java.util.List;
import com.ruoyi.generator.domain.GenTableColumn;

/**
 * Business Field Data Layer
 * 
 * @author ruoyi
 */
public interface GenTableColumnMapper
{
    /**
     * Query column information by table name
     * 
     * @param tableName Table name
     * @return Column information
     */
    public List<GenTableColumn> selectDbTableColumnsByName(String tableName);

    /**
     * Query business field list
     * 
     * @param tableId Business field ID
     * @return Business field collection
     */
    public List<GenTableColumn> selectGenTableColumnListByTableId(Long tableId);

    /**
     * Add business field
     * 
     * @param genTableColumn Business field information
     * @return Result
     */
    public int insertGenTableColumn(GenTableColumn genTableColumn);

    /**
     * Update business field
     * 
     * @param genTableColumn Business field information
     * @return Result
     */
    public int updateGenTableColumn(GenTableColumn genTableColumn);

    /**
     * Delete business field
     * 
     * @param genTableColumns Column data
     * @return Result
     */
    public int deleteGenTableColumns(List<GenTableColumn> genTableColumns);

    /**
     * Batch delete business field
     * 
     * @param ids Data IDs to delete
     * @return Result
     */
    public int deleteGenTableColumnByIds(Long[] ids);
}
