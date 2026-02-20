package com.ruoyi.system.service.impl;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;
import javax.validation.Validator;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.CollectionUtils;
import com.ruoyi.common.annotation.DataScope;
import com.ruoyi.common.constant.UserConstants;
import com.ruoyi.common.core.domain.entity.SysRole;
import com.ruoyi.common.core.domain.entity.SysUser;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.common.utils.bean.BeanValidators;
import com.ruoyi.common.utils.spring.SpringUtils;
import com.ruoyi.system.domain.SysPost;
import com.ruoyi.system.domain.SysUserPost;
import com.ruoyi.system.domain.SysUserRole;
import com.ruoyi.system.mapper.SysPostMapper;
import com.ruoyi.system.mapper.SysRoleMapper;
import com.ruoyi.system.mapper.SysUserMapper;
import com.ruoyi.system.mapper.SysUserPostMapper;
import com.ruoyi.system.mapper.SysUserRoleMapper;
import com.ruoyi.system.service.ISysConfigService;
import com.ruoyi.system.service.ISysDeptService;
import com.ruoyi.system.service.ISysUserService;

/**
 * User Business Layer Processing
 * 
 * @author ruoyi
 */
@Service
public class SysUserServiceImpl implements ISysUserService
{
    private static final Logger log = LoggerFactory.getLogger(SysUserServiceImpl.class);

    @Autowired
    private SysUserMapper userMapper;

    @Autowired
    private SysRoleMapper roleMapper;

    @Autowired
    private SysPostMapper postMapper;

    @Autowired
    private SysUserRoleMapper userRoleMapper;

    @Autowired
    private SysUserPostMapper userPostMapper;

    @Autowired
    private ISysConfigService configService;

    @Autowired
    private ISysDeptService deptService;

    @Autowired
    protected Validator validator;

    /**
     * Query User List by Conditions with Pagination
     * 
     * @param user User Information
     * @return User Information Collection
     */
    @Override
    @DataScope(deptAlias = "d", userAlias = "u")
    public List<SysUser> selectUserList(SysUser user)
    {
        return userMapper.selectUserList(user);
    }

    /**
     * Query Allocated User Role List by Conditions with Pagination
     * 
     * @param user User Information
     * @return User Information Collection
     */
    @Override
    @DataScope(deptAlias = "d", userAlias = "u")
    public List<SysUser> selectAllocatedList(SysUser user)
    {
        return userMapper.selectAllocatedList(user);
    }

    /**
     * Query Unallocated User Role List by Conditions with Pagination
     * 
     * @param user User Information
     * @return User Information Collection
     */
    @Override
    @DataScope(deptAlias = "d", userAlias = "u")
    public List<SysUser> selectUnallocatedList(SysUser user)
    {
        return userMapper.selectUnallocatedList(user);
    }

    /**
     * Query User by User Name
     * 
     * @param userName User Name
     * @return User Object Information
     */
    @Override
    public SysUser selectUserByUserName(String userName)
    {
        return userMapper.selectUserByUserName(userName);
    }

    /**
    * Query User by User Name
     *
     * @param phone User phone
     * @return User Object Information
    */

    @Override
    public SysUser selectUserByPhone(String phone){
        return userMapper.selectUserByPhone(phone);
    }

    /**
     * Query User by User ID
     * 
     * @param userId User ID
     * @return User Object Information
     */
    @Override
    public SysUser selectUserById(Long userId)
    {
        return userMapper.selectUserById(userId);
    }

    /**
     * Query User's Role Group
     * 
     * @param userName User Name
     * @return Result
     */
    @Override
    public String selectUserRoleGroup(String userName)
    {
        List<SysRole> list = roleMapper.selectRolesByUserName(userName);
        if (CollectionUtils.isEmpty(list))
        {
            return StringUtils.EMPTY;
        }
        return list.stream().map(SysRole::getRoleName).collect(Collectors.joining(","));
    }

    /**
     * Query User's Post Group
     * 
     * @param userName User Name
     * @return Result
     */
    @Override
    public String selectUserPostGroup(String userName)
    {
        List<SysPost> list = postMapper.selectPostsByUserName(userName);
        if (CollectionUtils.isEmpty(list))
        {
            return StringUtils.EMPTY;
        }
        return list.stream().map(SysPost::getPostName).collect(Collectors.joining(","));
    }

    /**
     * Check if User Name is Unique
     * 
     * @param user User Information
     * @return Result
     */
    @Override
    public boolean checkUserNameUnique(SysUser user)
    {
        Long userId = StringUtils.isNull(user.getUserId()) ? -1L : user.getUserId();
        SysUser info = userMapper.checkUserNameUnique(user.getUserName());
        if (StringUtils.isNotNull(info) && info.getUserId().longValue() != userId.longValue())
        {
            return UserConstants.NOT_UNIQUE;
        }
        return UserConstants.UNIQUE;
    }

