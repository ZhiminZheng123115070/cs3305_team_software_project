package com.ruoyi.common.constant;

/**
 * Code generation common constants
 * 
 * @author ruoyi
 */
public class GenConstants
{
    /** Single table (CRUD) */
    public static final String TPL_CRUD = "crud";

    /** Tree table (CRUD) */
    public static final String TPL_TREE = "tree";

    /** Master-detail table (CRUD) */
    public static final String TPL_SUB = "sub";

    /** Tree code field */
    public static final String TREE_CODE = "treeCode";

    /** Tree parent code field */
    public static final String TREE_PARENT_CODE = "treeParentCode";

    /** Tree name field */
    public static final String TREE_NAME = "treeName";

    /** Parent menu ID field */
    public static final String PARENT_MENU_ID = "parentMenuId";

    /** Parent menu name field */
    public static final String PARENT_MENU_NAME = "parentMenuName";

    /** Database string type */
    public static final String[] COLUMNTYPE_STR = { "char", "varchar", "nvarchar", "varchar2" };

    /** Database text type */
    public static final String[] COLUMNTYPE_TEXT = { "tinytext", "text", "mediumtext", "longtext" };

    /** Database time type */
    public static final String[] COLUMNTYPE_TIME = { "datetime", "time", "date", "timestamp" };

    /** Database number type */
    public static final String[] COLUMNTYPE_NUMBER = { "tinyint", "smallint", "mediumint", "int", "number", "integer",
            "bit", "bigint", "float", "double", "decimal" };

    /** Fields that do not need to be edited on the page */
    public static final String[] COLUMNNAME_NOT_EDIT = { "id", "create_by", "create_time", "del_flag" };

    /** Fields that do not need to be displayed in the list on the page */
    public static final String[] COLUMNNAME_NOT_LIST = { "id", "create_by", "create_time", "del_flag", "update_by",
            "update_time" };

    /** Fields that do not need to be queried on the page */
    public static final String[] COLUMNNAME_NOT_QUERY = { "id", "create_by", "create_time", "del_flag", "update_by",
            "update_time", "remark" };

    /** Entity base class fields */
    public static final String[] BASE_ENTITY = { "createBy", "createTime", "updateBy", "updateTime", "remark" };

    /** Tree base class fields */
    public static final String[] TREE_ENTITY = { "parentName", "parentId", "orderNum", "ancestors", "children" };

    /** Text input */
    public static final String HTML_INPUT = "input";

    /** Textarea */
    public static final String HTML_TEXTAREA = "textarea";

    /** Dropdown */
    public static final String HTML_SELECT = "select";

    /** Radio button */
    public static final String HTML_RADIO = "radio";

    /** Checkbox */
    public static final String HTML_CHECKBOX = "checkbox";

    /** Date control */
    public static final String HTML_DATETIME = "datetime";

    /** Image upload control */
    public static final String HTML_IMAGE_UPLOAD = "imageUpload";

    /** File upload control */
    public static final String HTML_FILE_UPLOAD = "fileUpload";

    /** Rich text control */
    public static final String HTML_EDITOR = "editor";

    /** String type */
    public static final String TYPE_STRING = "String";

    /** Integer type */
    public static final String TYPE_INTEGER = "Integer";

    /** Long type */
    public static final String TYPE_LONG = "Long";

    /** Double type */
    public static final String TYPE_DOUBLE = "Double";

    /** BigDecimal type */
    public static final String TYPE_BIGDECIMAL = "BigDecimal";

    /** Date type */
    public static final String TYPE_DATE = "Date";

    /** Fuzzy query */
    public static final String QUERY_LIKE = "LIKE";

    /** Equal query */
    public static final String QUERY_EQ = "EQ";

    /** Required */
    public static final String REQUIRE = "1";
}
