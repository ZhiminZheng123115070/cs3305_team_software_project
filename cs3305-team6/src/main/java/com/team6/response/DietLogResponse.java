package com.team6.response;

import com.team6.pojo.DietLog;

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
    private String imageUrl;
    private String name;
    private BigDecimal energyKcal;
    private BigDecimal proteins;
    private BigDecimal consumptionRate;
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

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public BigDecimal getEnergyKcal() {
        return energyKcal;
    }

    public void setEnergyKcal(BigDecimal energyKcal) {
        this.energyKcal = energyKcal;
    }

    public BigDecimal getProteins() {
        return proteins;
    }

    public void setProteins(BigDecimal proteins) {
        this.proteins = proteins;
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

    public static DietLogResponse from(DietLog log) {
        if (log == null) return null;
        DietLogResponse r = new DietLogResponse();
        r.setId(log.getId());
        r.setProductId(log.getProductId());
        r.setConsumptionRate(log.getConsumptionRate());
        r.setEatenAt(log.getEatenAt());
        return r;
    }
}
