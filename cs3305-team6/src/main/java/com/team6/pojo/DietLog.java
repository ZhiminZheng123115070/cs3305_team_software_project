package com.team6.pojo;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * @author zhimin
 * 2026/2/18 00:46
 */
public class DietLog {

    private Long id;
    private Long userId;
    private Long productId;
    private BigDecimal caloriesKcal;
    private BigDecimal consumptionRate;
    private LocalDateTime eatenAt;

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

    public Long getProductId() {
        return productId;
    }

    public void setProductId(Long productId) {
        this.productId = productId;
    }

    public BigDecimal getCaloriesKcal() {
        return caloriesKcal;
    }

    public void setCaloriesKcal(BigDecimal caloriesKcal) {
        this.caloriesKcal = caloriesKcal;
    }

    public BigDecimal getConsumptionRate() {
        return consumptionRate;
    }

    public void setConsumptionRate(BigDecimal consumptionRate) {
        this.consumptionRate = consumptionRate;
    }

    public LocalDateTime getEatenAt() {
        return eatenAt;
    }

    public void setEatenAt(LocalDateTime eatenAt) {
        this.eatenAt = eatenAt;
    }
}
