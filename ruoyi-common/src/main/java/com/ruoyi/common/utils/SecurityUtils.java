package com.ruoyi.common.utils;

import java.util.Collection;
import java.util.List;
import java.util.stream.Collectors;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.util.PatternMatchUtils;
import com.ruoyi.common.constant.Constants;
import com.ruoyi.common.constant.HttpStatus;
import com.ruoyi.common.core.domain.entity.SysRole;
import com.ruoyi.common.core.domain.model.LoginUser;
import com.ruoyi.common.exception.ServiceException;

/**
 * Security service utility class
 * 
 * @author ruoyi
 */
public class SecurityUtils
{

    /**
     * Get user ID
     **/
    public static Long getUserId()
    {
        try
        {
            return getLoginUser().getUserId();
        }
        catch (Exception e)
        {
            throw new ServiceException("Failed to get user ID", HttpStatus.UNAUTHORIZED);
        }
    }

    /**
     * Get department ID
     **/
    public static Long getDeptId()
    {
        try
        {
            return getLoginUser().getDeptId();
        }
        catch (Exception e)
        {
            throw new ServiceException("Failed to get department ID", HttpStatus.UNAUTHORIZED);
        }
    }

    /**
     * Get user account
     **/
    public static String getUsername()
    {
        try
        {
            return getLoginUser().getUsername();
        }
        catch (Exception e)
        {
            throw new ServiceException("Failed to get user account", HttpStatus.UNAUTHORIZED);
        }
    }

    /**
     * Get user
     **/
    public static LoginUser getLoginUser()
    {
        try
        {
            return (LoginUser) getAuthentication().getPrincipal();
        }
        catch (Exception e)
        {
            throw new ServiceException("Failed to get user information", HttpStatus.UNAUTHORIZED);
        }
    }

    /**
     * Get Authentication
     */
    public static Authentication getAuthentication()
    {
        return SecurityContextHolder.getContext().getAuthentication();
    }

    /**
     * Generate BCryptPasswordEncoder password
     *
     * @param password Password
     * @return Encrypted string
     */
    public static String encryptPassword(String password)
    {
        BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();
        return passwordEncoder.encode(password);
    }

    /**
     * Check if passwords match
     *
     * @param rawPassword Raw password
     * @param encodedPassword Encrypted string
     * @return Result
     */
    public static boolean matchesPassword(String rawPassword, String encodedPassword)
    {
        BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();
        return passwordEncoder.matches(rawPassword, encodedPassword);
    }

    /**
     * Check if user is administrator
     * 
     * @return Result
     */
    public static boolean isAdmin()
    {
        return isAdmin(getUserId());
    }

    /**
     * Check if user is administrator
     * 
     * @param userId User ID
     * @return Result
     */
    public static boolean isAdmin(Long userId)
    {
        return userId != null && 1L == userId;
    }

    /**
     * Verify if user has a permission
     * 
     * @param permission Permission string
     * @return Whether user has the permission
     */
    public static boolean hasPermi(String permission)
    {
        return hasPermi(getLoginUser().getPermissions(), permission);
    }

    /**
     * Check if permissions contain the specified permission
     * 
     * @param authorities Permission list
     * @param permission Permission string
     * @return Whether user has the permission
     */
    public static boolean hasPermi(Collection<String> authorities, String permission)
    {
        return authorities.stream().filter(StringUtils::hasText)
                .anyMatch(x -> Constants.ALL_PERMISSION.equals(x) || PatternMatchUtils.simpleMatch(x, permission));
    }

    /**
     * Verify if user has a role
     * 
     * @param role Role identifier
     * @return Whether user has the role
     */
    public static boolean hasRole(String role)
    {
        List<SysRole> roleList = getLoginUser().getUser().getRoles();
        Collection<String> roles = roleList.stream().map(SysRole::getRoleKey).collect(Collectors.toSet());
        return hasRole(roles, role);
    }

    /**
     * Check if roles contain the specified role
     * 
     * @param roles Role list
     * @param role Role
     * @return Whether user has the role permission
     */
    public static boolean hasRole(Collection<String> roles, String role)
    {
        return roles.stream().filter(StringUtils::hasText)
                .anyMatch(x -> Constants.SUPER_ADMIN.equals(x) || PatternMatchUtils.simpleMatch(x, role));
    }

}
