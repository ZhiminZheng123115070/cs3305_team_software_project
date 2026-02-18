package com.team6.pojo;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * @author zhimin
 * 2026/2/18 00:47
 */
public class NutritionRecord {
    private Long id;
    private Long userId;

    private BigDecimal energyKcal;
    private BigDecimal fat;
    private BigDecimal saturatedFat;
    private BigDecimal carbohydrates;
    private BigDecimal sugars;
    private BigDecimal fiber;
    private BigDecimal proteins;
    private BigDecimal salt;

    private LocalDateTime updatedAt;
    private LocalDate recordDate;

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

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }

    public LocalDate getRecordDate() {
        return recordDate;
    }

    public void setRecordDate(LocalDate recordDate) {
        this.recordDate = recordDate;
    }
}
