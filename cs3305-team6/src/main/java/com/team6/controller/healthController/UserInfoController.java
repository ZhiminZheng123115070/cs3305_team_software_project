package com.team6.controller.healthController;

import com.ruoyi.common.core.domain.AjaxResult;
import com.team6.request.UserInfoRequest;
import com.team6.response.UserInfoResponse;
import com.team6.service.healthService.IUserInfoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * User profile (app_user_info) and history (app_user_info_record).
 *
 * @author zhimin
 * 2026/2/18 01:06
 */
@RestController
@RequestMapping("/user/info")
public class UserInfoController {

    @Autowired
    private IUserInfoService userInfoService;

    /**
     * Add or update current user's profile and append a snapshot to history.
     * Request body: UserInfoRequest. Response: UserInfoResponse (saved profile).
     */
    @PostMapping
    public AjaxResult addUserInfoAndLog(@RequestBody UserInfoRequest request) {
        UserInfoResponse response = userInfoService.addUserInfoAndLog(request);
        return AjaxResult.success(response);
    }
}