    /**
     * Check if Phone Number is Unique
     *
     * @param user User Information
     * @return Result
     */
    @Override
    public boolean checkPhoneUnique(SysUser user)
    {
        Long userId = StringUtils.isNull(user.getUserId()) ? -1L : user.getUserId();
        SysUser info = userMapper.checkPhoneUnique(user.getPhonenumber());
        if (StringUtils.isNotNull(info) && info.getUserId().longValue() != userId.longValue())
        {
            return UserConstants.NOT_UNIQUE;
        }
        return UserConstants.UNIQUE;
    }

    /**
     * Check if Email is Unique
     *
     * @param user User Information
     * @return Result
     */
    @Override
    public boolean checkEmailUnique(SysUser user)
    {
        Long userId = StringUtils.isNull(user.getUserId()) ? -1L : user.getUserId();
        SysUser info = userMapper.checkEmailUnique(user.getEmail());
        if (StringUtils.isNotNull(info) && info.getUserId().longValue() != userId.longValue())
        {
            return UserConstants.NOT_UNIQUE;
        }
        return UserConstants.UNIQUE;
    }

    /**
     * Check if User Operation is Allowed
     * 
     * @param user User Information
     */
    @Override
    public void checkUserAllowed(SysUser user)
    {
        if (StringUtils.isNotNull(user.getUserId()) && user.isAdmin())
        {
            throw new ServiceException("Operation on super administrator user is not allowed");
        }
    }

    /**
     * Check if User Has Data Permission
     * 
     * @param userId User ID
     */
    @Override
    public void checkUserDataScope(Long userId)
    {
        if (!SecurityUtils.isAdmin())
        {
            SysUser user = new SysUser();
            user.setUserId(userId);
            List<SysUser> users = SpringUtils.getAopProxy(this).selectUserList(user);
            if (StringUtils.isEmpty(users))
            {
                throw new ServiceException("No permission to access user data!");
            }
        }
    }

    /**
     * Add and Save User Information
     * 
     * @param user User Information
     * @return Result
     */
    @Override
    @Transactional
    public int insertUser(SysUser user)
    {
        // Add User Information
        int rows = userMapper.insertUser(user);
        // Add User Post Association
        insertUserPost(user);
        // Add User Role Management
        insertUserRole(user);
        return rows;
    }

    /**
     * Register User Information
     * 
     * @param user User Information
     * @return Result
     */
    @Override
    public boolean registerUser(SysUser user)
    {
        return userMapper.insertUser(user) > 0;
    }

    /**
     * Update and Save User Information
     * 
     * @param user User Information
     * @return Result
     */
    @Override
    @Transactional
    public int updateUser(SysUser user)
    {
        Long userId = user.getUserId();
        // Delete User Role Association
        userRoleMapper.deleteUserRoleByUserId(userId);
        // Add User Role Management
        insertUserRole(user);
        // Delete User Post Association
        userPostMapper.deleteUserPostByUserId(userId);
        // Add User Post Management
        insertUserPost(user);
        return userMapper.updateUser(user);
    }

    /**
     * Authorize Roles to User
     * 
     * @param userId User ID
     * @param roleIds Role Group
     */
    @Override
    @Transactional
    public void insertUserAuth(Long userId, Long[] roleIds)
    {
        userRoleMapper.deleteUserRoleByUserId(userId);
        insertUserRole(userId, roleIds);
    }

    /**
     * Update User Status
     * 
     * @param user User Information
     * @return Result
     */
    @Override
    public int updateUserStatus(SysUser user)
    {
        return userMapper.updateUserStatus(user.getUserId(), user.getStatus());
    }

    /**
     * Update User Basic Information
     * 
     * @param user User Information
     * @return Result
     */
    @Override
    public int updateUserProfile(SysUser user)
    {
        return userMapper.updateUser(user);
    }

    /**
     * Update User Avatar
     * 
     * @param userId User ID
     * @param avatar Avatar Address
     * @return Result
     */
    @Override
    public boolean updateUserAvatar(Long userId, String avatar)
    {
        return userMapper.updateUserAvatar(userId, avatar) > 0;
    }

    /**
     * Update User Login Information (IP and Login Time)
     * 
     * @param userId User ID
     * @param loginIp Login IP Address
     * @param loginDate Login Time
     * @return Result
     */
    public void updateLoginInfo(Long userId, String loginIp, Date loginDate)
    {
        userMapper.updateLoginInfo(userId, loginIp, loginDate);
    }

    /**
     * Reset User Password
     * 
     * @param user User Information
     * @return Result
     */
    @Override
    public int resetPwd(SysUser user)
    {
        return userMapper.resetUserPwd(user.getUserId(), user.getPassword());
    }

    /**
     * Reset User Password
     * 
     * @param userId User ID
     * @param password Password
     * @return Result
     */
    @Override
    public int resetUserPwd(Long userId, String password)
    {
        return userMapper.resetUserPwd(userId, password);
    }

