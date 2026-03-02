package com.team6.controller.productController;

import com.ruoyi.common.annotation.Anonymous;
import com.ruoyi.common.core.domain.AjaxResult;
import com.team6.response.AddOrderResult;
import com.team6.service.productService.IProductService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

/**
 * @author zhimin
 * 2026/2/8 15:20
 */
@Anonymous
@RestController
@RequestMapping("/user/product/order")
public class productOrderController {
    @Autowired
    private IProductService productService;

    @PostMapping()
    public AjaxResult addOrder(@RequestParam("cart_id") Long cartId){
        AddOrderResult result = productService.addOrder(cartId);
        if (result.isOrderAdded()) {
            return AjaxResult.success("Add cart in order successfully", result);
        }
        return AjaxResult.error("Update cart in order failure");
    }


    @DeleteMapping()
    public AjaxResult deleteOrder(@RequestParam("order_id")Long orderId){
        if(productService.deleteCart(orderId)>0){
            return AjaxResult.success("Delete product in Order successfully");
        }
        return AjaxResult.error("Delete product in Order failure");
    }

    @GetMapping()
    public AjaxResult getOrdersByUserId(){
        return AjaxResult.success(productService.getOrdersByUserId());
    }




}
