package com.ruoyi.common.core.domain.model;

/**
 * @author zhimin
 * 2026/1/15 21:09
 */
public class MobileLoginBody {

    /*
    * phone number
    * */
    private String phone;
    /*
    * verification code
    * */
    private String code;

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }
}
