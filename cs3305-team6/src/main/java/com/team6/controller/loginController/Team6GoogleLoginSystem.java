package com.team6.controller.loginController;

import com.ruoyi.common.annotation.Anonymous;
import com.ruoyi.common.constant.Constants;
import com.ruoyi.common.core.domain.AjaxResult;
import com.team6.strategy.login.factory.LoginStrategyFactory;
import com.team6.strategy.login.handler.AbstractLoginHandler;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.Collections;

/**
 *
 * @author zhimin
 */
@Slf4j
@Anonymous
@RestController
public class Team6GoogleLoginSystem {

    @Value("${google.clientId}")
    private String clientId;

    @Value("${google.redirectUri}")
    private String redirectUri;

    /**
     * Google login callback（App 内 WebView 用 code 换 token，返回 JSON）
     */
    @GetMapping("/user/login/google/callback")
    public AjaxResult callback(@RequestParam("code") String code) {
        try {
            AbstractLoginHandler handler = LoginStrategyFactory.getStrategy("google-login");
            String token = handler.login(Collections.singletonMap("code", code));
            AjaxResult ajax = AjaxResult.success();
            ajax.put(Constants.TOKEN, token);
            return ajax;
        } catch (Exception e) {
            log.error("Google login failed: {}", e.getMessage(), e);
            return AjaxResult.error("Google login failed: " + e.getMessage());
        }
    }

    /**
     * Get Google auth URL
     */
    @GetMapping("/user/login/google/auth-url")
    public AjaxResult getAuthUrl() {
        try {
            String state = "google_login_" + System.currentTimeMillis();
            String scope = "openid email profile";
            // prompt=select_account：每次打开授权页都显示账号选择，方便退出后重新选账号登录
            String authUrl = String.format(
                "https://accounts.google.com/o/oauth2/v2/auth?client_id=%s&redirect_uri=%s&response_type=code&scope=%s&state=%s&prompt=select_account",
                clientId,
                java.net.URLEncoder.encode(redirectUri, "UTF-8"),
                scope,
                state
            );
            return AjaxResult.success().put("authUrl", authUrl);
        } catch (Exception e) {
            log.error("Failed to build Google auth URL: {}", e.getMessage(), e);
            return AjaxResult.error("Failed to build auth URL: " + e.getMessage());
        }
    }
}
