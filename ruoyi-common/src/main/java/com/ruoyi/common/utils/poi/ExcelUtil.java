package com.ruoyi.common.utils.poi;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.lang.reflect.ParameterizedType;
import java.math.BigDecimal;
import java.text.DecimalFormat;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.Comparator;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.UUID;
import java.util.stream.Collectors;
import javax.servlet.http.HttpServletResponse;
import org.apache.commons.lang3.ArrayUtils;
import org.apache.commons.lang3.RegExUtils;
import org.apache.commons.lang3.reflect.FieldUtils;
import org.apache.poi.hssf.usermodel.HSSFClientAnchor;
import org.apache.poi.hssf.usermodel.HSSFPicture;
import org.apache.poi.hssf.usermodel.HSSFPictureData;
import org.apache.poi.hssf.usermodel.HSSFShape;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ooxml.POIXMLDocumentPart;
import org.apache.poi.ss.usermodel.BorderStyle;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.CellType;
import org.apache.poi.ss.usermodel.ClientAnchor;
import org.apache.poi.ss.usermodel.DataFormat;
import org.apache.poi.ss.usermodel.DataValidation;
import org.apache.poi.ss.usermodel.DataValidationConstraint;
import org.apache.poi.ss.usermodel.DataValidationHelper;
import org.apache.poi.ss.usermodel.DateUtil;
import org.apache.poi.ss.usermodel.Drawing;
import org.apache.poi.ss.usermodel.FillPatternType;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.HorizontalAlignment;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.usermodel.Name;
import org.apache.poi.ss.usermodel.PictureData;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.VerticalAlignment;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.usermodel.WorkbookFactory;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.ss.util.CellRangeAddressList;
import org.apache.poi.util.IOUtils;
import org.apache.poi.xssf.streaming.SXSSFWorkbook;
import org.apache.poi.xssf.usermodel.XSSFClientAnchor;
import org.apache.poi.xssf.usermodel.XSSFDataValidation;
import org.apache.poi.xssf.usermodel.XSSFDrawing;
import org.apache.poi.xssf.usermodel.XSSFPicture;
import org.apache.poi.xssf.usermodel.XSSFShape;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.openxmlformats.schemas.drawingml.x2006.spreadsheetDrawing.CTMarker;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.annotation.Excel.ColumnType;
import com.ruoyi.common.annotation.Excel.Type;
import com.ruoyi.common.annotation.Excels;
import com.ruoyi.common.config.RuoYiConfig;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.text.Convert;
import com.ruoyi.common.exception.UtilException;
import com.ruoyi.common.utils.DateUtils;
import com.ruoyi.common.utils.DictUtils;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.common.utils.file.FileTypeUtils;
import com.ruoyi.common.utils.file.FileUtils;
import com.ruoyi.common.utils.file.ImageUtils;
import com.ruoyi.common.utils.reflect.ReflectUtils;

/**
 * Excel Related Processing
 * 
 * @author ruoyi
 */
public class ExcelUtil<T>
{
    private static final Logger log = LoggerFactory.getLogger(ExcelUtil.class);

    public static final String SEPARATOR = ",";

    public static final String FORMULA_REGEX_STR = "=|-|\\+|@";

    public static final String[] FORMULA_STR = { "=", "-", "+", "@" };

    /**
     * Used for dictType attribute data storage to avoid repeated cache queries
     */
    public Map<String, String> sysDictMap = new HashMap<String, String>();

    /**
     * Excel sheet maximum row number, default 65536
     */
    public static final int sheetSize = 65536;

    /**
     * Worksheet name
     */
    private String sheetName;

    /**
     * Export type (EXPORT: export data; IMPORT: import template)
     */
    private Type type;

    /**
     * Workbook object
     */
    private Workbook wb;

    /**
     * Worksheet object
     */
    private Sheet sheet;

    /**
     * Style list
     */
    private Map<String, CellStyle> styles;

    /**
     * Import/export data list
     */
    private List<T> list;

    /**
     * Annotation list
     */
    private List<Object[]> fields;

    /**
     * Current row number
     */
    private int rownum;

    /**
     * Title
     */
    private String title;

    /**
     * Maximum height
     */
    private short maxHeight;

    /**
     * Last row number after merge
     */
    private int subMergedLastRowNum = 0;

    /**
     * First row number after merge
     */
    private int subMergedFirstRowNum = 1;

    /**
     * Object sub-list methods
     */
    private Map<String, Method> subMethods;

    /**
     * Object sub-list attributes
     */
    private Map<String, List<Field>> subFieldsMap;

    /**
     * Statistics list
     */
    private Map<Integer, Double> statistics = new HashMap<Integer, Double>();

    /**
     * Entity object
     */
    public Class<T> clazz;

    /**
     * Column attributes to display
     */
    public String[] includeFields;

    /**
     * Column attributes to exclude
     */
    public String[] excludeFields;

    public ExcelUtil(Class<T> clazz)
    {
        this.clazz = clazz;
    }

    /**
     * Only display column attributes in Excel
     *
     * @param fields Column attribute names Example [single "name"/multiple "id","name"]
     */
    public void showColumn(String... fields)
    {
        this.includeFields = fields;
    }

    /**
     * Hide column attributes in Excel
     *
     * @param fields Column attribute names Example [single "name"/multiple "id","name"]
     */
    public void hideColumn(String... fields)
    {
        this.excludeFields = fields;
    }

    public void init(List<T> list, String sheetName, String title, Type type)
    {
        if (list == null)
        {
            list = new ArrayList<T>();
        }
        this.list = list;
        this.sheetName = sheetName;
        this.type = type;
        this.title = title;
        createExcelField();
        createWorkbook();
        createTitle();
        createSubHead();
    }

    /**
     * Create Excel first row title
     */
    public void createTitle()
    {
        if (StringUtils.isNotEmpty(title))
        {
            int titleLastCol = this.fields.size() - 1;
            if (isSubList())
            {
                for (List<Field> currentSubFields : subFieldsMap.values())
                {
                    titleLastCol = titleLastCol + currentSubFields.size() - 1;
                }
            }
            Row titleRow = sheet.createRow(rownum == 0 ? rownum++ : 0);
            titleRow.setHeightInPoints(30);
            Cell titleCell = titleRow.createCell(0);
            titleCell.setCellStyle(styles.get("title"));
            titleCell.setCellValue(title);
            sheet.addMergedRegion(new CellRangeAddress(titleRow.getRowNum(), titleRow.getRowNum(), 0, titleLastCol));
        }
    }

    /**
     * Create object sub-list names
     */
    public void createSubHead()
    {
        if (isSubList())
        {
            Row subRow = sheet.createRow(rownum);
            int column = 0;
            for (Object[] objects : fields)
            {
                Field field = (Field) objects[0];
                Excel attr = (Excel) objects[1];
                CellStyle cellStyle = styles.get(StringUtils.format("header_{}_{}", attr.headerColor(), attr.headerBackgroundColor()));
                if (Collection.class.isAssignableFrom(field.getType()))
                {
                    Cell cell = subRow.createCell(column);
                    cell.setCellValue(attr.name());
                    cell.setCellStyle(cellStyle);
                    int subFieldSize = subFieldsMap != null ? subFieldsMap.get(field.getName()).size() : 0;
                    if (subFieldSize > 1)
                    {
                        CellRangeAddress cellAddress = new CellRangeAddress(rownum, rownum, column, column + subFieldSize - 1);
                        sheet.addMergedRegion(cellAddress);
                    }
                    column += subFieldSize;
                }
                else
                {
                    Cell cell = subRow.createCell(column++);
                    cell.setCellValue(attr.name());
                    cell.setCellStyle(cellStyle);
                }
            }
            rownum++;
        }
    }