    /**
     * Add User Role Information
     * 
     * @param user User Object
     */
    public void insertUserRole(SysUser user)
    {
        this.insertUserRole(user.getUserId(), user.getRoleIds());
    }

    /**
     * Add User Post Information
     * 
     * @param user User Object
     */
    public void insertUserPost(SysUser user)
    {
        Long[] posts = user.getPostIds();
        if (StringUtils.isNotEmpty(posts))
        {
            // Add User Post Management
            List<SysUserPost> list = new ArrayList<SysUserPost>(posts.length);
            for (Long postId : posts)
            {
                SysUserPost up = new SysUserPost();
                up.setUserId(user.getUserId());
                up.setPostId(postId);
                list.add(up);
            }
            userPostMapper.batchUserPost(list);
        }
    }

    /**
     * Add User Role Information
     * 
     * @param userId User ID
     * @param roleIds Role Group
     */
    public void insertUserRole(Long userId, Long[] roleIds)
    {
        if (StringUtils.isNotEmpty(roleIds))
        {
            // Add User Role Management
            List<SysUserRole> list = new ArrayList<SysUserRole>(roleIds.length);
            for (Long roleId : roleIds)
            {
                SysUserRole ur = new SysUserRole();
                ur.setUserId(userId);
                ur.setRoleId(roleId);
                list.add(ur);
            }
            userRoleMapper.batchUserRole(list);
        }
    }

    /**
     * Delete User by User ID
     * 
     * @param userId User ID
     * @return Result
     */
    @Override
    @Transactional
    public int deleteUserById(Long userId)
    {
        // Delete User Role Association
        userRoleMapper.deleteUserRoleByUserId(userId);
        // Delete User Post Association
        userPostMapper.deleteUserPostByUserId(userId);
        return userMapper.deleteUserById(userId);
    }

    /**
     * Batch Delete User Information
     * 
     * @param userIds User IDs to Delete
     * @return Result
     */
    @Override
    @Transactional
    public int deleteUserByIds(Long[] userIds)
    {
        for (Long userId : userIds)
        {
            checkUserAllowed(new SysUser(userId));
            checkUserDataScope(userId);
        }
        // Delete User Role Association
        userRoleMapper.deleteUserRole(userIds);
        // Delete User Post Association
        userPostMapper.deleteUserPost(userIds);
        return userMapper.deleteUserByIds(userIds);
    }

    /**
     * Import User Data
     * 
     * @param userList User Data List
     * @param isUpdateSupport Whether to Support Update, if exists, update data
     * @param operName Operating User
     * @return Result
     */
    @Override
    public String importUser(List<SysUser> userList, Boolean isUpdateSupport, String operName)
    {
        if (StringUtils.isNull(userList) || userList.size() == 0)
        {
            throw new ServiceException("Imported user data cannot be empty!");
        }
        int successNum = 0;
        int failureNum = 0;
        StringBuilder successMsg = new StringBuilder();
        StringBuilder failureMsg = new StringBuilder();
        for (SysUser user : userList)
        {
            try
            {
                // Verify if this user exists
                SysUser u = userMapper.selectUserByUserName(user.getUserName());
                if (StringUtils.isNull(u))
                {
                    BeanValidators.validateWithException(validator, user);
                    deptService.checkDeptDataScope(user.getDeptId());
                    String password = configService.selectConfigByKey("sys.user.initPassword");
                    user.setPassword(SecurityUtils.encryptPassword(password));
                    user.setCreateBy(operName);
                    userMapper.insertUser(user);
                    successNum++;
                    successMsg.append("<br/>" + successNum + ". Account " + user.getUserName() + " imported successfully");
                }
                else if (isUpdateSupport)
                {
                    BeanValidators.validateWithException(validator, user);
                    checkUserAllowed(u);
                    checkUserDataScope(u.getUserId());
                    deptService.checkDeptDataScope(user.getDeptId());
                    user.setUserId(u.getUserId());
                    user.setDeptId(u.getDeptId());
                    user.setUpdateBy(operName);
                    userMapper.updateUser(user);
                    successNum++;
                    successMsg.append("<br/>" + successNum + ". Account " + user.getUserName() + " updated successfully");
                }
                else
                {
                    failureNum++;
                    failureMsg.append("<br/>" + failureNum + ". Account " + user.getUserName() + " already exists");
                }
            }
            catch (Exception e)
            {
                failureNum++;
                String msg = "<br/>" + failureNum + ". Account " + user.getUserName() + " import failed: ";
                failureMsg.append(msg + e.getMessage());
                log.error(msg, e);
            }
        }
        if (failureNum > 0)
        {
            failureMsg.insert(0, "Sorry, import failed! A total of " + failureNum + " data entries have incorrect format, errors are as follows: ");
            throw new ServiceException(failureMsg.toString());
        }
        else
        {
            successMsg.insert(0, "Congratulations, all data imported successfully! A total of " + successNum + " entries, data as follows: ");
        }
        return successMsg.toString();
    }
}
