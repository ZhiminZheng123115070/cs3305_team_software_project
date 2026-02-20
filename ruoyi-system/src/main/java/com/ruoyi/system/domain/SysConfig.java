package com.ruoyi.system.domain;

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.Size;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.annotation.Excel.ColumnType;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * Parameter Configuration Table sys_config
 * 
 * @author ruoyi
 */
public class SysConfig extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** Parameter Primary Key */
    @Excel(name = "Parameter ID", cellType = ColumnType.NUMERIC)
    private Long configId;

    /** Parameter Name */
    @Excel(name = "Parameter Name")
    private String configName;

    /** Parameter Key */
    @Excel(name = "Parameter Key")
    private String configKey;

    /** Parameter Value */
    @Excel(name = "Parameter Value")
    private String configValue;

    /** System Built-in (Y Yes N No) */
    @Excel(name = "System Built-in", readConverterExp = "Y=Yes,N=No")
    private String configType;

    public Long getConfigId()
    {
        return configId;
    }

    public void setConfigId(Long configId)
    {
        this.configId = configId;
    }

    @NotBlank(message = "Parameter name cannot be empty")
    @Size(min = 0, max = 100, message = "Parameter name cannot exceed 100 characters")
    public String getConfigName()
    {
        return configName;
    }

    public void setConfigName(String configName)
    {
        this.configName = configName;
    }

    @NotBlank(message = "Parameter key cannot be empty")
    @Size(min = 0, max = 100, message = "Parameter key length cannot exceed 100 characters")
    public String getConfigKey()
    {
        return configKey;
    }

    public void setConfigKey(String configKey)
    {
        this.configKey = configKey;
    }

    @NotBlank(message = "Parameter value cannot be empty")
    @Size(min = 0, max = 500, message = "Parameter value length cannot exceed 500 characters")
    public String getConfigValue()
    {
        return configValue;
    }

    public void setConfigValue(String configValue)
    {
        this.configValue = configValue;
    }

    public String getConfigType()
    {
        return configType;
    }

    public void setConfigType(String configType)
    {
        this.configType = configType;
    }
    
    @Override
    public String toString() {
        return new ToStringBuilder(this,ToStringStyle.MULTI_LINE_STYLE)
            .append("configId", getConfigId())
            .append("configName", getConfigName())
            .append("configKey", getConfigKey())
            .append("configValue", getConfigValue())
            .append("configType", getConfigType())
            .append("createBy", getCreateBy())
            .append("createTime", getCreateTime())
            .append("updateBy", getUpdateBy())
            .append("updateTime", getUpdateTime())
            .append("remark", getRemark())
            .toString();
    }
}