    /**
     * Convert Excel sheet default first index name to list
     * 
     * @param is Input stream
     * @return Converted collection
     */
    public List<T> importExcel(InputStream is)
    {
        return importExcel(is, 0);
    }

    /**
     * Convert Excel sheet default first index name to list
     * 
     * @param is Input stream
     * @param titleNum Title row count
     * @return Converted collection
     */
    public List<T> importExcel(InputStream is, int titleNum)
    {
        List<T> list = null;
        try
        {
            list = importExcel(StringUtils.EMPTY, is, titleNum);
        }
        catch (Exception e)
        {
            log.error("Import Excel exception {}", e.getMessage());
            throw new UtilException(e.getMessage());
        }
        finally
        {
            IOUtils.closeQuietly(is);
        }
        return list;
    }

    /**
     * Convert Excel sheet specified sheet index name to list
     * 
     * @param sheetName Sheet index name
     * @param titleNum Title row count
     * @param is Input stream
     * @return Converted collection
     */
    public List<T> importExcel(String sheetName, InputStream is, int titleNum) throws Exception
    {
        this.type = Type.IMPORT;
        this.wb = WorkbookFactory.create(is);
        List<T> list = new ArrayList<T>();
        // If sheet name is specified, get content from specified sheet, otherwise default to first sheet
        Sheet sheet = StringUtils.isNotEmpty(sheetName) ? wb.getSheet(sheetName) : wb.getSheetAt(0);
        if (sheet == null)
        {
            throw new IOException("File sheet does not exist");
        }
        boolean isXSSFWorkbook = !(wb instanceof HSSFWorkbook);
        Map<String, List<PictureData>> pictures = null;
        if (isXSSFWorkbook)
        {
            pictures = getSheetPictures07((XSSFSheet) sheet, (XSSFWorkbook) wb);
        }
        else
        {
            pictures = getSheetPictures03((HSSFSheet) sheet, (HSSFWorkbook) wb);
        }
        // Get last non-empty row index, e.g., if total rows is n, return n-1
        int rows = sheet.getLastRowNum();
        if (rows > 0)
        {
            // Define a map to store Excel column index and field
            Map<String, Integer> cellMap = new HashMap<String, Integer>();
            // Get header
            Row heard = sheet.getRow(titleNum);
            if (heard == null)
            {
                throw new UtilException("File title row is empty, please check Excel file format");
            }
            for (int i = 0; i < heard.getLastCellNum(); i++)
            {
                Cell cell = heard.getCell(i);
                if (StringUtils.isNotNull(cell))
                {
                    String value = this.getCellValue(heard, i).toString();
                    cellMap.put(value, i);
                }
            }
            // Process only when there is data, get all fields of the class
            List<Object[]> fields = this.getFields();
            Map<Integer, Object[]> fieldsMap = new HashMap<Integer, Object[]>();
            for (Object[] objects : fields)
            {
                Excel attr = (Excel) objects[1];
                Integer column = cellMap.get(attr.name());
                if (column != null)
                {
                    fieldsMap.put(column, objects);
                }
            }
            for (int i = titleNum + 1; i <= rows; i++)
            {
                // Start getting data from row 2, default first row is header
                Row row = sheet.getRow(i);
                // Check if current row is empty
                if (isRowEmpty(row))
                {
                    continue;
                }
                T entity = null;
                for (Map.Entry<Integer, Object[]> entry : fieldsMap.entrySet())
                {
                    Object val = this.getCellValue(row, entry.getKey());

                    // If instance does not exist, create new
                    entity = (entity == null ? clazz.newInstance() : entity);
                    // Get corresponding column field from map
                    Field field = (Field) entry.getValue()[0];
                    Excel attr = (Excel) entry.getValue()[1];
                    // Get type and set value according to object type
                    Class<?> fieldType = field.getType();
                    if (String.class == fieldType)
                    {
                        String s = Convert.toStr(val);
                        if (s.matches("^\\d+\\.0$"))
                        {
                            val = StringUtils.substringBefore(s, ".0");
                        }
                        else
                        {
                            String dateFormat = field.getAnnotation(Excel.class).dateFormat();
                            if (StringUtils.isNotEmpty(dateFormat))
                            {
                                val = parseDateToStr(dateFormat, val);
                            }
                            else
                            {
                                val = Convert.toStr(val);
                            }
                        }
                    }
                    else if ((Integer.TYPE == fieldType || Integer.class == fieldType) && StringUtils.isNumeric(Convert.toStr(val)))
                    {
                        val = Convert.toInt(val);
                    }
                    else if ((Long.TYPE == fieldType || Long.class == fieldType) && StringUtils.isNumeric(Convert.toStr(val)))
                    {
                        val = Convert.toLong(val);
                    }
                    else if (Double.TYPE == fieldType || Double.class == fieldType)
                    {
                        val = Convert.toDouble(val);
                    }
                    else if (Float.TYPE == fieldType || Float.class == fieldType)
                    {
                        val = Convert.toFloat(val);
                    }
                    else if (BigDecimal.class == fieldType)
                    {
                        val = Convert.toBigDecimal(val);
                    }
                    else if (Date.class == fieldType)
                    {
                        if (val instanceof String)
                        {
                            val = DateUtils.parseDate(val);
                        }
                        else if (val instanceof Double)
                        {
                            val = DateUtil.getJavaDate((Double) val);
                        }
                    }
                    else if (Boolean.TYPE == fieldType || Boolean.class == fieldType)
                    {
                        val = Convert.toBool(val, false);
                    }
                    if (StringUtils.isNotNull(fieldType))
                    {
                        String propertyName = field.getName();
                        if (StringUtils.isNotEmpty(attr.targetAttr()))
                        {
                            propertyName = field.getName() + "." + attr.targetAttr();
                        }
                        if (StringUtils.isNotEmpty(attr.readConverterExp()))
                        {
                            val = reverseByExp(Convert.toStr(val), attr.readConverterExp(), attr.separator());
                        }
                        else if (StringUtils.isNotEmpty(attr.dictType()))
                        {
                            if (!sysDictMap.containsKey(attr.dictType() + val))
                            {
                                String dictValue = reverseDictByExp(Convert.toStr(val), attr.dictType(), attr.separator());
                                sysDictMap.put(attr.dictType() + val, dictValue);
                            }
                            val = sysDictMap.get(attr.dictType() + val);
                        }
                        else if (!attr.handler().equals(ExcelHandlerAdapter.class))
                        {
                            val = dataFormatHandlerAdapter(val, attr, null);
                        }
                        else if (ColumnType.IMAGE == attr.cellType() && StringUtils.isNotEmpty(pictures))
                        {
                            StringBuilder propertyString = new StringBuilder();
                            List<PictureData> images = pictures.get(row.getRowNum() + "_" + entry.getKey());
                            for (PictureData picture : images)
                            {
                                byte[] data = picture.getData();
                                String fileName = FileUtils.writeImportBytes(data);
                                propertyString.append(fileName).append(SEPARATOR);
                            }
                            val = StringUtils.stripEnd(propertyString.toString(), SEPARATOR);
                        }
                        ReflectUtils.invokeSetter(entity, propertyName, val);
                    }
                }
                list.add(entity);
            }
        }
        return list;
    }

