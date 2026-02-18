package com.team6.response;

import com.team6.pojo.UserInfo;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * @author zhimin
 * 2026/2/18 01:49
 */
public class UserInfoResponse {
    private Long userId;
    private String nickname;

    private BigDecimal weight;
    private BigDecimal height;
    private Integer age;
    private Integer gender;
    private BigDecimal bmi;
    private BigDecimal bmr;

    private BigDecimal energyKcal;
    private BigDecimal fat;
    private BigDecimal saturatedFat;
    private BigDecimal carbohydrates;
    private BigDecimal sugars;
    private BigDecimal fiber;
    private BigDecimal proteins;
    private BigDecimal salt;

    private Integer status;

    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

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

    public BigDecimal getEnergyKcal() {
        return energyKcal;
    }

    public void setEnergyKcal(BigDecimal energyKcal) {
        this.energyKcal = energyKcal;
    }

    public BigDecimal getFat() {
        return fat;
    }

    public void setFat(BigDecimal fat) {
        this.fat = fat;
    }

    public BigDecimal getSaturatedFat() {
        return saturatedFat;
    }

    public void setSaturatedFat(BigDecimal saturatedFat) {
        this.saturatedFat = saturatedFat;
    }

    public BigDecimal getCarbohydrates() {
        return carbohydrates;
    }

    public void setCarbohydrates(BigDecimal carbohydrates) {
        this.carbohydrates = carbohydrates;
    }

    public BigDecimal getSugars() {
        return sugars;
    }

    public void setSugars(BigDecimal sugars) {
        this.sugars = sugars;
    }

    public BigDecimal getFiber() {
        return fiber;
    }

    public void setFiber(BigDecimal fiber) {
        this.fiber = fiber;
    }

    public BigDecimal getProteins() {
        return proteins;
    }

    public void setProteins(BigDecimal proteins) {
        this.proteins = proteins;
    }

    public BigDecimal getSalt() {
        return salt;
    }

    public void setSalt(BigDecimal salt) {
        this.salt = salt;
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

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }

    /**
     * Build response from UserInfo entity.
     */
    public static UserInfoResponse from(UserInfo info) {
        if (info == null) return null;
        UserInfoResponse r = new UserInfoResponse();
        r.setUserId(info.getUserId());
        r.setNickname(info.getNickname());
        r.setWeight(info.getWeight());
        r.setHeight(info.getHeight());
        r.setAge(info.getAge());
        r.setGender(info.getGender());
        r.setBmi(info.getBmi());
        r.setBmr(info.getBmr());
        r.setEnergyKcal(info.getEnergyKcal());
        r.setFat(info.getFat());
        r.setSaturatedFat(info.getSaturatedFat());
        r.setCarbohydrates(info.getCarbohydrates());
        r.setSugars(info.getSugars());
        r.setFiber(info.getFiber());
        r.setProteins(info.getProteins());
        r.setSalt(info.getSalt());
        r.setStatus(info.getStatus());
        r.setCreatedAt(info.getCreatedAt());
        r.setUpdatedAt(info.getUpdatedAt());
        return r;
    }
}
