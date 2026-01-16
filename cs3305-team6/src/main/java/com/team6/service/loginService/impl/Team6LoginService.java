package com.team6.service.loginService.impl;

import com.ruoyi.common.constant.UserConstants;
import com.ruoyi.common.core.domain.entity.SysUser;
import com.ruoyi.common.core.domain.model.LoginUser;
import com.ruoyi.common.core.redis.RedisCache;
import com.ruoyi.common.enums.UserStatus;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.exception.user.CaptchaException;
import com.ruoyi.common.exception.user.CaptchaExpireException;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.framework.web.service.TokenService;
import com.ruoyi.framework.web.service.UserDetailsServiceImpl;
import com.ruoyi.system.service.ISysConfigService;
import com.ruoyi.system.service.ISysUserService;
import com.team6.service.loginService.ITeam6LoginService;

import java.util.Random;
import java.util.concurrent.TimeUnit;

import org.slf4j.LoggerFactory;
import org.slf4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.stereotype.Service;

/**
 * @author zhimin
 *  2026/1/16 12:06
 */
@Service
public class Team6LoginService  implements ITeam6LoginService {
    private static final Logger log=LoggerFactory.getLogger(Team6LoginService.class);

    /*
    * The prefix of Redis key with SMS verification
    * */
    private static final String SMS_CODE_KEY="sms_code:";

    @Autowired
    private RedisCache redisCache;

    @Autowired
    private ISysUserService userService;

    @Autowired
    private ISysConfigService configService;
    @Autowired
    private UserDetailsServiceImpl userDetailsService;

    @Autowired
    private TokenService tokenService;

    @Override
    public void sendSmsCode(String phone){
        // generate a random amount of verification code
        Random random = new Random();
        String code = String.format("%06d", random.nextInt(1000000));

        // print verification code in terminal
        log.info("====================SMS verification code====================");
        log.info("phone: {}", phone);
        log.info("verification: {}", code);
        log.info("====================SMS verification code====================");

        // Store to Redis with a 5-minute TTL
        String key = SMS_CODE_KEY + phone;
        redisCache.setCacheObject(key, code, 5, TimeUnit.MINUTES);
    }

    @Override
    public String login(String phone, String code){
        validateCaptcha(phone,code);

        SysUser user= userService.selectUserByPhone(phone);
        if(user ==null){
            // default: register login
            // If user no existed, register a new account automatically
            user=createUserByPhone(phone);
        }

        if(UserStatus.DELETED.getCode().equals(user.getDelFlag())){
            throw  new ServiceException("The account was deleted");
        }

        if(UserStatus.DISABLE.getCode().equals(user.getDelFlag())){
            throw new ServiceException("The account was stoped");
        }

        LoginUser loginUser=(LoginUser) userDetailsService.createLoginUser(user);
        return tokenService.createToken(loginUser);
    }

    public void validateCaptcha(String phone, String code){
        String key=SMS_CODE_KEY+phone;

        String storedCode=redisCache.getCacheObject(key);
        if(storedCode.isEmpty()){
            throw new CaptchaExpireException();
        }

        redisCache.deleteObject(key);

        if(!code.equalsIgnoreCase(storedCode)){
            throw new CaptchaException();
        }
    }

    public SysUser createUserByPhone(String phone){
        SysUser newMemberUser=new SysUser();

        newMemberUser.setUserName("mobile_"+phone);
        newMemberUser.setPhonenumber(phone);
        newMemberUser.setNickName("member_"+phone.substring(phone.length()-4));
        String defaultPassword=configService.selectConfigByKey("sys.user.initPassword");
        if(StringUtils.isEmpty(defaultPassword)){
            defaultPassword="123456";
        }
        newMemberUser.setPassword(SecurityUtils.encryptPassword(defaultPassword));
        newMemberUser.setStatus(UserConstants.NORMAL);

        if(!userService.checkUserNameUnique(newMemberUser)){
            newMemberUser.setUserName("mobile_"+phone);
        }

        newMemberUser.setRoleIds(new Long[]{100L});
         int rows=userService.insertUser(newMemberUser);
         if(rows<0){
             throw new ServiceException("Automatic user creation failed");
         }

         return userService.selectUserByPhone(phone);



    }
}
