package com.team6.strategy.login.factory;

import com.team6.strategy.login.handler.AbstractLoginHandler;
import org.springframework.stereotype.Component;

import java.util.HashMap;
import java.util.Map;

/**
 * @author zhimin
 * 2026/1/28 15:18
 */
@Component
public class LoginStrategyFactory {
    private final static Map<String, AbstractLoginHandler> strategyMap=new HashMap<>();

    public static AbstractLoginHandler getStrategy(String type){
        if(type ==null || type.trim().isEmpty()){
            throw new IllegalArgumentException("Login type can't be null");
        }
        return strategyMap.get(type);
    }

    public static void register(String type, AbstractLoginHandler handler){
        strategyMap.put(type, handler);
    }
}