    /**
     * Import data from list data source into Excel sheet
     * 
     * @param list Export data collection
     * @param sheetName Worksheet name
     * @return Result
     */
    public AjaxResult exportExcel(List<T> list, String sheetName)
    {
        return exportExcel(list, sheetName, StringUtils.EMPTY);
    }

    /**
     * Import data from list data source into Excel sheet
     * 
     * @param list Export data collection
     * @param sheetName Worksheet name
     * @param title Title
     * @return Result
     */
    public AjaxResult exportExcel(List<T> list, String sheetName, String title)
    {
        this.init(list, sheetName, title, Type.EXPORT);
        return exportExcel();
    }

    /**
     * Import data from list data source into Excel sheet
     * 
     * @param response Response data
     * @param list Export data collection
     * @param sheetName Worksheet name
     * @return Result
     */
    public void exportExcel(HttpServletResponse response, List<T> list, String sheetName)
    {
        exportExcel(response, list, sheetName, StringUtils.EMPTY);
    }

    /**
     * Import data from list data source into Excel sheet
     * 
     * @param response Response data
     * @param list Export data collection
     * @param sheetName Worksheet name
     * @param title Title
     * @return Result
     */
    public void exportExcel(HttpServletResponse response, List<T> list, String sheetName, String title)
    {
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setCharacterEncoding("utf-8");
        this.init(list, sheetName, title, Type.EXPORT);
        exportExcel(response);
    }

    /**
     * Import data from list data source into Excel sheet
     * 
     * @param sheetName Worksheet name
     * @return Result
     */
    public AjaxResult importTemplateExcel(String sheetName)
    {
        return importTemplateExcel(sheetName, StringUtils.EMPTY);
    }

    /**
     * Import data from list data source into Excel sheet
     * 
     * @param sheetName Worksheet name
     * @param title Title
     * @return Result
     */
    public AjaxResult importTemplateExcel(String sheetName, String title)
    {
        this.init(null, sheetName, title, Type.IMPORT);
        return exportExcel();
    }

    /**
     * Import data from list data source into Excel sheet
     * 
     * @param sheetName Worksheet name
     * @return Result
     */
    public void importTemplateExcel(HttpServletResponse response, String sheetName)
    {
        importTemplateExcel(response, sheetName, StringUtils.EMPTY);
    }

    /**
     * Import data from list data source into Excel sheet
     * 
     * @param sheetName Worksheet name
     * @param title Title
     * @return Result
     */
    public void importTemplateExcel(HttpServletResponse response, String sheetName, String title)
    {
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setCharacterEncoding("utf-8");
        this.init(null, sheetName, title, Type.IMPORT);
        exportExcel(response);
    }

    /**
     * Import data from list data source into Excel sheet
     * 
     * @return Result
     */
    public void exportExcel(HttpServletResponse response)
    {
        try
        {
            writeSheet();
            wb.write(response.getOutputStream());
        }
        catch (Exception e)
        {
            log.error("Export Excel exception {}", e.getMessage());
        }
        finally
        {
            IOUtils.closeQuietly(wb);
        }
    }

    /**
     * Import data from list data source into Excel sheet
     * 
     * @return Result
     */
    public AjaxResult exportExcel()
    {
        OutputStream out = null;
        try
        {
            writeSheet();
            String filename = encodingFilename(sheetName);
            out = new FileOutputStream(getAbsoluteFile(filename));
            wb.write(out);
            return AjaxResult.success(filename);
        }
        catch (Exception e)
        {
            log.error("Export Excel exception {}", e.getMessage());
            throw new UtilException("Export Excel failed, please contact website administrator!");
        }
        finally
        {
            IOUtils.closeQuietly(wb);
            IOUtils.closeQuietly(out);
        }
    }

    /**
     * Create and write data to Sheet
     */
    public void writeSheet()
    {
        // Get total number of sheets
        int sheetNo = Math.max(1, (int) Math.ceil(list.size() * 1.0 / sheetSize));
        for (int index = 0; index < sheetNo; index++)
        {
            createSheet(sheetNo, index);

            // Create a row
            Row row = sheet.createRow(rownum);
            int column = 0;
            // Write column header names for each field
            for (Object[] os : fields)
            {
                Field field = (Field) os[0];
                Excel excel = (Excel) os[1];
                if (Collection.class.isAssignableFrom(field.getType()))
                {
                    List<Field> currentSubFields = subFieldsMap.get(field.getName());
                    for (Field subField : currentSubFields)
                    {
                        Excel subExcel = subField.getAnnotation(Excel.class);
                        this.createHeadCell(subExcel, row, column++);
                    }
                }
                else
                {
                    this.createHeadCell(excel, row, column++);
                }
            }
            if (Type.EXPORT.equals(type))
            {
                fillExcelData(index);
                addStatisticsRow();
            }
        }
    }

    /**
     * Fill Excel data
     * 
     * @param index Sequence number
     */
    @SuppressWarnings("unchecked")
    public void fillExcelData(int index)
    {
        int startNo = index * sheetSize;
        int endNo = Math.min(startNo + sheetSize, list.size());
        int currentRowNum = rownum + 1; // Start after title row

        for (int i = startNo; i < endNo; i++)
        {
            Row row = sheet.createRow(currentRowNum);
            T vo = (T) list.get(i);
            int column = 0;
            int maxSubListSize = getCurrentMaxSubListSize(vo);
            for (Object[] os : fields)
            {
                Field field = (Field) os[0];
                Excel excel = (Excel) os[1];
                if (Collection.class.isAssignableFrom(field.getType()))
                {
                    try
                    {
                        Collection<?> subList = (Collection<?>) getTargetValue(vo, field, excel);
                        List<Field> currentSubFields = subFieldsMap.get(field.getName());
                        if (subList != null && !subList.isEmpty())
                        {
                            int subIndex = 0;
                            for (Object subVo : subList)
                            {
                                Row subRow = sheet.getRow(currentRowNum + subIndex);
                                if (subRow == null)
                                {
                                    subRow = sheet.createRow(currentRowNum + subIndex);
                                }

                                int subColumn = column;
                                for (Field subField : currentSubFields)
                                {
                                    Excel subExcel = subField.getAnnotation(Excel.class);
                                    addCell(subExcel, subRow, (T) subVo, subField, subColumn++);
                                }
                                subIndex++;
                            }
                        }
                        column += currentSubFields.size();
                    }
                    catch (Exception e)
                    {
                        log.error("Fill collection data failed", e);
                    }
                }
                else
                {
                    // Create cell and set value
                    addCell(excel, row, vo, field, column);
                    if (maxSubListSize > 1 && excel.needMerge())
                    {
                        sheet.addMergedRegion(new CellRangeAddress(currentRowNum, currentRowNum + maxSubListSize - 1, column, column));
                    }
                    column++;
                }
            }
            currentRowNum += maxSubListSize;
        }
    }

