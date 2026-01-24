package com.team6.request;

/**
 * Product Search Request
 * Only used for query operations
 * @author zhimin
 * 2026/1/24 11:39
 */
public class ProductSearchRequest {
    /**
     * Product barcode for search
     */
    private String barcode;

    public String getBarcode() {
        return barcode;
    }

    public void setBarcode(String barcode) {
        this.barcode = barcode;
    }
}
