package com.team6.pojo;

import java.util.Date;

/**
 * Entity for app_products table
 * @author zhimin
 * 2026/1/24 10:58
 */
public class Product {
    private Long productId;
    private String barcode;
    private String name;
    private String brand;
    private String imageUrl;
    /** Price in smallest unit (e.g. cents). 12.99 EUR → 1299 */
    private Long price;
    private String currency;
    /** Per 100g, scaled by 100. 5.25g → 525 */
    private Long energyKcal;
    private Long fat;
    private Long saturatedFat;
    private Long carbohydrates;
    private Long sugars;
    private Long fiber;
    private Long proteins;
    private Long salt;
    private String nutriScore;
    private String source;
    private String sourceUrl;
    private String productStatus;
    private Date lastFetchedAt;
    private Date createdAt;
    private Date updatedAt;

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

    public String getSource() {
        return source;
    }

    public void setSource(String source) {
        this.source = source;
    }

    public String getSourceUrl() {
        return sourceUrl;
    }

    public void setSourceUrl(String sourceUrl) {
        this.sourceUrl = sourceUrl;
    }

    public String getProductStatus() {
        return productStatus;
    }

    public void setProductStatus(String productStatus) {
        this.productStatus = productStatus;
    }

    public Date getLastFetchedAt() {
        return lastFetchedAt;
    }

    public void setLastFetchedAt(Date lastFetchedAt) {
        this.lastFetchedAt = lastFetchedAt;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public Date getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Date updatedAt) {
        this.updatedAt = updatedAt;
    }
}
