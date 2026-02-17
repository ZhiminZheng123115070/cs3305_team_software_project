package com.team6.pojo;

import com.team6.response.CartItemResponse;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * @author zhimin
 * 2026/2/8 18:35
 */
public class Storage {
    private Long storageId;
    private Long userId;
    private Long productId;

    private String name;
    private String brand;
    private String imageUrl;
    private Integer quantity;
    private BigDecimal unitPrice;
    private BigDecimal lineTotal;
    private String currency;

    private BigDecimal energyKcal;
    private BigDecimal fat;
    private BigDecimal saturatedFat;
    private BigDecimal carbohydrates;
    private BigDecimal sugars;
    private BigDecimal fiber;
    private BigDecimal proteins;
    private BigDecimal salt;

    private LocalDateTime createdAt;

    private BigDecimal consumption;


    public static Storage fromCartItem(CartItemResponse cart, Long userId) {
        Storage storage=new Storage();
        storage.setUserId(userId);
        storage.setProductId(cart.getProductId());
        storage.setName(cart.getName());
        storage.setBrand(cart.getBrand());
        storage.setImageUrl(cart.getImageUrl());
        storage.setQuantity(cart.getQuantity());
        storage.setUnitPrice(cart.getPrice());
        storage.setLineTotal(cart.getPrice() != null && cart.getQuantity() != null
           ? cart.getPrice().multiply(BigDecimal.valueOf(cart.getQuantity()))
           : null);
        storage.setCurrency(cart.getCurrency());
        storage.setEnergyKcal(cart.getEnergyKcal());
        storage.setFat(cart.getFat());
        storage.setSaturatedFat(cart.getSaturatedFat());
        storage.setCarbohydrates(cart.getCarbohydrates());
        storage.setSugars(cart.getSugars());
        storage.setFiber(cart.getFiber());
        storage.setProteins(cart.getProteins());
        storage.setSalt(cart.getSalt());
        storage.setCreatedAt(LocalDateTime.now());
        storage.setConsumption(BigDecimal.ONE); // Default consumption = 1
        return storage;
    }


    public Long getStorageId() {
        return storageId;
    }

    public void setStorageId(Long storageId) {
        this.storageId = storageId;
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

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getBrand() {
        return brand;
    }

    public void setBrand(String brand) {
        this.brand = brand;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public Integer getQuantity() {
        return quantity;
    }

    public void setQuantity(Integer quantity) {
        this.quantity = quantity;
    }

    public BigDecimal getUnitPrice() {
        return unitPrice;
    }

    public void setUnitPrice(BigDecimal unitPrice) {
        this.unitPrice = unitPrice;
    }

    public BigDecimal getLineTotal() {
        return lineTotal;
    }

    public void setLineTotal(BigDecimal lineTotal) {
        this.lineTotal = lineTotal;
    }

    public String getCurrency() {
        return currency;
    }

    public void setCurrency(String currency) {
        this.currency = currency;
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

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public BigDecimal getConsumption() {
        return consumption;
    }

    public void setConsumption(BigDecimal consumption) {
        this.consumption = consumption;
    }
}
