package com.team6.controller.productController;

import com.ruoyi.common.core.domain.AjaxResult;
import com.team6.request.StorageListRequest;
import com.team6.service.productService.IProductService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;

/**
 * @author zhimin
 * 2026/2/8 18:34
 */

@RestController
@RequestMapping("/user/product/storage")
public class ProductStorageController {
    @Autowired
    private IProductService productService;

    @PutMapping()
    public AjaxResult updateStorage(@RequestParam("storage_id") Long storageId, @RequestParam("consumption_rate") BigDecimal consumptionRate){
        if(productService.updateStorage(storageId, consumptionRate)>=0){
            return AjaxResult.success("Update product in Cart successfully");
        }
        return AjaxResult.error("update your storage failure");
    }


    @GetMapping()
    public AjaxResult findStorageById(@RequestParam("storage_id") Long storageId){
        return AjaxResult.success(productService.findStorageById(storageId));
    }

    @GetMapping("list")
    public AjaxResult findStoragePageList(@Validated StorageListRequest request){
        return AjaxResult.success(productService.findStoragesPageList(request));
    }

    @DeleteMapping()
    public AjaxResult deleteStorage(@RequestParam("storage_id") Long storageId){
        return AjaxResult.success(productService.deleteStorage(storageId));
    }


}
