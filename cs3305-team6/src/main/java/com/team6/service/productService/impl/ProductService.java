package com.team6.service.productService.impl;

import com.team6.mapper.ProductMapper;
import com.team6.pojo.Product;
import com.team6.service.productService.IProductService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * Product Service Implementation
 * @author zhimin
 * 2026/1/24 11:24
 */
@Service
public class ProductService implements IProductService {
    @Autowired
    private ProductMapper productMapper;

    /**
     * Query product by barcode
     * @param barcode Product barcode
     * @return Product information
     */
    @Override
    public Product getProductByBarcode(String barcode){
        return productMapper.getProductBarcode(barcode);
    }
}
