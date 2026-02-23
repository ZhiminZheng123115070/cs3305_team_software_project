package com.team6.controller.productController;

import com.ruoyi.common.annotation.Anonymous;
import com.ruoyi.common.core.domain.AjaxResult;
import com.team6.pojo.Product;
import com.team6.request.CartListRequest;
import com.team6.response.CartItemResponse;
import com.team6.service.productService.IProductService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

/**
 * @author zhimin
 * 2026/2/6 16:13
 */
@Anonymous
@RestController
@RequestMapping("/user/product/cart")
public class productCartController {
    @Autowired
    private IProductService productService;



    @PostMapping()
    public AjaxResult addCart(@RequestParam("product_id") Long productId, @RequestParam(defaultValue = "1") Integer quantity){

        if(productService.addCart(productId, quantity) > 0){
            return AjaxResult.success("Add product in Cart successfully");
        }
        return AjaxResult.error("Update product in Cart failure");
    }

    /**
     * Resolve/cache by barcode via scanning flow, then add to cart.
     */
    @PostMapping("/barcode")
    public AjaxResult addCartByBarcode(@RequestParam("barcode") String barcode,
                                       @RequestParam(defaultValue = "1") Integer quantity){
        Product p = productService.getProductByBarcodeForScanning(barcode);
        if (p == null || p.getProductId() == null || p.getProductId() <= 0) {
            return AjaxResult.error("Product not cached in DB yet");
        }

        if(productService.addCart(p.getProductId(), quantity) > 0){
            return AjaxResult.success("Add product in Cart successfully", p);
        }
        return AjaxResult.error("Add product in Cart failure");
    }

    @PutMapping()
    public AjaxResult updateCart(@RequestParam("cart_id") Long cartId, @RequestParam Integer quantity){
        if(productService.updateCart(cartId, quantity)>=0){
            return AjaxResult.success("Update product in Cart successfully");
        }
        return AjaxResult.error("Update product in Cart failure");
    }

    @DeleteMapping("/")
    public AjaxResult deleteCart(@RequestParam("cart_id") Long cartId){
        if(productService.deleteCart(cartId)>0){
            return AjaxResult.success("Delete product in Cart successfully");
        }
        return AjaxResult.error("Delete product in Cart failure");
    }

    @GetMapping("/list")
    public AjaxResult getList(@Validated CartListRequest request){
        return AjaxResult.success(productService.getCartPageList(request));
    }

    @GetMapping("/detail")
    public AjaxResult getDetail(@RequestParam("cart_id") Long cartId){
        CartItemResponse item = productService.getCartItemByCartId(cartId);
        if (item == null) {
            return AjaxResult.error("Cart item not found or not yours");
        }
        return AjaxResult.success(item);
    }
}