    /**
     * Get maximum sub-list size
     */
    private int getCurrentMaxSubListSize(T vo)
    {
        int maxSubListSize = 1;
        for (Object[] os : fields)
        {
            Field field = (Field) os[0];
            if (Collection.class.isAssignableFrom(field.getType()))
            {
                try
                {
                    Collection<?> subList = (Collection<?>) getTargetValue(vo, field, (Excel) os[1]);
                    if (subList != null && !subList.isEmpty())
                    {
                        maxSubListSize = Math.max(maxSubListSize, subList.size());
                    }
                }
                catch (Exception e)
                {
                    log.error("Get collection size failed", e);
                }
            }
        }
        return maxSubListSize;
    }

    /**
     * Create table styles
     * 
     * @param wb Workbook object
     * @return Style list
     */
    private Map<String, CellStyle> createStyles(Workbook wb)
    {
        // Write each record, each record corresponds to a row in the Excel table
        Map<String, CellStyle> styles = new HashMap<String, CellStyle>();
        CellStyle style = wb.createCellStyle();
        style.setAlignment(HorizontalAlignment.CENTER);
        style.setVerticalAlignment(VerticalAlignment.CENTER);
        Font titleFont = wb.createFont();
        titleFont.setFontName("Arial");
        titleFont.setFontHeightInPoints((short) 16);
        titleFont.setBold(true);
        style.setFont(titleFont);
        DataFormat dataFormat = wb.createDataFormat();
        style.setDataFormat(dataFormat.getFormat("@"));
        styles.put("title", style);

        style = wb.createCellStyle();
        style.setAlignment(HorizontalAlignment.CENTER);
        style.setVerticalAlignment(VerticalAlignment.CENTER);
        style.setBorderRight(BorderStyle.THIN);
        style.setRightBorderColor(IndexedColors.GREY_50_PERCENT.getIndex());
        style.setBorderLeft(BorderStyle.THIN);
        style.setLeftBorderColor(IndexedColors.GREY_50_PERCENT.getIndex());
        style.setBorderTop(BorderStyle.THIN);
        style.setTopBorderColor(IndexedColors.GREY_50_PERCENT.getIndex());
        style.setBorderBottom(BorderStyle.THIN);
        style.setBottomBorderColor(IndexedColors.GREY_50_PERCENT.getIndex());
        Font dataFont = wb.createFont();
        dataFont.setFontName("Arial");
        dataFont.setFontHeightInPoints((short) 10);
        style.setFont(dataFont);
        styles.put("data", style);

        style = wb.createCellStyle();
        style.setAlignment(HorizontalAlignment.CENTER);
        style.setVerticalAlignment(VerticalAlignment.CENTER);
        style.setDataFormat(dataFormat.getFormat("######0.00"));
        Font totalFont = wb.createFont();
        totalFont.setFontName("Arial");
        totalFont.setFontHeightInPoints((short) 10);
        style.setFont(totalFont);
        styles.put("total", style);

        styles.putAll(annotationHeaderStyles(wb, styles));

        styles.putAll(annotationDataStyles(wb));

        return styles;
    }

    /**
     * Create table header styles based on Excel annotations
     * 
     * @param wb Workbook object
     * @return Custom style list
     */
    private Map<String, CellStyle> annotationHeaderStyles(Workbook wb, Map<String, CellStyle> styles)
    {
        Map<String, CellStyle> headerStyles = new HashMap<String, CellStyle>();
        for (Object[] os : fields)
        {
            Excel excel = (Excel) os[1];
            String key = StringUtils.format("header_{}_{}", excel.headerColor(), excel.headerBackgroundColor());
            if (!headerStyles.containsKey(key))
            {
                CellStyle style = wb.createCellStyle();
                style.cloneStyleFrom(styles.get("data"));
                style.setAlignment(HorizontalAlignment.CENTER);
                style.setVerticalAlignment(VerticalAlignment.CENTER);
                style.setFillForegroundColor(excel.headerBackgroundColor().index);
                style.setFillPattern(FillPatternType.SOLID_FOREGROUND);
                Font headerFont = wb.createFont();
                headerFont.setFontName("Arial");
                headerFont.setFontHeightInPoints((short) 10);
                headerFont.setBold(true);
                headerFont.setColor(excel.headerColor().index);
                style.setFont(headerFont);
                // Set table header cell text format
                DataFormat dataFormat = wb.createDataFormat();
                style.setDataFormat(dataFormat.getFormat("@"));
                headerStyles.put(key, style);
            }
        }
        return headerStyles;
    }

    /**
     * Create table column styles based on Excel annotations
     * 
     * @param wb Workbook object
     * @return Custom style list
     */
    private Map<String, CellStyle> annotationDataStyles(Workbook wb)
    {
        Map<String, CellStyle> styles = new HashMap<String, CellStyle>();
        for (Object[] os : fields)
        {
            Field field = (Field) os[0];
            Excel excel = (Excel) os[1];
            if (Collection.class.isAssignableFrom(field.getType()))
            {
                ParameterizedType pt = (ParameterizedType) field.getGenericType();
                Class<?> subClass = (Class<?>) pt.getActualTypeArguments()[0];
                List<Field> subFields = FieldUtils.getFieldsListWithAnnotation(subClass, Excel.class);
                for (Field subField : subFields)
                {
                    Excel subExcel = subField.getAnnotation(Excel.class);
                    annotationDataStyles(styles, subField, subExcel);
                }
            }
            else
            {
                annotationDataStyles(styles, field, excel);
            }
        }
        return styles;
    }

    /**
     * Create table column styles based on Excel annotations
     * 
     * @param styles Custom style list
     * @param field  Attribute column information
     * @param excel  Annotation information
     */
    public void annotationDataStyles(Map<String, CellStyle> styles, Field field, Excel excel)
    {
        String key = StringUtils.format("data_{}_{}_{}_{}_{}", excel.align(), excel.color(), excel.backgroundColor(), excel.cellType(), excel.wrapText());
        if (!styles.containsKey(key))
        {
            CellStyle style = wb.createCellStyle();
            style.setAlignment(excel.align());
            style.setVerticalAlignment(VerticalAlignment.CENTER);
            style.setBorderRight(BorderStyle.THIN);
            style.setRightBorderColor(IndexedColors.GREY_50_PERCENT.getIndex());
            style.setBorderLeft(BorderStyle.THIN);
            style.setLeftBorderColor(IndexedColors.GREY_50_PERCENT.getIndex());
            style.setBorderTop(BorderStyle.THIN);
            style.setTopBorderColor(IndexedColors.GREY_50_PERCENT.getIndex());
            style.setBorderBottom(BorderStyle.THIN);
            style.setBottomBorderColor(IndexedColors.GREY_50_PERCENT.getIndex());
            style.setFillPattern(FillPatternType.SOLID_FOREGROUND);
            style.setFillForegroundColor(excel.backgroundColor().getIndex());
            style.setWrapText(excel.wrapText());
            Font dataFont = wb.createFont();
            dataFont.setFontName("Arial");
            dataFont.setFontHeightInPoints((short) 10);
            dataFont.setColor(excel.color().index);
            style.setFont(dataFont);
            if (ColumnType.TEXT == excel.cellType())
            {
                DataFormat dataFormat = wb.createDataFormat();
                style.setDataFormat(dataFormat.getFormat("@"));
            }
            styles.put(key, style);
        }
    }

