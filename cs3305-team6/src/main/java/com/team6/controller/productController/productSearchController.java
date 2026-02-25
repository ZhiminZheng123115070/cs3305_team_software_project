package com.team6.controller.productController;

import com.ruoyi.common.annotation.Anonymous;
import com.ruoyi.common.core.domain.AjaxResult;
import com.team6.pojo.Product;
import com.team6.request.AddProductRequest;
import com.team6.request.ProductSearchRequest;
import com.team6.response.ProductSearchResponse;
import com.team6.service.productService.IProductService;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

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

    /**
     * Ensure product exists: return existing by barcode, or create from body (e.g. OFF data from app).
     * Used when adding scanned/OFF product to cart so it is cached in DB first.
     */
    @PostMapping()
    public AjaxResult ensureProduct(@RequestBody AddProductRequest request) {
        if (request == null || request.getBarcode() == null || request.getBarcode().trim().isEmpty()) {
            return AjaxResult.error("Barcode is required");
        }
        Product product = productService.ensureProduct(request);
        ProductSearchResponse response = new ProductSearchResponse();
        BeanUtils.copyProperties(product, response);
        return AjaxResult.success(response);
    }
}
