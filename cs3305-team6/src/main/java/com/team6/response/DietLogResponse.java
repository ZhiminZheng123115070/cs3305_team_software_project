package com.team6.response;

import com.team6.pojo.DietLog;
import com.team6.pojo.Storage;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * Diet log response DTO (what was eaten).
 * @author zhimin
 * 2026/2/18 17:41
 */
public class DietLogResponse {
    private Long id;
    private Long productId;
    private BigDecimal caloriesKcal;
    private LocalDateTime eatenAt;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
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

    public LocalDateTime getEatenAt() {
        return eatenAt;
    }

    public void setEatenAt(LocalDateTime eatenAt) {
        this.eatenAt = eatenAt;
    }

    /**
     * Build response from DietLog entity.
     */
    public static DietLogResponse from(DietLog log) {
        if (log == null) return null;
        DietLogResponse r = new DietLogResponse();
        r.setId(log.getId());
        r.setProductId(log.getProductId());
        r.setCaloriesKcal(log.getCaloriesKcal());
        r.setEatenAt(log.getEatenAt());
        return r;
    }

    /**
     * Build response from Storage (e.g. when user clicks add storage to log).
     * id not set (auto-generated on insert). eatenAt = time of the add action (now).
     */

}
