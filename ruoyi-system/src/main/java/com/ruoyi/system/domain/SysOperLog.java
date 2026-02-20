package com.ruoyi.system.domain;

import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.annotation.Excel.ColumnType;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * Operation Log Record Table oper_log
 * 
 * @author ruoyi
 */
public class SysOperLog extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** Log Primary Key */
    @Excel(name = "Operation ID", cellType = ColumnType.NUMERIC)
    private Long operId;

    /** Operation Module */
    @Excel(name = "Operation Module")
    private String title;

    /** Business Type (0 Other 1 Add 2 Modify 3 Delete) */
    @Excel(name = "Business Type", readConverterExp = "0=Other,1=Add,2=Modify,3=Delete,4=Authorize,5=Export,6=Import,7=Force Logout,8=Generate Code,9=Clear Data")
    private Integer businessType;

    /** Business Type Array */
    private Integer[] businessTypes;

    /** Request Method */
    @Excel(name = "Request Method")
    private String method;

    /** Request Type */
    @Excel(name = "Request Type")
    private String requestMethod;

    /** Operator Type (0 Other 1 Backend User 2 Mobile User) */
    @Excel(name = "Operator Type", readConverterExp = "0=Other,1=Backend User,2=Mobile User")
    private Integer operatorType;

    /** Operator */
    @Excel(name = "Operator")
    private String operName;

    /** Department Name */
    @Excel(name = "Department Name")
    private String deptName;

    /** Request URL */
    @Excel(name = "Request URL")
    private String operUrl;

    /** Operation IP */
    @Excel(name = "Operation IP")
    private String operIp;

    /** Operation Location */
    @Excel(name = "Operation Location")
    private String operLocation;

    /** Request Parameters */
    @Excel(name = "Request Parameters")
    private String operParam;

    /** Return Parameters */
    @Excel(name = "Return Parameters")
    private String jsonResult;

    /** Operation Status (0 Normal 1 Exception) */
    @Excel(name = "Status", readConverterExp = "0=Normal,1=Exception")
    private Integer status;

    /** Error Message */
    @Excel(name = "Error Message")
    private String errorMsg;

    /** Operation Time */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @Excel(name = "Operation Time", width = 30, dateFormat = "yyyy-MM-dd HH:mm:ss")
    private Date operTime;

    /** Cost Time */
    @Excel(name = "Cost Time", suffix = "ms")
    private Long costTime;

    public Long getOperId()
    {
        return operId;
    }

    public void setOperId(Long operId)
    {
        this.operId = operId;
    }

    public String getTitle()
    {
        return title;
    }

    public void setTitle(String title)
    {
        this.title = title;
    }

    public Integer getBusinessType()
    {
        return businessType;
    }

    public void setBusinessType(Integer businessType)
    {
        this.businessType = businessType;
    }

    public Integer[] getBusinessTypes()
    {
        return businessTypes;
    }

    public void setBusinessTypes(Integer[] businessTypes)
    {
        this.businessTypes = businessTypes;
    }

    public String getMethod()
    {
        return method;
    }

    public void setMethod(String method)
    {
        this.method = method;
    }

    public String getRequestMethod()
    {
        return requestMethod;
    }

    public void setRequestMethod(String requestMethod)
    {
        this.requestMethod = requestMethod;
    }

    public Integer getOperatorType()
    {
        return operatorType;
    }

    public void setOperatorType(Integer operatorType)
    {
        this.operatorType = operatorType;
    }

    public String getOperName()
    {
        return operName;
    }

    public void setOperName(String operName)
    {
        this.operName = operName;
    }

    public String getDeptName()
    {
        return deptName;
    }

    public void setDeptName(String deptName)
    {
        this.deptName = deptName;
    }

    public String getOperUrl()
    {
        return operUrl;
    }

    public void setOperUrl(String operUrl)
    {
        this.operUrl = operUrl;
    }

    public String getOperIp()
    {
        return operIp;
    }

    public void setOperIp(String operIp)
    {
        this.operIp = operIp;
    }

    public String getOperLocation()
    {
        return operLocation;
    }

    public void setOperLocation(String operLocation)
    {
        this.operLocation = operLocation;
    }

    public String getOperParam()
    {
        return operParam;
    }

    public void setOperParam(String operParam)
    {
        this.operParam = operParam;
    }

    public String getJsonResult()
    {
        return jsonResult;
    }

    public void setJsonResult(String jsonResult)
    {
        this.jsonResult = jsonResult;
    }

    public Integer getStatus()
    {
        return status;
    }

    public void setStatus(Integer status)
    {
        this.status = status;
    }

    public String getErrorMsg()
    {
        return errorMsg;
    }

    public void setErrorMsg(String errorMsg)
    {
        this.errorMsg = errorMsg;
    }

    public Date getOperTime()
    {
        return operTime;
    }

    public void setOperTime(Date operTime)
    {
        this.operTime = operTime;
    }

    public Long getCostTime()
    {
        return costTime;
    }

    public void setCostTime(Long costTime)
    {
        this.costTime = costTime;
    }
}
