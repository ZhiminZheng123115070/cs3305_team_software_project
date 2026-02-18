package com.team6.response;

import com.team6.pojo.HealthInfoRecord;
import com.team6.pojo.UserInfo;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * @author zhimin
 * 2026/2/18 15:24
 */
public class HealthInfoRecordResponse {
    private Long id;
    private Long userId;
    private String nickname;

    private BigDecimal weight;
    private BigDecimal height;
    private Integer age;
    private Integer gender;
    private BigDecimal bmi;
    private BigDecimal bmr;

    private Integer status;

    private LocalDateTime createdAt;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }

    public String getNickname() {
        return nickname;
    }

    public void setNickname(String nickname) {
        this.nickname = nickname;
    }

    public BigDecimal getWeight() {
        return weight;
    }

    public void setWeight(BigDecimal weight) {
        this.weight = weight;
    }

    public BigDecimal getHeight() {
        return height;
    }

    public void setHeight(BigDecimal height) {
        this.height = height;
    }

    public Integer getAge() {
        return age;
    }

    public void setAge(Integer age) {
        this.age = age;
    }

    public Integer getGender() {
        return gender;
    }

    public void setGender(Integer gender) {
        this.gender = gender;
    }

    public BigDecimal getBmi() {
        return bmi;
    }

    public void setBmi(BigDecimal bmi) {
        this.bmi = bmi;
    }

    public BigDecimal getBmr() {
        return bmr;
    }

    public void setBmr(BigDecimal bmr) {
        this.bmr = bmr;
    }

    public Integer getStatus() {
        return status;
    }

    public void setStatus(Integer status) {
        this.status = status;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public static HealthInfoRecordResponse from(HealthInfoRecord record) {
        if (record == null) return null;
        HealthInfoRecordResponse r = new HealthInfoRecordResponse();
        r.setId(record.getId());
        r.setUserId(record.getUserId());
        r.setNickname(record.getNickname());
        r.setWeight(record.getWeight());
        r.setHeight(record.getHeight());
        r.setAge(record.getAge());
        r.setGender(record.getGender());
        r.setBmi(record.getBmi());
        r.setBmr(record.getBmr());
        r.setStatus(record.getStatus());
        r.setCreatedAt(record.getCreatedAt());
        return r;
    }
}
