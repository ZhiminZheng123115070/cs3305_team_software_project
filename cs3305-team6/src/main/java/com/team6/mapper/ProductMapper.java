package com.team6.mapper;

import com.team6.pojo.Product;
import org.apache.ibatis.annotations.Mapper;

/**
 * Product Data Access Layer
 * @author zhimin
 * 2026/1/24 11:46
 */
@Mapper
public interface ProductMapper {
    
    /**
     * Query product by barcode
     * @param barcode Product barcode
     * @return Product information
     */
    Product getProductBarcode(String barcode);

    /**
     * Insert a product
     * @param product Product entity
     * @return rows affected
     */
    int addProduct(Product product);

    /**
     * Update nutrition fields for an existing product by product_id.
     */
    int updateProductNutrition(Product product);
}
