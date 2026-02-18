package com.team6.controller.healthController;

import com.ruoyi.common.core.domain.AjaxResult;
import com.team6.request.UserInfoRequest;
import com.team6.response.UserInfoResponse;
import com.team6.service.healthService.IUserInfoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

/**
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
     *
     */
    @PostMapping
    public AjaxResult insertOrUpdateUserInfoAndAddLog(@RequestBody UserInfoRequest request) {
        UserInfoResponse response = userInfoService.insertOrUpdateUserInfoAndAddLog(request);
        return AjaxResult.success(response);
    }



}