    /**
     * Create cell
     */
    public Cell createHeadCell(Excel attr, Row row, int column)
    {
        // Create column
        Cell cell = row.createCell(column);
        // Write column information
        cell.setCellValue(attr.name());
        setDataValidation(attr, row, column);
        cell.setCellStyle(styles.get(StringUtils.format("header_{}_{}", attr.headerColor(), attr.headerBackgroundColor())));
        if (isSubList())
        {
            // Fill default style to prevent merged cell style from becoming invalid
            sheet.setDefaultColumnStyle(column, styles.get(StringUtils.format("data_{}_{}_{}_{}_{}", attr.align(), attr.color(), attr.backgroundColor(), attr.cellType(), attr.wrapText())));
            if (attr.needMerge())
            {
                sheet.addMergedRegion(new CellRangeAddress(rownum - 1, rownum, column, column));
            }
        }
        return cell;
    }

    /**
     * Set cell information
     * 
     * @param value Cell value
     * @param attr  Annotation related
     * @param cell  Cell information
     */
    public void setCellVo(Object value, Excel attr, Cell cell)
    {
        if (ColumnType.STRING == attr.cellType() || ColumnType.TEXT == attr.cellType())
        {
            String cellValue = Convert.toStr(value);
            // For any cell starting with expression trigger characters =-+@, directly use tab character as prefix to prevent CSV injection
            if (StringUtils.startsWithAny(cellValue, FORMULA_STR))
            {
                cellValue = RegExUtils.replaceFirst(cellValue, FORMULA_REGEX_STR, "\t$0");
            }
            if (value instanceof Collection && StringUtils.equals("[]", cellValue))
            {
                cellValue = StringUtils.EMPTY;
            }
            cell.setCellValue(StringUtils.isNull(cellValue) ? attr.defaultValue() : cellValue + attr.suffix());
        }
        else if (ColumnType.NUMERIC == attr.cellType())
        {
            if (StringUtils.isNotNull(value))
            {
                cell.setCellValue(StringUtils.contains(Convert.toStr(value), ".") ? Convert.toDouble(value) : Convert.toInt(value));
            }
        }
        else if (ColumnType.IMAGE == attr.cellType())
        {
            ClientAnchor anchor = new XSSFClientAnchor(0, 0, 0, 0, (short) cell.getColumnIndex(), cell.getRow().getRowNum(), (short) (cell.getColumnIndex() + 1), cell.getRow().getRowNum() + 1);
            String propertyValue = Convert.toStr(value);
            if (StringUtils.isNotEmpty(propertyValue))
            {
                List<String> imagePaths = StringUtils.str2List(propertyValue, SEPARATOR);
                for (String imagePath : imagePaths)
                {
                    byte[] data = ImageUtils.getImage(imagePath);
                    getDrawingPatriarch(cell.getSheet()).createPicture(anchor, cell.getSheet().getWorkbook().addPicture(data, getImageType(data)));
                }
            }
        }
    }

    /**
     * Get drawing canvas
     */
    public static Drawing<?> getDrawingPatriarch(Sheet sheet)
    {
        if (sheet.getDrawingPatriarch() == null)
        {
            sheet.createDrawingPatriarch();
        }
        return sheet.getDrawingPatriarch();
    }

    /**
     * Get image type, set image insertion type
     */
    public int getImageType(byte[] value)
    {
        String type = FileTypeUtils.getFileExtendName(value);
        if ("JPG".equalsIgnoreCase(type))
        {
            return Workbook.PICTURE_TYPE_JPEG;
        }
        else if ("PNG".equalsIgnoreCase(type))
        {
            return Workbook.PICTURE_TYPE_PNG;
        }
        return Workbook.PICTURE_TYPE_JPEG;
    }

    /**
     * Create table style
     */
    public void setDataValidation(Excel attr, Row row, int column)
    {
        if (attr.name().indexOf("Note:") >= 0)
        {
            sheet.setColumnWidth(column, 6000);
        }
        else
        {
            // Set column width
            sheet.setColumnWidth(column, (int) ((attr.width() + 0.72) * 256));
        }
        if (StringUtils.isNotEmpty(attr.prompt()) || attr.combo().length > 0 || attr.comboReadDict())
        {
            String[] comboArray = attr.combo();
            if (attr.comboReadDict())
            {
                if (!sysDictMap.containsKey("combo_" + attr.dictType()))
                {
                    String labels = DictUtils.getDictLabels(attr.dictType());
                    sysDictMap.put("combo_" + attr.dictType(), labels);
                }
                String val = sysDictMap.get("combo_" + attr.dictType());
                comboArray = StringUtils.split(val, DictUtils.SEPARATOR);
            }
            if (comboArray.length > 15 || StringUtils.join(comboArray).length() > 255)
            {
                // If dropdown count is greater than 15 or string length is greater than 255, use a new sheet to store, to avoid generated template dropdown values not being retrievable
                setXSSFValidationWithHidden(sheet, comboArray, attr.prompt(), 1, 100, column, column);
            }
            else
            {
                // Prompt information or column content that can only be selected but not entered
                setPromptOrValidation(sheet, comboArray, attr.prompt(), 1, 100, column, column);
            }
        }
    }

    /**
     * Add cell
     */
    public Cell addCell(Excel attr, Row row, T vo, Field field, int column)
    {
        Cell cell = null;
        try
        {
            // Set row height
            row.setHeight(maxHeight);
            // Determine whether to export based on Excel settings, some cases need to remain empty, hoping users fill in this column
            if (attr.isExport())
            {
                // Create cell
                cell = row.createCell(column);
                if (isSubListValue(vo) && getListCellValue(vo) > 1 && attr.needMerge())
                {
                    if (subMergedLastRowNum >= subMergedFirstRowNum)
                    {
                        sheet.addMergedRegion(new CellRangeAddress(subMergedFirstRowNum, subMergedLastRowNum, column, column));
                    }
                }
                cell.setCellStyle(styles.get(StringUtils.format("data_{}_{}_{}_{}_{}", attr.align(), attr.color(), attr.backgroundColor(), attr.cellType(), attr.wrapText())));

                // Used to read attributes in object
                Object value = getTargetValue(vo, field, attr);
                String dateFormat = attr.dateFormat();
                String readConverterExp = attr.readConverterExp();
                String separator = attr.separator();
                String dictType = attr.dictType();
                if (StringUtils.isNotEmpty(dateFormat) && StringUtils.isNotNull(value))
                {
                    cell.setCellStyle(createCellStyle(cell.getCellStyle(), dateFormat));
                    cell.setCellValue(parseDateToStr(dateFormat, value));
                }
                else if (StringUtils.isNotEmpty(readConverterExp) && StringUtils.isNotNull(value))
                {
                    cell.setCellValue(convertByExp(Convert.toStr(value), readConverterExp, separator));
                }
                else if (StringUtils.isNotEmpty(dictType) && StringUtils.isNotNull(value))
                {
                    if (!sysDictMap.containsKey(dictType + value))
                    {
                        String lable = convertDictByExp(Convert.toStr(value), dictType, separator);
                        sysDictMap.put(dictType + value, lable);
                    }
                    cell.setCellValue(sysDictMap.get(dictType + value));
                }
                else if (value instanceof BigDecimal && -1 != attr.scale())
                {
                    cell.setCellValue((((BigDecimal) value).setScale(attr.scale(), attr.roundingMode())).doubleValue());
                }
                else if (!attr.handler().equals(ExcelHandlerAdapter.class))
                {
                    cell.setCellValue(dataFormatHandlerAdapter(value, attr, cell));
                }
                else
                {
                    // Set column type
                    setCellVo(value, attr, cell);
                }
                addStatisticsData(column, Convert.toStr(value), attr);
            }
        }
        catch (Exception e)
        {
            log.error("Export Excel failed {}", e);
        }
        return cell;
    }

