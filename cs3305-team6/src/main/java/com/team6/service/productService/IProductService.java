package com.team6.service.productService;

import com.team6.pojo.Product;

/**
 * Product Service Interface
 * @author zhimin
 * 2026/1/24 11:23
 */
public interface IProductService {
    /**
     * Query product by barcode
     * @param barcode Product barcode
     * @return Product information
     */
    public Product getProductByBarcode(String barcode);
}
