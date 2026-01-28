package com.team6.strategy.login.handler.impl;


import com.team6.service.loginService.impl.Team6LoginService;
import com.team6.strategy.login.handler.AbstractLoginHandler;
import com.team6.strategy.login.factory.LoginStrategyFactory;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.Map;

/**
 * @author zhimin
 * 2026/1/28 15:18
 */
@Component
public class MobileLoginHandler extends AbstractLoginHandler implements InitializingBean {
    @Autowired
    private Team6LoginService mobileLoginService;
    @Override
    protected String doLogin(Map<String, String> params) {

        String mobile = params.get("mobile");
        String code = params.get("code");

        return mobileLoginService.login(mobile,code);
    }
    
    /**
     * Auto-register to factory during Spring initialization
     */
    @Override
    public void afterPropertiesSet() throws Exception {
        LoginStrategyFactory.register("mobile-login", this);
    }

    @Override
    public void doSendSmsCode(Map<String, String> params){
        mobileLoginService.sendSmsCode(params.get("mobile"));
    }
}
