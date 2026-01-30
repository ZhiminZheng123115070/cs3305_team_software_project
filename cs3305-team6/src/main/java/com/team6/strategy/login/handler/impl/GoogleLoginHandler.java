package com.team6.strategy.login.handler.impl;

import com.team6.strategy.login.factory.LoginStrategyFactory;
import com.team6.strategy.login.handler.AbstractLoginHandler;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.stereotype.Component;

import java.util.Map;

/**
 * @author zhimin
 * 2026/1/29 18:32
 */
@Component
public class GoogleLoginHandler extends AbstractLoginHandler implements InitializingBean {
    @Override
    protected String doLogin(Map<String,String> params){
        return "";
    }

    @Override
    public void afterPropertiesSet() throws Exception{
        LoginStrategyFactory.register("google-login",this);
    }
}
