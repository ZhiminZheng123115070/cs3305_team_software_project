package com.ruoyi.system.service;

import com.ruoyi.common.core.domain.model.LoginUser;
import com.ruoyi.system.domain.SysUserOnline;

/**
 * Online User Service Layer
 * 
 * @author ruoyi
 */
public interface ISysUserOnlineService
{
    /**
     * Query Information by Login Address
     * 
     * @param ipaddr Login Address
     * @param user User Information
     * @return Online User Information
     */
    public SysUserOnline selectOnlineByIpaddr(String ipaddr, LoginUser user);

    /**
     * Query Information by Username
     * 
     * @param userName Username
     * @param user User Information
     * @return Online User Information
     */
    public SysUserOnline selectOnlineByUserName(String userName, LoginUser user);

    /**
     * Query Information by Login Address/Username
     * 
     * @param ipaddr Login Address
     * @param userName Username
     * @param user User Information
     * @return Online User Information
     */
    public SysUserOnline selectOnlineByInfo(String ipaddr, String userName, LoginUser user);

    /**
     * Set Online User Information
     * 
     * @param user User Information
     * @return Online User
     */
    public SysUserOnline loginUserToUserOnline(LoginUser user);
}
