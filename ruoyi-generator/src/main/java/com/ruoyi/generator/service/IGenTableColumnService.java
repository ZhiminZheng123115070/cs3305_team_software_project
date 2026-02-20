package com.ruoyi.generator.service;

import java.util.List;
import com.ruoyi.generator.domain.GenTableColumn;

/**
 * Business Field Service Layer
 * 
 * @author ruoyi
 */
public interface IGenTableColumnService
{
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
     * Modify business field
     * 
     * @param genTableColumn Business field information
     * @return Result
     */
    public int updateGenTableColumn(GenTableColumn genTableColumn);

    /**
     * Delete business field information
     * 
     * @param ids Data IDs to delete
     * @return Result
     */
    public int deleteGenTableColumnByIds(String ids);
}
