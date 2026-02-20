package com.ruoyi.common.core.domain.entity;

import java.util.Date;
import java.util.List;
import javax.validation.constraints.*;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.annotation.Excel.ColumnType;
import com.ruoyi.common.annotation.Excel.Type;
import com.ruoyi.common.annotation.Excels;
import com.ruoyi.common.core.domain.BaseEntity;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.common.xss.Xss;

/**
 * User object sys_user
 * 
 * @author ruoyi
 */
public class SysUser extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** User ID */
    @Excel(name = "User serial number", type = Type.EXPORT, cellType = ColumnType.NUMERIC, prompt = "User number")
    private Long userId;

    /** Department ID */
    @Excel(name = "Department number", type = Type.IMPORT)
    private Long deptId;

    /** User account */
    @Excel(name = "Login name")
    private String userName;

    /** User nickname */
    @Excel(name = "User name")
    private String nickName;

    /** User email */
    @Excel(name = "User email")
    private String email;

    /** Phone number */
    @Excel(name = "Phone number", cellType = ColumnType.TEXT)
    private String phonenumber;

    /** User gender */
    @Excel(name = "User gender", readConverterExp = "0=male,1=female,2=unknown")
    private String sex;

    /** User avatar */
    private String avatar;

    /** Password */
    private String password;

    /** Account status (0: normal, 1: disabled) */
    @Excel(name = "Account Status", readConverterExp = "0=normal,1=disabled")
    private String status;

    /** Delete flag (0: exists, 2: deleted) */
    private String delFlag;

    /** Last login IP */
    @Excel(name = "Last login IP", type = Type.EXPORT)
    private String loginIp;

    /** Last login time */
    @Excel(name = "Last login time", width = 30, dateFormat = "yyyy-MM-dd HH:mm:ss", type = Type.EXPORT)
    private Date loginDate;

    /** Password last update time */
    private Date pwdUpdateDate;

    /** Department object */
    @Excels({
        @Excel(name = "Department name", targetAttr = "deptName", type = Type.EXPORT),
        @Excel(name = "Department Leader", targetAttr = "leader", type = Type.EXPORT)
    })
    private SysDept dept;

    /** Role object */
    private List<SysRole> roles;

    /** Role group */
    private Long[] roleIds;

    /** Post group */
    private Long[] postIds;

    /** Role ID */
    private Long roleId;

    public SysUser()
    {

    }

    public SysUser(Long userId)
    {
        this.userId = userId;
    }

    public Long getUserId()
    {
        return userId;
    }

    public void setUserId(Long userId)
    {
        this.userId = userId;
    }

    public boolean isAdmin()
    {
        return SecurityUtils.isAdmin(this.userId);
    }

    public Long getDeptId()
    {
        return deptId;
    }

    public void setDeptId(Long deptId)
    {
        this.deptId = deptId;
    }

    @Xss(message = "User nicknamecannot contain script characters")
    @Size(min = 0, max = 30, message = "User nicknamelength cannot exceed30characters")
    public String getNickName()
    {
        return nickName;
    }

    public void setNickName(String nickName)
    {
        this.nickName = nickName;
    }

    @Xss(message = "User accountcannot contain script characters")
    @NotBlank(message = "User accountcannot be empty")
    @Size(min = 0, max = 30, message = "User accountlength cannot exceed30characters")
    public String getUserName()
    {
        return userName;
    }

    public void setUserName(String userName)
    {
        this.userName = userName;
    }

    @Email(message = "Emailformat is incorrect")
    @Size(min = 0, max = 50, message = "Emaillength cannot exceed50characters")
    public String getEmail()
    {
        return email;
    }

    public void setEmail(String email)
    {
        this.email = email;
    }

    @Size(min = 0, max = 11, message = "Phone numberlength cannot exceed11characters")
    public String getPhonenumber()
    {
        return phonenumber;
    }

    public void setPhonenumber(String phonenumber)
    {
        this.phonenumber = phonenumber;
    }

    public String getSex()
    {
        return sex;
    }

    public void setSex(String sex)
    {
        this.sex = sex;
    }

    public String getAvatar()
    {
        return avatar;
    }

    public void setAvatar(String avatar)
    {
        this.avatar = avatar;
    }

    @JsonProperty(access = JsonProperty.Access.WRITE_ONLY)
    public String getPassword()
    {
        return password;
    }

    public void setPassword(String password)
    {
        this.password = password;
    }

    public String getStatus()
    {
        return status;
    }

    public void setStatus(String status)
    {
        this.status = status;
    }

    public String getDelFlag()
    {
        return delFlag;
    }

    public void setDelFlag(String delFlag)
    {
        this.delFlag = delFlag;
    }

    public String getLoginIp()
    {
        return loginIp;
    }

    public void setLoginIp(String loginIp)
    {
        this.loginIp = loginIp;
    }

    public Date getLoginDate()
    {
        return loginDate;
    }

    public void setLoginDate(Date loginDate)
    {
        this.loginDate = loginDate;
    }

    public Date getPwdUpdateDate()
    {
        return pwdUpdateDate;
    }

    public void setPwdUpdateDate(Date pwdUpdateDate)
    {
        this.pwdUpdateDate = pwdUpdateDate;
    }

    public SysDept getDept()
    {
        return dept;
    }

    public void setDept(SysDept dept)
    {
        this.dept = dept;
    }

    public List<SysRole> getRoles()
    {
        return roles;
    }

    public void setRoles(List<SysRole> roles)
    {
        this.roles = roles;
    }

    public Long[] getRoleIds()
    {
        return roleIds;
    }

    public void setRoleIds(Long[] roleIds)
    {
        this.roleIds = roleIds;
    }

    public Long[] getPostIds()
    {
        return postIds;
    }

    public void setPostIds(Long[] postIds)
    {
        this.postIds = postIds;
    }

    public Long getRoleId()
    {
        return roleId;
    }

    public void setRoleId(Long roleId)
    {
        this.roleId = roleId;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this,ToStringStyle.MULTI_LINE_STYLE)
            .append("userId", getUserId())
            .append("deptId", getDeptId())
            .append("userName", getUserName())
            .append("nickName", getNickName())
            .append("email", getEmail())
            .append("phonenumber", getPhonenumber())
            .append("sex", getSex())
            .append("avatar", getAvatar())
            .append("password", getPassword())
            .append("status", getStatus())
            .append("delFlag", getDelFlag())
            .append("loginIp", getLoginIp())
            .append("loginDate", getLoginDate())
            .append("pwdUpdateDate", getPwdUpdateDate())
            .append("createBy", getCreateBy())
            .append("createTime", getCreateTime())
            .append("updateBy", getUpdateBy())
            .append("updateTime", getUpdateTime())
            .append("remark", getRemark())
            .append("dept", getDept())
            .toString();
    }
}
