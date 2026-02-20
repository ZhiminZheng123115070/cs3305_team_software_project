package com.ruoyi.common.annotation;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;
import java.math.BigDecimal;
import org.apache.poi.ss.usermodel.HorizontalAlignment;
import org.apache.poi.ss.usermodel.IndexedColors;
import com.ruoyi.common.utils.poi.ExcelHandlerAdapter;

/**
 * Custom Excel export data annotation
 * 
 * @author ruoyi
 */
@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.FIELD)
public @interface Excel
{
    /**
     * Sort order when exporting to Excel
     */
    public int sort() default Integer.MAX_VALUE;

    /**
     * Name exported to Excel
     */
    public String name() default "";

    /**
     * Date format, e.g.: yyyy-MM-dd
     */
    public String dateFormat() default "";

    /**
     * If dictionary type, set dictionary type value (e.g.: sys_user_sex)
     */
    public String dictType() default "";

    /**
     * Read content conversion expression (e.g.: 0=male,1=female,2=unknown)
     */
    public String readConverterExp() default "";

    /**
     * Separator for reading string group content
     */
    public String separator() default ",";

    /**
     * BigDecimal precision, default: -1 (BigDecimal formatting not enabled by default)
     */
    public int scale() default -1;

    /**
     * BigDecimal rounding mode, default: BigDecimal.ROUND_HALF_EVEN
     */
    public int roundingMode() default BigDecimal.ROUND_HALF_EVEN;

    /**
     * Column height in Excel when exporting
     */
    public double height() default 14;

    /**
     * Column width in Excel when exporting
     */
    public double width() default 16;

    /**
     * Text suffix, e.g. % makes 90 become 90%
     */
    public String suffix() default "";

    /**
     * Default value for field when value is empty
     */
    public String defaultValue() default "";

    /**
     * Prompt information
     */
    public String prompt() default "";

    /**
     * Whether to allow content wrapping
     */
    public boolean wrapText() default false;

    /**
     * Set column content that can only be selected, not input
     */
    public String[] combo() default {};

    /**
     * Whether to read data from dictionary to combo, default not read, if read need to set dictType annotation
     */
    public boolean comboReadDict() default false;

    /**
     * Whether vertical cell merging is needed, for requirements: cells containing list collections
     */
    public boolean needMerge() default false;

    /**
     * Whether to export data, for requirements: sometimes we need to export a template, title is needed but content needs to be filled manually by user
     */
    public boolean isExport() default true;

    /**
     * Property name in another class, supports multi-level access, separated by dots
     */
    public String targetAttr() default "";

    /**
     * Whether to automatically calculate statistics, append a row of statistical totals at the end
     */
    public boolean isStatistics() default false;

    /**
     * Export type (0: number, 1: string, 2: image)
     */
    public ColumnType cellType() default ColumnType.STRING;

    /**
     * Export column header background color
     */
    public IndexedColors headerBackgroundColor() default IndexedColors.GREY_50_PERCENT;

    /**
     * Export column header font color
     */
    public IndexedColors headerColor() default IndexedColors.WHITE;

    /**
     * Export cell background color
     */
    public IndexedColors backgroundColor() default IndexedColors.WHITE;

    /**
     * Export cell font color
     */
    public IndexedColors color() default IndexedColors.BLACK;

    /**
     * Export field alignment
     */
    public HorizontalAlignment align() default HorizontalAlignment.CENTER;

    /**
     * Custom data handler
     */
    public Class<?> handler() default ExcelHandlerAdapter.class;

    /**
     * Custom data handler parameters
     */
    public String[] args() default {};

    /**
     * Field type (0: export/import, 1: export only, 2: import only)
     */
    Type type() default Type.ALL;

    public enum Type
    {
        ALL(0), EXPORT(1), IMPORT(2);
        private final int value;

        Type(int value)
        {
            this.value = value;
        }

        public int value()
        {
            return this.value;
        }
    }

    public enum ColumnType
    {
        NUMERIC(0), STRING(1), IMAGE(2), TEXT(3);
        private final int value;

        ColumnType(int value)
        {
            this.value = value;
        }

        public int value()
        {
            return this.value;
        }
    }
}