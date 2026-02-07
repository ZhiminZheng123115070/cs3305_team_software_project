package com.team6.service.productService.impl;

import com.github.pagehelper.PageHelper;
import com.ruoyi.common.utils.SecurityUtils;
import com.team6.mapper.CartMapper;
import com.team6.mapper.ProductMapper;
import com.team6.pojo.Cart;
import com.team6.pojo.Product;
import com.team6.request.CartListRequest;
import com.team6.request.CartRequest;
import com.team6.request.ProductSearchRequest;
import com.team6.request.SortItem;
import com.team6.response.CartItemResponse;
import com.team6.response.ProductSearchResponse;
import com.team6.service.productService.IProductService;
import org.apache.catalina.security.SecurityUtil;
import org.checkerframework.checker.units.qual.C;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * Product Service Implementation
 * @author zhimin
 * 2026/1/24 11:24
 */
@Service
public class ProductService implements IProductService {

    @Autowired
    private ProductMapper productMapper;

    @Autowired
    private CartMapper cartMapper;

    private static final Map<String, String> SORT_FIELD_WHITELIST=new LinkedHashMap<>();
    static {
        SORT_FIELD_WHITELIST.put("price","p.price");
        SORT_FIELD_WHITELIST.put("brand","p.brand");
        SORT_FIELD_WHITELIST.put("kcal","p.energy_kcal");
        SORT_FIELD_WHITELIST.put("fat","p.fat");
        SORT_FIELD_WHITELIST.put("sugars","p.sugars");
        SORT_FIELD_WHITELIST.put("fiber","p.fiber");
        SORT_FIELD_WHITELIST.put("proteins","p.proteins");
        SORT_FIELD_WHITELIST.put("carbohydrates","p.carbohydrates");
        SORT_FIELD_WHITELIST.put("salt","p.salt");
        SORT_FIELD_WHITELIST.put("nutriScore","p.nutri_score");
        SORT_FIELD_WHITELIST.put("cartId","c.cart_id");
        SORT_FIELD_WHITELIST.put("updatedAt","c.updated_at");
    }


    public String buildOrderBy(CartListRequest request){
        List<SortItem> sorts=request.getSorts();

        if(sorts==null || sorts.isEmpty()){
            return "c.cart_id desc";
        }
        String orderBy=sorts.stream()
                .filter(s -> s.getField() !=null && SORT_FIELD_WHITELIST.containsKey(s.getField()))
                .map(s ->{
                    String col = SORT_FIELD_WHITELIST.get(s.getField());
                    String dir ="desc".equalsIgnoreCase(s.getOrder())?"desc":"asc";
                    return col +" "+dir;
                })
                .collect(Collectors.joining(", "));
        return orderBy.isEmpty() ? "c.cart_id desc" : orderBy;
    }

    /**
     * Query product by barcode
     * @param barcode Product barcode
     * @return Product information
     */
    @Override
    public Product getProductByBarcode(String barcode){
        return productMapper.getProductBarcode(barcode);
    }

    @Override
    public int addCart(Long productId, Integer quantity){
        Cart request = new Cart();
        request.setProductId(productId);
        request.setQuantity(quantity);
        request.setUserId(SecurityUtils.getUserId());

        return cartMapper.addCart(request);
    }

    @Override
    public int updateCart(Long cartId, Integer quantity){
        Cart request = new Cart();
        request.setCartId(cartId);
        request.setQuantity(quantity);
        request.setUserId(SecurityUtils.getUserId());

        return cartMapper.updateCart(request);
    }

    @Override
    public int deleteCart(Long cartId){
        Cart request = new Cart();
        request.setCartId(cartId);
        request.setUserId(SecurityUtils.getUserId());
        return cartMapper.deleteCart(request);
    }

    @Override
    public List<CartItemResponse> getCartPageList(CartListRequest request){
        Long userId=SecurityUtils.getUserId();
        String orderBy=buildOrderBy(request);
        PageHelper.startPage(request.getPageNum(),request.getPageSize());
        return cartMapper.getCartList(userId,orderBy);
    }
}