    /**
     * Use custom format while avoiding style pollution
     * 
     * @param cellStyle Copy from this style
     * @param format Format matching string
     * @return Formatted CellStyle object
     */
    private CellStyle createCellStyle(CellStyle cellStyle, String format)
    {
        CellStyle style = wb.createCellStyle();
        style.cloneStyleFrom(cellStyle);
        style.setDataFormat(wb.getCreationHelper().createDataFormat().getFormat(format));
        return style;
    }

    /**
     * Set POI XSSFSheet cell prompt or selection box
     * 
     * @param sheet Sheet
     * @param textlist Dropdown box display content
     * @param promptContent Prompt content
     * @param firstRow Start row
     * @param endRow End row
     * @param firstCol Start column
     * @param endCol End column
     */
    public void setPromptOrValidation(Sheet sheet, String[] textlist, String promptContent, int firstRow, int endRow,
            int firstCol, int endCol)
    {
        DataValidationHelper helper = sheet.getDataValidationHelper();
        DataValidationConstraint constraint = textlist.length > 0 ? helper.createExplicitListConstraint(textlist) : helper.createCustomConstraint("DD1");
        CellRangeAddressList regions = new CellRangeAddressList(firstRow, endRow, firstCol, endCol);
        DataValidation dataValidation = helper.createValidation(constraint, regions);
        if (StringUtils.isNotEmpty(promptContent))
        {
            // If prompt information is set, show prompt when mouse hovers
            dataValidation.createPromptBox("", promptContent);
            dataValidation.setShowPromptBox(true);
        }
        // Handle Excel compatibility issues
        if (dataValidation instanceof XSSFDataValidation)
        {
            dataValidation.setSuppressDropDownArrow(true);
            dataValidation.setShowErrorBox(true);
        }
        else
        {
            dataValidation.setSuppressDropDownArrow(false);
        }
        sheet.addValidationData(dataValidation);
    }

    /**
     * Set certain column values to only input preset data, display dropdown box (compatible with dropdown boxes exceeding a certain number)
     * 
     * @param sheet Sheet to set
     * @param textlist Dropdown box display content
     * @param promptContent Prompt content
     * @param firstRow Start row
     * @param endRow End row
     * @param firstCol Start column
     * @param endCol End column
     */
    public void setXSSFValidationWithHidden(Sheet sheet, String[] textlist, String promptContent, int firstRow, int endRow, int firstCol, int endCol)
    {
        String hideSheetName = "combo_" + firstCol + "_" + endCol;
        Sheet hideSheet = null;
        String hideSheetDataName = hideSheetName + "_data";
        Name name = wb.getName(hideSheetDataName);
        if (name != null)
        {
            // Name already exists, try to find sheet name from name reference
            String refersToFormula = name.getRefersToFormula();
            if (StringUtils.isNotEmpty(refersToFormula) && refersToFormula.contains("!"))
            {
                String sheetNameFromFormula = refersToFormula.substring(0, refersToFormula.indexOf("!"));
                hideSheet = wb.getSheet(sheetNameFromFormula);
            }
        }

        if (hideSheet == null)
        {
            hideSheet = wb.createSheet(hideSheetName); // Used to store dropdown menu data
            for (int i = 0; i < textlist.length; i++)
            {
                hideSheet.createRow(i).createCell(0).setCellValue(textlist[i]);
            }
            // Create name that can be referenced by other cells
            name = wb.createName();
            name.setNameName(hideSheetDataName);
            name.setRefersToFormula(hideSheetName + "!$A$1:$A$" + textlist.length);
        }

        DataValidationHelper helper = sheet.getDataValidationHelper();
        // Load dropdown list content
        DataValidationConstraint constraint = helper.createFormulaListConstraint(hideSheetDataName);
        // Set data validation on which cells, four parameters are: start row, end row, start column, end column
        CellRangeAddressList regions = new CellRangeAddressList(firstRow, endRow, firstCol, endCol);
        // Data validation object
        DataValidation dataValidation = helper.createValidation(constraint, regions);
        if (StringUtils.isNotEmpty(promptContent))
        {
            // If prompt information is set, show prompt when mouse hovers
            dataValidation.createPromptBox("", promptContent);
            dataValidation.setShowPromptBox(true);
        }
        // Handle Excel compatibility issues
        if (dataValidation instanceof XSSFDataValidation)
        {
            dataValidation.setSuppressDropDownArrow(true);
            dataValidation.setShowErrorBox(true);
        }
        else
        {
            dataValidation.setSuppressDropDownArrow(false);
        }

        sheet.addValidationData(dataValidation);
        // Set hiddenSheet to hidden
        wb.setSheetHidden(wb.getSheetIndex(hideSheet), true);
    }

    /**
     * Parse export value 0=Male,1=Female,2=Unknown
     * 
     * @param propertyValue Parameter value
     * @param converterExp Translation annotation
     * @param separator Separator
     * @return Parsed value
     */
    public static String convertByExp(String propertyValue, String converterExp, String separator)
    {
        StringBuilder propertyString = new StringBuilder();
        String[] convertSource = converterExp.split(SEPARATOR);
        for (String item : convertSource)
        {
            String[] itemArray = item.split("=");
            if (StringUtils.containsAny(propertyValue, separator))
            {
                for (String value : propertyValue.split(separator))
                {
                    if (itemArray[0].equals(value))
                    {
                        propertyString.append(itemArray[1] + separator);
                        break;
                    }
                }
            }
            else
            {
                if (itemArray[0].equals(propertyValue))
                {
                    return itemArray[1];
                }
            }
        }
        return StringUtils.stripEnd(propertyString.toString(), separator);
    }

    /**
     * Reverse parse value Male=0,Female=1,Unknown=2
     * 
     * @param propertyValue Parameter value
     * @param converterExp Translation annotation
     * @param separator Separator
     * @return Parsed value
     */
    public static String reverseByExp(String propertyValue, String converterExp, String separator)
    {
        StringBuilder propertyString = new StringBuilder();
        String[] convertSource = converterExp.split(SEPARATOR);
        for (String item : convertSource)
        {
            String[] itemArray = item.split("=");
            if (StringUtils.containsAny(propertyValue, separator))
            {
                for (String value : propertyValue.split(separator))
                {
                    if (itemArray[1].equals(value))
                    {
                        propertyString.append(itemArray[0] + separator);
                        break;
                    }
                }
            }
            else
            {
                if (itemArray[1].equals(propertyValue))
                {
                    return itemArray[0];
                }
            }
        }
        return StringUtils.stripEnd(propertyString.toString(), separator);
    }

