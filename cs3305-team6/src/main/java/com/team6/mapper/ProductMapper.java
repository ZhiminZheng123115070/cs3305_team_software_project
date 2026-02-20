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
     * Insert product cache from OFF fallback.
     * @param product product payload
     * @return affected rows
     */
    int insertProduct(Product product);
}
