package com.team6.strategy.login.handler;

import java.util.Map;

/**
 * @author zhimin
 * 2026/1/28 15:16
 */
public abstract class AbstractLoginHandler {
    public final String login(Map<String,String> params){
        String token=doLogin(params);
        return token;
    }

    public final void sendSmsCode(Map<String, String> params){
        doSendSmsCode(params);
    }

    protected abstract String doLogin(Map<String,String> params);

    protected void doSendSmsCode(Map<String,String>params){

    }


}