    /**
     * Parse dictionary value
     * 
     * @param dictValue Dictionary value
     * @param dictType Dictionary type
     * @param separator Separator
     * @return Dictionary label
     */
    public static String convertDictByExp(String dictValue, String dictType, String separator)
    {
        return DictUtils.getDictLabel(dictType, dictValue, separator);
    }

    /**
     * Reverse parse dictionary value
     * 
     * @param dictLabel Dictionary label
     * @param dictType Dictionary type
     * @param separator Separator
     * @return Dictionary value
     */
    public static String reverseDictByExp(String dictLabel, String dictType, String separator)
    {
        return DictUtils.getDictValue(dictType, dictLabel, separator);
    }

    /**
     * Data processor
     * 
     * @param value Data value
     * @param excel Data annotation
     * @return
     */
    public String dataFormatHandlerAdapter(Object value, Excel excel, Cell cell)
    {
        try
        {
            Object instance = excel.handler().newInstance();
            Method formatMethod = excel.handler().getMethod("format", new Class[] { Object.class, String[].class, Cell.class, Workbook.class });
            value = formatMethod.invoke(instance, value, excel.args(), cell, this.wb);
        }
        catch (Exception e)
        {
            log.error("Cannot format data " + excel.handler(), e.getMessage());
        }
        return Convert.toStr(value);
    }

    /**
     * Total statistics information
     */
    private void addStatisticsData(Integer index, String text, Excel entity)
    {
        if (entity != null && entity.isStatistics())
        {
            Double temp = 0D;
            if (!statistics.containsKey(index))
            {
                statistics.put(index, temp);
            }
            try
            {
                temp = Double.valueOf(text);
            }
            catch (NumberFormatException e)
            {
            }
            statistics.put(index, statistics.get(index) + temp);
        }
    }

    /**
     * Create statistics row
     */
    public void addStatisticsRow()
    {
        if (statistics.size() > 0)
        {
            Row row = sheet.createRow(sheet.getLastRowNum() + 1);
            Set<Integer> keys = statistics.keySet();
            Cell cell = row.createCell(0);
            cell.setCellStyle(styles.get("total"));
            cell.setCellValue("Total");

            for (Integer key : keys)
            {
                cell = row.createCell(key);
                cell.setCellStyle(styles.get("total"));
                cell.setCellValue(statistics.get(key));
            }
            statistics.clear();
        }
    }

    /**
     * Encode filename
     */
    public String encodingFilename(String filename)
    {
        return UUID.randomUUID() + "_" + filename + ".xlsx";
    }

    /**
     * Get download path
     * 
     * @param filename File name
     */
    public String getAbsoluteFile(String filename)
    {
        String downloadPath = RuoYiConfig.getDownloadPath() + filename;
        File desc = new File(downloadPath);
        if (!desc.getParentFile().exists())
        {
            desc.getParentFile().mkdirs();
        }
        return downloadPath;
    }

    /**
     * Get attribute value in bean
     * 
     * @param vo Entity object
     * @param field Field
     * @param excel Annotation
     * @return Final attribute value
     * @throws Exception
     */
    private Object getTargetValue(T vo, Field field, Excel excel) throws Exception
    {
        field.setAccessible(true);
        Object o = field.get(vo);
        if (StringUtils.isNotEmpty(excel.targetAttr()))
        {
            String target = excel.targetAttr();
            if (target.contains("."))
            {
                String[] targets = target.split("[.]");
                for (String name : targets)
                {
                    o = getValue(o, name);
                }
            }
            else
            {
                o = getValue(o, target);
            }
        }
        return o;
    }

    /**
     * Get value in the form of class attribute get method
     * 
     * @param o
     * @param name
     * @return value
     * @throws Exception
     */
    private Object getValue(Object o, String name) throws Exception
    {
        if (StringUtils.isNotNull(o) && StringUtils.isNotEmpty(name))
        {
            Class<?> clazz = o.getClass();
            Field field = clazz.getDeclaredField(name);
            field.setAccessible(true);
            o = field.get(o);
        }
        return o;
    }

    /**
     * Get all defined fields
     */
    private void createExcelField()
    {
        this.fields = getFields();
        this.fields = this.fields.stream().sorted(Comparator.comparing(objects -> ((Excel) objects[1]).sort())).collect(Collectors.toList());
        this.maxHeight = getRowHeight();
    }

    /**
     * Get field annotation information
     */
    public List<Object[]> getFields()
    {
        List<Object[]> fields = new ArrayList<Object[]>();
        List<Field> tempFields = new ArrayList<>();
        subFieldsMap = new HashMap<>();
        subMethods = new HashMap<>();
        tempFields.addAll(Arrays.asList(clazz.getSuperclass().getDeclaredFields()));
        tempFields.addAll(Arrays.asList(clazz.getDeclaredFields()));
        if (StringUtils.isNotEmpty(includeFields))
        {
            for (Field field : tempFields)
            {
                if (ArrayUtils.contains(this.includeFields, field.getName()) || field.isAnnotationPresent(Excels.class))
                {
                    addField(fields, field);
                }
            }
        }
        else if (StringUtils.isNotEmpty(excludeFields))
        {
            for (Field field : tempFields)
            {
                if (!ArrayUtils.contains(this.excludeFields, field.getName()))
                {
                    addField(fields, field);
                }
            }
        }
        else
        {
            for (Field field : tempFields)
            {
                addField(fields, field);
            }
        }
        return fields;
    }

    /**
     * Add field information
     */
    public void addField(List<Object[]> fields, Field field)
    {
        // Single annotation
        if (field.isAnnotationPresent(Excel.class))
        {
            Excel attr = field.getAnnotation(Excel.class);
            if (attr != null && (attr.type() == Type.ALL || attr.type() == type))
            {
                fields.add(new Object[] { field, attr });
            }
            if (Collection.class.isAssignableFrom(field.getType()))
            {
                String fieldName = field.getName();
                subMethods.put(fieldName, getSubMethod(fieldName, clazz));
                ParameterizedType pt = (ParameterizedType) field.getGenericType();
                Class<?> subClass = (Class<?>) pt.getActualTypeArguments()[0];
                subFieldsMap.put(fieldName, FieldUtils.getFieldsListWithAnnotation(subClass, Excel.class));
            }
        }

        // Multiple annotations
        if (field.isAnnotationPresent(Excels.class))
        {
            Excels attrs = field.getAnnotation(Excels.class);
            Excel[] excels = attrs.value();
            for (Excel attr : excels)
            {
                if (StringUtils.isNotEmpty(includeFields))
                {
                    if (ArrayUtils.contains(this.includeFields, field.getName() + "." + attr.targetAttr())
                            && (attr != null && (attr.type() == Type.ALL || attr.type() == type)))
                    {
                        fields.add(new Object[] { field, attr });
                    }
                }
                else
                {
                    if (!ArrayUtils.contains(this.excludeFields, field.getName() + "." + attr.targetAttr())
                            && (attr != null && (attr.type() == Type.ALL || attr.type() == type)))
                    {
                        fields.add(new Object[] { field, attr });
                    }
                }
            }
        }
    }

