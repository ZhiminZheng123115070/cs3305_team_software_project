package com.team6.controller.loginController;

import com.ruoyi.common.annotation.Anonymous;
import com.ruoyi.common.constant.Constants;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.domain.model.MobileLoginBody;
import com.team6.service.loginService.impl.Team6LoginService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

/**
 * @author zhimin
 * 2026/1/15 21:34
 */

@Anonymous
@RestController
public class Team6MobileLoginSystem {
    @Autowired
    private Team6LoginService loginService;

    @PostMapping("/mobile/sendCode")
    public AjaxResult sendSmsCode(@RequestBody MobileLoginBody request){

        loginService.sendSmsCode(request.getPhone());
        return AjaxResult.success();
    }

    @PostMapping("/mobile/login")
    public AjaxResult mobileLogin(@RequestBody MobileLoginBody mobileLoginBody){
        AjaxResult ajax = AjaxResult.success();
        String token = loginService.login(mobileLoginBody.getPhone(), mobileLoginBody.getCode());
        ajax.put(Constants.TOKEN, token);
        return ajax;
    }

}
