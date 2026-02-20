package com.ruoyi.system.service;

import java.util.Date;
import java.util.List;
import com.ruoyi.common.core.domain.entity.SysUser;

/**
 * User Business Layer
 * 
 * @author ruoyi
 */
public interface ISysUserService
{
    /**
     * Query User List by Conditions with Pagination
     * 
     * @param user User Information
     * @return User Information Collection
     */
    public List<SysUser> selectUserList(SysUser user);

    /**
     * Query Allocated User Role List by Conditions with Pagination
     * 
     * @param user User Information
     * @return User Information Collection
     */
    public List<SysUser> selectAllocatedList(SysUser user);

    /**
     * Query Unallocated User Role List by Conditions with Pagination
     * 
     * @param user User Information
     * @return User Information Collection
     */
    public List<SysUser> selectUnallocatedList(SysUser user);

    /**
     * Query User by Username
     * 
     * @param userName Username
     * @return User Object Information
     */
    public SysUser selectUserByUserName(String userName);

    /*
    * Query User by Phone
    *
    * @param phone
    * @return User Object Information
    * */

    public SysUser selectUserByPhone(String phone);

    /**
     * Query User by User ID
     * 
     * @param userId User ID
     * @return User Object Information
     */
    public SysUser selectUserById(Long userId);

    /**
     * Query User Role Group by User ID
     * 
     * @param userName Username
     * @return Result
     */
    public String selectUserRoleGroup(String userName);

    /**
     * Query User Post Group by User ID
     * 
     * @param userName Username
     * @return Result
     */
    public String selectUserPostGroup(String userName);

    /**
     * Validate if Username is Unique
     * 
     * @param user User Information
     * @return Result
     */
    public boolean checkUserNameUnique(SysUser user);

    /**
     * Validate if Phone Number is Unique
     *
     * @param user User Information
     * @return Result
     */
    public boolean checkPhoneUnique(SysUser user);

    /**
     * Validate if Email is Unique
     *
     * @param user User Information
     * @return Result
     */
    public boolean checkEmailUnique(SysUser user);

    /**
     * Validate if User Operation is Allowed
     * 
     * @param user User Information
     */
    public void checkUserAllowed(SysUser user);

    /**
     * Validate if User has Data Permission
     * 
     * @param userId User ID
     */
    public void checkUserDataScope(Long userId);

    /**
     * Add User Information
     * 
     * @param user User Information
     * @return Result
     */
    public int insertUser(SysUser user);

    /**
     * Register User Information
     * 
     * @param user User Information
     * @return Result
     */
    public boolean registerUser(SysUser user);

    /**
     * Modify User Information
     * 
     * @param user User Information
     * @return Result
     */
    public int updateUser(SysUser user);

    /**
     * Authorize Roles to User
     * 
     * @param userId User ID
     * @param roleIds Role Group
     */
    public void insertUserAuth(Long userId, Long[] roleIds);

    /**
     * Modify User Status
     * 
     * @param user User Information
     * @return Result
     */
    public int updateUserStatus(SysUser user);

    /**
     * Modify User Basic Information
     * 
     * @param user User Information
     * @return Result
     */
    public int updateUserProfile(SysUser user);

    /**
     * Modify User Avatar
     * 
     * @param userId User ID
     * @param avatar Avatar Address
     * @return Result
     */
    public boolean updateUserAvatar(Long userId, String avatar);

    /**
     * Update User Login Information (IP and Login Time)
     * 
     * @param userId User ID
     * @param loginIp Login IP Address
     * @param loginDate Login Time
     * @return Result
     */
    public void updateLoginInfo(Long userId, String loginIp, Date loginDate);

    /**
     * Reset User Password
     * 
     * @param user User Information
     * @return Result
     */
    public int resetPwd(SysUser user);

    /**
     * Reset User Password
     * 
     * @param userId User ID
     * @param password Password
     * @return Result
     */
    public int resetUserPwd(Long userId, String password);

    /**
     * Delete User by User ID
     * 
     * @param userId User ID
     * @return Result
     */
    public int deleteUserById(Long userId);

    /**
     * Batch Delete User Information
     * 
     * @param userIds User IDs to Delete
     * @return Result
     */
    public int deleteUserByIds(Long[] userIds);

    /**
     * Import User Data
     * 
     * @param userList User Data List
     * @param isUpdateSupport Whether Update is Supported, if Exists, Update Data
     * @param operName Operator User
     * @return Result
     */
    public String importUser(List<SysUser> userList, Boolean isUpdateSupport, String operName);
}
