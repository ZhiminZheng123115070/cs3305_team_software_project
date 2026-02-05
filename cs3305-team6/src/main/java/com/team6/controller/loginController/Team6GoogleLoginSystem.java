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

import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
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

    @Value("${google.redirectUriAndroid:${google.redirectUri}}")
    private String redirectUriAndroid;

    /**
     * Google login callback: exchange code for token (JSON response).
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
     * Get Google auth URL. Client should pass platform so we use the correct redirect_uri:
     * - android: redirectUriAndroid (10.0.2.2:8080 so emulator browser can reach host)
     * - ios or others: redirectUri (localhost:8080)
     */
    @GetMapping("/user/login/google/auth-url")
    public AjaxResult getAuthUrl(@RequestParam(value = "platform", required = false) String platform) {
        try {
            String state = "google_login_" + System.currentTimeMillis();
            String scope = "openid email profile";
            boolean isAndroid = platform != null && "android".equalsIgnoreCase(platform.trim());
            String redirect = isAndroid ? redirectUriAndroid : redirectUri;
            String authUrl = String.format(
                "https://accounts.google.com/o/oauth2/v2/auth?client_id=%s&redirect_uri=%s&response_type=code&scope=%s&state=%s&prompt=select_account&hl=en",
                clientId,
                java.net.URLEncoder.encode(redirect, "UTF-8"),
                scope,
                state
            );
            return AjaxResult.success().put("authUrl", authUrl);
        } catch (Exception e) {
            log.error("Failed to build Google auth URL: {}", e.getMessage(), e);
            return AjaxResult.error("Failed to build auth URL: " + e.getMessage());
        }
    }

    /**
     * OAuth2 redirect: Google redirects the browser here after user signs in.
     * We redirect the browser to the app custom scheme so the app receives the code.
     * Use this as redirect_uri in Google Console when opening auth in system browser (not WebView).
     */
    @GetMapping("/oauth2/google/callback")
    public void oauth2Redirect(
            @RequestParam("code") String code,
            @RequestParam(value = "state", required = false) String state,
            HttpServletResponse response) throws IOException {
        String appUrl = "ruoyiapp://google-login?code=" + URLEncoder.encode(code, StandardCharsets.UTF_8.name());
        response.sendRedirect(appUrl);
    }
}
