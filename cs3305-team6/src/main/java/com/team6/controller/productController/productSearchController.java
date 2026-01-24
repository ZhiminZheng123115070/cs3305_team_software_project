package com.team6.controller.productController;

import com.ruoyi.common.annotation.Anonymous;
import com.ruoyi.common.core.domain.AjaxResult;
import com.team6.pojo.Product;
import com.team6.response.ProductSearchResponse;
import com.team6.service.productService.IProductService;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

/**
 * Product Search Controller
 * @author zhimin
 * 2026/1/24 11:03
 */
@Anonymous
@RestController
@RequestMapping("/user/product")
public class productSearchController {

    @Autowired
    private IProductService productService;

    /**
     * Query product by barcode (Read-only operation)
     * @param barcode Product barcode
     * @return Product information
     */
    @GetMapping("/search/barcode")
    public AjaxResult getProductByBarcode(@RequestParam String barcode){
        // Call Service layer to query product
        Product product = productService.getProductByBarcode(barcode);
        
        if (product != null) {
            // Convert Product entity to ProductSearchResponse
            ProductSearchResponse response = new ProductSearchResponse();
            BeanUtils.copyProperties(product, response);
            return AjaxResult.success(response);
        } else {
            return AjaxResult.error("Product not found for the given barcode");
        }
    }
}
