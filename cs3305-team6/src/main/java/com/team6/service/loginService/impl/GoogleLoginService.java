package com.team6.service.loginService.impl;

import com.alibaba.fastjson2.JSON;
import com.alibaba.fastjson2.JSONObject;
import com.team6.service.loginService.IGoogleLoginService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestTemplate;

import java.util.HashMap;
import java.util.Map;

/**
 *
 * @author zhimin
 * 2026/1/29 18:21
 */
@Service
public class GoogleLoginService implements IGoogleLoginService {

    private static final Logger log = LoggerFactory.getLogger(GoogleLoginService.class);
    private static final String TOKEN_URL = "https://oauth2.googleapis.com/token";
    private static final String USERINFO_URL = "https://www.googleapis.com/oauth2/v2/userinfo";

    @Value("${google.clientId}")
    private String clientId;

    @Value("${google.clientSecret}")
    private String clientSecret;

    @Value("${google.redirectUri}")
    private String redirectUri;

    private final RestTemplate restTemplate = new RestTemplate();

    @Override
    public String getAccessToken(String code) {
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);

        MultiValueMap<String, String> params = new LinkedMultiValueMap<>();
        params.add("code", code);
        params.add("client_id", clientId);
        params.add("client_secret", clientSecret);
        params.add("redirect_uri", redirectUri);
        params.add("grant_type", "authorization_code");

        HttpEntity<MultiValueMap<String, String>> request = new HttpEntity<>(params, headers);
        ResponseEntity<String> response = restTemplate.exchange(TOKEN_URL, HttpMethod.POST, request, String.class);
        String body = response.getBody();
        if (body == null || body.isEmpty()) {
            throw new RuntimeException("Google token response is empty");
        }
        JSONObject json = JSON.parseObject(body);
        if (json.containsKey("error")) {
            String error = json.getString("error");
            String errorDesc = json.getString("error_description");
            log.error("Failed to get access_token: {} - {}", error, errorDesc);
            throw new RuntimeException("Failed to get access_token: " + errorDesc);
        }
        String accessToken = json.getString("access_token");
        log.info("Got Google access_token");
        return accessToken;
    }

    @Override
    public Map<String, Object> getUserInfo(String accessToken) {
        HttpHeaders headers = new HttpHeaders();
        headers.setBearerAuth(accessToken);
        HttpEntity<Void> request = new HttpEntity<>(headers);
        ResponseEntity<String> response = restTemplate.exchange(USERINFO_URL, HttpMethod.GET, request, String.class);
        String body = response.getBody();
        if (body == null || body.isEmpty()) {
            throw new RuntimeException("Google userinfo response is empty");
        }
        JSONObject json = JSON.parseObject(body);
        if (json.containsKey("error")) {
            String error = json.getString("error");
            String errorDesc = json.getString("error_description");
            log.error("Failed to get user info: {} - {}", error, errorDesc);
            throw new RuntimeException("Failed to get user info: " + errorDesc);
        }
        Map<String, Object> userInfo = new HashMap<>();
        userInfo.put("id", json.getString("id"));
        userInfo.put("email", json.getString("email"));
        userInfo.put("name", json.getString("name"));
        userInfo.put("picture", json.getString("picture"));
        userInfo.put("verified_email", json.getBooleanValue("verified_email"));
        log.info("Got Google user info: {}", userInfo.get("email"));
        return userInfo;
    }
}
