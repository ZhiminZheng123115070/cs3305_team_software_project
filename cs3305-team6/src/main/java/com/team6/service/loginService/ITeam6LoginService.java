package com.team6.service.loginService;

/**
 * @author zhimin
 *  2026/1/16 12:04
 */
public interface ITeam6LoginService {
    public void sendSmsCode(String phone);

    public String login(String phone, String code);
}
