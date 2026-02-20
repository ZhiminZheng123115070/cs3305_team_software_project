package com.team6.controller.loginController;

import com.ruoyi.common.annotation.Anonymous;
import com.ruoyi.common.constant.Constants;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.domain.model.MobileLoginBody;
import com.team6.service.loginService.impl.Team6LoginService;
import com.team6.strategy.login.factory.LoginStrategyFactory;
import com.team6.strategy.login.handler.AbstractLoginHandler;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.Map;

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
        Map<String,String> params=new HashMap<>();
        AbstractLoginHandler handler=LoginStrategyFactory.getStrategy("mobile-login");
        params.put("mobile",request.getPhone());
        handler.sendSmsCode(params);
        return AjaxResult.success();
    }

    @PostMapping("/mobile/login")
    public AjaxResult mobileLogin(@RequestBody MobileLoginBody mobileLoginBody){
        AjaxResult ajax = AjaxResult.success();
        AbstractLoginHandler handler= LoginStrategyFactory.getStrategy("mobile-login");
        Map<String,String> params=new HashMap<>();

        params.put("mobile",mobileLoginBody.getPhone());
        params.put("code", mobileLoginBody.getCode());

        String token = handler.login(params);
        ajax.put(Constants.TOKEN, token);
        return ajax;
    }



}
