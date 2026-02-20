package com.team6.strategy.login.handler.impl;

import com.ruoyi.common.constant.UserConstants;
import com.ruoyi.common.core.domain.entity.SysRole;
import com.ruoyi.common.core.domain.entity.SysUser;
import com.ruoyi.common.core.domain.model.LoginUser;
import com.ruoyi.common.utils.DateUtils;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.framework.web.service.TokenService;
import com.ruoyi.framework.web.service.UserDetailsServiceImpl;
import com.ruoyi.system.service.ISysConfigService;
import com.ruoyi.system.service.ISysRoleService;
import com.ruoyi.system.service.ISysUserService;
import com.team6.service.loginService.impl.GoogleLoginService;
import com.team6.strategy.login.factory.LoginStrategyFactory;
import com.team6.strategy.login.handler.AbstractLoginHandler;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Map;

/**
 * Google OAuth2 login handler: code → access_token → user info → create/update SysUser → JWT.
 *
 * @author zhimin
 * 2026/1/29 18:32
 */
@Slf4j
@Component
public class GoogleLoginHandler extends AbstractLoginHandler implements InitializingBean {

    @Autowired
    private GoogleLoginService googleLoginService;

    @Autowired
    private ISysUserService userService;

    @Autowired
    private UserDetailsServiceImpl userDetailsService;

    @Autowired
    private TokenService tokenService;

    @Autowired
    private ISysConfigService configService;

    @Autowired
    private ISysRoleService roleService;

    @Override
    protected String doLogin(Map<String, String> params) {
        String code = params.get("code");
        if (code == null || code.isEmpty()) {
            throw new IllegalArgumentException("code is required");
        }

        log.info("Google login callback, code: {}", code);

        // 1. Exchange code for access_token
        String accessToken = googleLoginService.getAccessToken(code);
        log.info("Got access_token");

        // 2. Get Google user info
        Map<String, Object> googleUserInfo = googleLoginService.getUserInfo(accessToken);
        String googleId = (String) googleUserInfo.get("id");
        String email = (String) googleUserInfo.get("email");
        String name = (String) googleUserInfo.get("name");
        String picture = (String) googleUserInfo.get("picture");

        log.info("Got Google user: email={}, name={}", email, name);

        // 3. Create or update SysUser (userName = google_ + email)
        String userName = "google_" + (email != null ? email : googleId);
        SysUser sysUser = userService.selectUserByUserName(userName);
        boolean isNewUser = (sysUser == null);

        if (isNewUser) {
            log.info("New user, auto register: email={}", email);
            sysUser = new SysUser();
            sysUser.setUserName(userName);
            sysUser.setNickName(name != null ? name : email);
            sysUser.setEmail(email);
            if (picture != null && !picture.isEmpty()) {
                sysUser.setAvatar(picture);
            }
            String defaultPassword = configService.selectConfigByKey("sys.user.initPassword");
            if (StringUtils.isEmpty(defaultPassword)) {
                defaultPassword = "123456";
            }
            sysUser.setPassword(SecurityUtils.encryptPassword(defaultPassword));
            sysUser.setStatus(UserConstants.NORMAL);
            sysUser.setPwdUpdateDate(DateUtils.getNowDate());
            Long memberRoleId = getMemberRoleId();
            sysUser.setRoleIds(new Long[]{memberRoleId});
            int rows = userService.insertUser(sysUser);
            if (rows <= 0) {
                throw new RuntimeException("Failed to create SysUser");
            }
            sysUser = userService.selectUserByUserName(userName);
            log.info("Created SysUser, userId={}, roleId={}", sysUser.getUserId(), memberRoleId);
        } else {
            log.info("Existing user login: userId={}, email={}", sysUser.getUserId(), email);
            sysUser.setNickName(name != null ? name : email);
            if (picture != null && !picture.isEmpty()) {
                sysUser.setAvatar(picture);
            }
            userService.updateUser(sysUser);
            log.info("Updated SysUser, userId={}", sysUser.getUserId());
        }

        // 4. Create LoginUser and JWT
        LoginUser loginUser = (LoginUser) userDetailsService.createLoginUser(sysUser);
        String token = tokenService.createToken(loginUser);
        log.info("Token created, userId={}", sysUser.getUserId());
        return token;
    }

    /**
     * Get member role ID; if not found, use default role 2 (common).
     */
    private Long getMemberRoleId() {
        try {
            SysRole searchRole = new SysRole();
            searchRole.setRoleKey("member");
            List<SysRole> roles = roleService.selectRoleList(searchRole);
            if (roles != null && !roles.isEmpty()) {
                SysRole found = roles.get(0);
                log.info("Found member role: roleId={}, roleName={}", found.getRoleId(), found.getRoleName());
                return found.getRoleId();
            }
        } catch (Exception e) {
            log.warn("Lookup member role failed, use default: {}", e.getMessage());
        }
        log.info("Use default role (roleId=2)");
        return 2L;
    }

    @Override
    public void afterPropertiesSet() throws Exception {
        LoginStrategyFactory.register("google-login", this);
    }
}
