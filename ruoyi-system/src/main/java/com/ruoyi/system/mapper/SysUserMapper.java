package com.ruoyi.system.mapper;

import java.util.Date;
import java.util.List;
import org.apache.ibatis.annotations.Param;
import com.ruoyi.common.core.domain.entity.SysUser;

/**
 * User Table Data Layer
 * 
 * @author ruoyi
 */
public interface SysUserMapper
{
    /**
     * Query User List by Conditions with Pagination
     * 
     * @param sysUser User Information
     * @return User Information Collection
     */
    public List<SysUser> selectUserList(SysUser sysUser);

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

    /**
     * Query User by phone
     *
     * @param phone phone
     * @return User Object Information
     */
    public SysUser selectUserByPhone(String phone);

    /**
     * Query User by User ID
     * 
     * @param userId User ID
     * @return User Object Information
     */
    public SysUser selectUserById(Long userId);

    /**
     * Add User Information
     * 
     * @param user User Information
     * @return Result
     */
    public int insertUser(SysUser user);

    /**
     * Modify User Information
     * 
     * @param user User Information
     * @return Result
     */
    public int updateUser(SysUser user);

    /**
     * Modify User Avatar
     * 
     * @param userId User ID
     * @param avatar Avatar Address
     * @return Result
     */
    public int updateUserAvatar(@Param("userId") Long userId, @Param("avatar") String avatar);

    /**
     * Modify User Status
     * 
     * @param userId User ID
     * @param status Status
     * @return Result
     */
    public int updateUserStatus(@Param("userId") Long userId, @Param("status") String status);

    /**
     * Update User Login Information (IP and Login Time)
     * 
     * @param userId User ID
     * @param loginIp Login IP Address
     * @param loginDate Login Time
     * @return Result
     */
    public int updateLoginInfo(@Param("userId") Long userId, @Param("loginIp") String loginIp, @Param("loginDate") Date loginDate);

    /**
     * Reset User Password
     * 
     * @param userId User ID
     * @param password Password
     * @return Result
     */
    public int resetUserPwd(@Param("userId") Long userId, @Param("password") String password);

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
     * Validate if Username is Unique
     * 
     * @param userName Username
     * @return Result
     */
    public SysUser checkUserNameUnique(String userName);

    /**
     * Validate if Phone Number is Unique
     *
     * @param phonenumber Phone Number
     * @return Result
     */
    public SysUser checkPhoneUnique(String phonenumber);

    /**
     * Validate if Email is Unique
     *
     * @param email User Email
     * @return Result
     */
    public SysUser checkEmailUnique(String email);
}
