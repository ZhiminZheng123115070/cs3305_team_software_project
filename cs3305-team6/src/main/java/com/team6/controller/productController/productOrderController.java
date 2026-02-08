package com.team6.controller.productController;

import com.ruoyi.common.annotation.Anonymous;
import com.ruoyi.common.core.domain.AjaxResult;
import com.team6.service.productService.IProductService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

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
        if(productService.addOrder(cartId) > 0){
            return AjaxResult.success("Add cart in order successfully");
        }
        return AjaxResult.error("Update cart in order failure");
    }

    @GetMapping("/list")
    public AjaxResult getList(){
        return AjaxResult.success(productService.getOrderList());
    }

}