    /**
     * Get maximum row height based on annotation
     */
    public short getRowHeight()
    {
        double maxHeight = 0;
        for (Object[] os : this.fields)
        {
            Excel excel = (Excel) os[1];
            maxHeight = Math.max(maxHeight, excel.height());
        }
        return (short) (maxHeight * 20);
    }

    /**
     * Create a workbook
     */
    public void createWorkbook()
    {
        this.wb = new SXSSFWorkbook(500);
        this.sheet = wb.createSheet();
        wb.setSheetName(0, sheetName);
        this.styles = createStyles(wb);
    }

    /**
     * Create worksheet
     * 
     * @param sheetNo Sheet count
     * @param index Sequence number
     */
    public void createSheet(int sheetNo, int index)
    {
        // Set worksheet name
        if (sheetNo > 1 && index > 0)
        {
            this.sheet = wb.createSheet();
            this.createTitle();
            int actualIndex = wb.getSheetIndex(this.sheet);
            wb.setSheetName(actualIndex, sheetName + index);
        }
    }

    /**
     * Get cell value
     * 
     * @param row Row to get
     * @param column Cell column number to get
     * @return Cell value
     */
    public Object getCellValue(Row row, int column)
    {
        if (row == null)
        {
            return row;
        }
        Object val = "";
        try
        {
            Cell cell = row.getCell(column);
            if (StringUtils.isNotNull(cell))
            {
                if (cell.getCellType() == CellType.NUMERIC || cell.getCellType() == CellType.FORMULA)
                {
                    val = cell.getNumericCellValue();
                    if (DateUtil.isCellDateFormatted(cell))
                    {
                        val = DateUtil.getJavaDate((Double) val); // POI Excel date format conversion
                    }
                    else
                    {
                        if ((Double) val % 1 != 0)
                        {
                            val = new BigDecimal(val.toString());
                        }
                        else
                        {
                            val = new DecimalFormat("0").format(val);
                        }
                    }
                }
                else if (cell.getCellType() == CellType.STRING)
                {
                    val = cell.getStringCellValue();
                }
                else if (cell.getCellType() == CellType.BOOLEAN)
                {
                    val = cell.getBooleanCellValue();
                }
                else if (cell.getCellType() == CellType.ERROR)
                {
                    val = cell.getErrorCellValue();
                }

            }
        }
        catch (Exception e)
        {
            return val;
        }
        return val;
    }

    /**
     * Check if row is empty
     * 
     * @param row Row to check
     * @return
     */
    private boolean isRowEmpty(Row row)
    {
        if (row == null)
        {
            return true;
        }
        for (int i = row.getFirstCellNum(); i < row.getLastCellNum(); i++)
        {
            Cell cell = row.getCell(i);
            if (cell != null && cell.getCellType() != CellType.BLANK)
            {
                return false;
            }
        }
        return true;
    }

    /**
     * Get Excel 2003 pictures
     *
     * @param sheet Current sheet object
     * @param workbook Workbook object
     * @return Map key: picture cell index (1_1) String, value: picture stream PictureData
     */
    public static Map<String, List<PictureData>> getSheetPictures03(HSSFSheet sheet, HSSFWorkbook workbook)
    {
        Map<String, List<PictureData>> sheetIndexPicMap = new HashMap<>();
        List<HSSFPictureData> pictures = workbook.getAllPictures();
        if (!pictures.isEmpty() && sheet.getDrawingPatriarch() != null)
        {
            for (HSSFShape shape : sheet.getDrawingPatriarch().getChildren())
            {
                if (shape instanceof HSSFPicture)
                {
                    HSSFPicture pic = (HSSFPicture) shape;
                    HSSFClientAnchor anchor = (HSSFClientAnchor) pic.getAnchor();
                    String picIndex = anchor.getRow1() + "_" + anchor.getCol1();
                    sheetIndexPicMap.computeIfAbsent(picIndex, k -> new ArrayList<>()).add(pic.getPictureData());
                }
            }
        }
        return sheetIndexPicMap;
    }

    /**
     * Get Excel 2007 pictures
     *
     * @param sheet Current sheet object
     * @param workbook Workbook object
     * @return Map key: picture cell index (1_1) String, value: picture stream PictureData
     */
    public static Map<String, List<PictureData>> getSheetPictures07(XSSFSheet sheet, XSSFWorkbook workbook)
    {
        Map<String, List<PictureData>> sheetIndexPicMap = new HashMap<>();
        for (POIXMLDocumentPart dr : sheet.getRelations())
        {
            if (dr instanceof XSSFDrawing)
            {
                XSSFDrawing drawing = (XSSFDrawing) dr;
                for (XSSFShape shape : drawing.getShapes())
                {
                    if (shape instanceof XSSFPicture)
                    {
                        XSSFPicture pic = (XSSFPicture) shape;
                        XSSFClientAnchor anchor = pic.getPreferredSize();
                        CTMarker ctMarker = anchor.getFrom();
                        String picIndex = ctMarker.getRow() + "_" + ctMarker.getCol();
                        sheetIndexPicMap.computeIfAbsent(picIndex, k -> new ArrayList<>()).add(pic.getPictureData());
                    }
                }
            }
        }
        return sheetIndexPicMap;
    }

    /**
     * Format different types of date objects
     * 
     * @param dateFormat Date format
     * @param val Date object to be formatted
     * @return Formatted date string
     */
    public String parseDateToStr(String dateFormat, Object val)
    {
        if (val == null)
        {
            return "";
        }
        String str;
        if (val instanceof Date)
        {
            str = DateUtils.parseDateToStr(dateFormat, (Date) val);
        }
        else if (val instanceof LocalDateTime)
        {
            str = DateUtils.parseDateToStr(dateFormat, DateUtils.toDate((LocalDateTime) val));
        }
        else if (val instanceof LocalDate)
        {
            str = DateUtils.parseDateToStr(dateFormat, DateUtils.toDate((LocalDate) val));
        }
        else
        {
            str = val.toString();
        }
        return str;
    }

    /**
     * Whether object has sub-list
     */
    public boolean isSubList()
    {
        return !StringUtils.isEmpty(subFieldsMap);
    }

    /**
     * Whether object has sub-list and collection is not empty
     */
    public boolean isSubListValue(T vo)
    {
        return !StringUtils.isEmpty(subFieldsMap) && getListCellValue(vo) > 0;
    }

    /**
     * Get collection value
     */
    public int getListCellValue(Object obj)
    {
        Collection<?> value;
        int max = 0;
        try
        {
            for (String s : subMethods.keySet())
            {
                value = (Collection<?>) subMethods.get(s).invoke(obj);
                if (value.size() > max)
                {
                    max = value.size();
                }
            }
        }
        catch (Exception e)
        {
            return 0;
        }
        return max;
    }

    /**
     * Get object sub-list method
     * 
     * @param name Name
     * @param pojoClass Class object
     * @return Sub-list method
     */
    public Method getSubMethod(String name, Class<?> pojoClass)
    {
        StringBuffer getMethodName = new StringBuffer("get");
        getMethodName.append(name.substring(0, 1).toUpperCase());
        getMethodName.append(name.substring(1));
        Method method = null;
        try
        {
            method = pojoClass.getMethod(getMethodName.toString(), new Class[] {});
        }
        catch (Exception e)
        {
            log.error("Get object exception {}", e.getMessage());
        }
        return method;
    }
}
