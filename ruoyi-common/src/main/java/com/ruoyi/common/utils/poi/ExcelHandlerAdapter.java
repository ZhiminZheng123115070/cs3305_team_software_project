package com.ruoyi.common.utils.poi;

import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Workbook;

/**
 * Excel data format processing adapter
 * 
 * @author ruoyi
 */
public interface ExcelHandlerAdapter
{
    /**
     * Format
     * 
     * @param value Cell data value
     * @param args Excel annotation args parameter group
     * @param cell Cell object
     * @param wb Workbook object
     *
     * @return Processed value
     */
    Object format(Object value, String[] args, Cell cell, Workbook wb);
}
