package com.team6.service.loginService;

import java.util.Map;

/**
 * Google OAuth2 login service (code → access_token → user info).
 *
 * @author zhimin
 * 2026/1/29 18:20
 */
public interface IGoogleLoginService {

    /**
     * Exchange authorization code for access token.
     *
     * @param code authorization code from Google callback
     * @return access token
     */
    String getAccessToken(String code);

    /**
     * Get Google user info by access token.
     *
     * @param accessToken Google access token
     * @return map with id, email, name, picture, etc.
     */
    Map<String, Object> getUserInfo(String accessToken);
}
