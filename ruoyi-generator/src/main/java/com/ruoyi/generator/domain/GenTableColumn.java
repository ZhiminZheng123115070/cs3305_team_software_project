package com.ruoyi.generator.domain;

import javax.validation.constraints.NotBlank;
import com.ruoyi.common.core.domain.BaseEntity;
import com.ruoyi.common.utils.StringUtils;

/**
 * Code Generation Business Field Table gen_table_column
 * 
 * @author ruoyi
 */
public class GenTableColumn extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** ID */
    private Long columnId;

    /** Belongs to table ID */
    private Long tableId;

    /** Column name */
    private String columnName;

    /** Column description */
    private String columnComment;

    /** Column type */
    private String columnType;

    /** JAVA type */
    private String javaType;

    /** JAVA field name */
    @NotBlank(message = "Java attribute cannot be empty")
    private String javaField;

    /** Whether primary key (1 yes) */
    private String isPk;

    /** Whether auto increment (1 yes) */
    private String isIncrement;

    /** Whether required (1 yes) */
    private String isRequired;

    /** Whether insert field (1 yes) */
    private String isInsert;

    /** Whether edit field (1 yes) */
    private String isEdit;

    /** Whether list field (1 yes) */
    private String isList;

    /** Whether query field (1 yes) */
    private String isQuery;

    /** Query method (EQ equals, NE not equals, GT greater than, LT less than, LIKE fuzzy, BETWEEN range) */
    private String queryType;

    /** Display type (input text box, textarea text area, select dropdown, checkbox checkbox, radio radio button, datetime date control, image image upload control, upload file upload control, editor rich text control) */
    private String htmlType;

    /** Dictionary type */
    private String dictType;

    /** Sort */
    private Integer sort;

    public void setColumnId(Long columnId)
    {
        this.columnId = columnId;
    }

    public Long getColumnId()
    {
        return columnId;
    }

    public void setTableId(Long tableId)
    {
        this.tableId = tableId;
    }

    public Long getTableId()
    {
        return tableId;
    }

    public void setColumnName(String columnName)
    {
        this.columnName = columnName;
    }

    public String getColumnName()
    {
        return columnName;
    }

    public void setColumnComment(String columnComment)
    {
        this.columnComment = columnComment;
    }

    public String getColumnComment()
    {
        return columnComment;
    }

    public void setColumnType(String columnType)
    {
        this.columnType = columnType;
    }

    public String getColumnType()
    {
        return columnType;
    }

    public void setJavaType(String javaType)
    {
        this.javaType = javaType;
    }

    public String getJavaType()
    {
        return javaType;
    }

    public void setJavaField(String javaField)
    {
        this.javaField = javaField;
    }

    public String getJavaField()
    {
        return javaField;
    }

    public String getCapJavaField()
    {
        return StringUtils.capitalize(javaField);
    }

    public void setIsPk(String isPk)
    {
        this.isPk = isPk;
    }

    public String getIsPk()
    {
        return isPk;
    }

    public boolean isPk()
    {
        return isPk(this.isPk);
    }

    public boolean isPk(String isPk)
    {
        return isPk != null && StringUtils.equals("1", isPk);
    }

    public String getIsIncrement()
    {
        return isIncrement;
    }

    public void setIsIncrement(String isIncrement)
    {
        this.isIncrement = isIncrement;
    }

    public boolean isIncrement()
    {
        return isIncrement(this.isIncrement);
    }

    public boolean isIncrement(String isIncrement)
    {
        return isIncrement != null && StringUtils.equals("1", isIncrement);
    }

    public void setIsRequired(String isRequired)
    {
        this.isRequired = isRequired;
    }

    public String getIsRequired()
    {
        return isRequired;
    }

    public boolean isRequired()
    {
        return isRequired(this.isRequired);
    }

    public boolean isRequired(String isRequired)
    {
        return isRequired != null && StringUtils.equals("1", isRequired);
    }

    public void setIsInsert(String isInsert)
    {
        this.isInsert = isInsert;
    }

    public String getIsInsert()
    {
        return isInsert;
    }

    public boolean isInsert()
    {
        return isInsert(this.isInsert);
    }

    public boolean isInsert(String isInsert)
    {
        return isInsert != null && StringUtils.equals("1", isInsert);
    }

    public void setIsEdit(String isEdit)
    {
        this.isEdit = isEdit;
    }

    public String getIsEdit()
    {
        return isEdit;
    }

    public boolean isEdit()
    {
        return isInsert(this.isEdit);
    }

    public boolean isEdit(String isEdit)
    {
        return isEdit != null && StringUtils.equals("1", isEdit);
    }

    public void setIsList(String isList)
    {
        this.isList = isList;
    }

    public String getIsList()
    {
        return isList;
    }

    public boolean isList()
    {
        return isList(this.isList);
    }

    public boolean isList(String isList)
    {
        return isList != null && StringUtils.equals("1", isList);
    }

    public void setIsQuery(String isQuery)
    {
        this.isQuery = isQuery;
    }

    public String getIsQuery()
    {
        return isQuery;
    }

    public boolean isQuery()
    {
        return isQuery(this.isQuery);
    }

    public boolean isQuery(String isQuery)
    {
        return isQuery != null && StringUtils.equals("1", isQuery);
    }

    public void setQueryType(String queryType)
    {
        this.queryType = queryType;
    }

    public String getQueryType()
    {
        return queryType;
    }

    public String getHtmlType()
    {
        return htmlType;
    }

    public void setHtmlType(String htmlType)
    {
        this.htmlType = htmlType;
    }

    public void setDictType(String dictType)
    {
        this.dictType = dictType;
    }

    public String getDictType()
    {
        return dictType;
    }

    public void setSort(Integer sort)
    {
        this.sort = sort;
    }

    public Integer getSort()
    {
        return sort;
    }

    public boolean isSuperColumn()
    {
        return isSuperColumn(this.javaField);
    }

    public static boolean isSuperColumn(String javaField)
    {
        return StringUtils.equalsAnyIgnoreCase(javaField,
                // BaseEntity
                "createBy", "createTime", "updateBy", "updateTime", "remark",
                // TreeEntity
                "parentName", "parentId", "orderNum", "ancestors");
    }

    public boolean isUsableColumn()
    {
        return isUsableColumn(javaField);
    }

    public static boolean isUsableColumn(String javaField)
    {
        // The list in isSuperColumn() is used to avoid generating redundant Domain attributes. If certain attributes need to be used when generating pages and cannot be ignored, put them in this whitelist
        return StringUtils.equalsAnyIgnoreCase(javaField, "parentId", "orderNum", "remark");
    }

    public String readConverterExp()
    {
        String remarks = StringUtils.substringBetween(this.columnComment, "（", "）");
        StringBuffer sb = new StringBuffer();
        if (StringUtils.isNotEmpty(remarks))
        {
            for (String value : remarks.split(" "))
            {
                if (StringUtils.isNotEmpty(value))
                {
                    Object startStr = value.subSequence(0, 1);
                    String endStr = value.substring(1);
                    sb.append("").append(startStr).append("=").append(endStr).append(",");
                }
            }
            return sb.deleteCharAt(sb.length() - 1).toString();
        }
        else
        {
            return this.columnComment;
        }
    }
}
