package com.team6.pojo;

import com.team6.response.CartItemResponse;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * @author zhimin
 * 2026/2/8 16:22
 */
public class Order {
    private Long orderId;
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

    /**
     * Build Order from cart item and userId; lineTotal = unitPrice * quantity.
     * If price is null (e.g. unknown product), use zero so DB unit_price/line_total are never null.
     * Null-safe name/brand/currency for DB NOT NULL columns when product/cart data is missing.
     */
    public static Order fromCartItem(CartItemResponse cart, Long userId) {
        Order order = new Order();
        order.setUserId(userId);
        order.setProductId(cart.getProductId());
        order.setName(cart.getName() != null && !cart.getName().trim().isEmpty() ? cart.getName().trim() : "Unknown");
        order.setBrand(cart.getBrand() != null ? cart.getBrand().trim() : "");
        order.setImageUrl(cart.getImageUrl());
        order.setQuantity(cart.getQuantity());
        BigDecimal price = cart.getPrice() != null ? cart.getPrice() : BigDecimal.ZERO;
        order.setUnitPrice(price);
        order.setLineTotal(cart.getQuantity() != null
                ? price.multiply(BigDecimal.valueOf(cart.getQuantity()))
                : BigDecimal.ZERO);
        order.setCurrency(cart.getCurrency() != null && !cart.getCurrency().trim().isEmpty() ? cart.getCurrency().trim() : "EUR");
        order.setEnergyKcal(cart.getEnergyKcal());
        order.setFat(cart.getFat());
        order.setSaturatedFat(cart.getSaturatedFat());
        order.setCarbohydrates(cart.getCarbohydrates());
        order.setSugars(cart.getSugars());
        order.setFiber(cart.getFiber());
        order.setProteins(cart.getProteins());
        order.setSalt(cart.getSalt());
        order.setCreatedAt(LocalDateTime.now());
        return order;
    }

    public Long getOrderId() {
        return orderId;
    }

    public void setOrderId(Long orderId) {
        this.orderId = orderId;
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
}
