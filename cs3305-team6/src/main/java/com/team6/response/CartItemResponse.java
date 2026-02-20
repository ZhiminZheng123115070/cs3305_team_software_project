package com.team6.response;

import java.util.Date;

/**
 * @author zhimin
 * 2026/2/6 18:32
 */
public class CartItemResponse {
    private Long cartId;
    private Integer quantity;
    private Long productId;
    private String barcode;
    private String name;
    private String brand;
    private String imageUrl;
    private Long price;
    private String currency;
    private Long energyKcal;
    private Long fat;
    private Long saturatedFat;
    private Long carbohydrates;
    private Long sugars;
    private Long fiber;
    private Long proteins;
    private Long salt;
    private String nutriScore;
    private Date updatedAt;

    public Long getCartId() {
        return cartId;
    }

    public void setCartId(Long cartId) {
        this.cartId = cartId;
    }

    public Integer getQuantity() {
        return quantity;
    }

    public void setQuantity(Integer quantity) {
        this.quantity = quantity;
    }

    public Long getProductId() {
        return productId;
    }

    public void setProductId(Long productId) {
        this.productId = productId;
    }

    public String getBarcode() {
        return barcode;
    }

    public void setBarcode(String barcode) {
        this.barcode = barcode;
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

    public Long getPrice() {
        return price;
    }

    public void setPrice(Long price) {
        this.price = price;
    }

    public String getCurrency() {
        return currency;
    }

    public void setCurrency(String currency) {
        this.currency = currency;
    }

    public Long getEnergyKcal() {
        return energyKcal;
    }

    public void setEnergyKcal(Long energyKcal) {
        this.energyKcal = energyKcal;
    }

    public Long getFat() {
        return fat;
    }

    public void setFat(Long fat) {
        this.fat = fat;
    }

    public Long getSaturatedFat() {
        return saturatedFat;
    }

    public void setSaturatedFat(Long saturatedFat) {
        this.saturatedFat = saturatedFat;
    }

    public Long getCarbohydrates() {
        return carbohydrates;
    }

    public void setCarbohydrates(Long carbohydrates) {
        this.carbohydrates = carbohydrates;
    }

    public Long getSugars() {
        return sugars;
    }

    public void setSugars(Long sugars) {
        this.sugars = sugars;
    }

    public Long getFiber() {
        return fiber;
    }

    public void setFiber(Long fiber) {
        this.fiber = fiber;
    }

    public Long getProteins() {
        return proteins;
    }

    public void setProteins(Long proteins) {
        this.proteins = proteins;
    }

    public Long getSalt() {
        return salt;
    }

    public void setSalt(Long salt) {
        this.salt = salt;
    }

    public String getNutriScore() {
        return nutriScore;
    }

    public void setNutriScore(String nutriScore) {
        this.nutriScore = nutriScore;
    }

    public Date getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Date updatedAt) {
        this.updatedAt = updatedAt;
    }
}
