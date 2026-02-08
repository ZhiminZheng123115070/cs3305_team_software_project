package com.team6.mapper;

import com.team6.pojo.Cart;
import com.team6.request.CartRequest;
import com.team6.response.CartItemResponse;
import com.team6.response.ProductSearchResponse;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * @author zhimin
 * 2026/2/6 12:56
 */

@Mapper
public interface CartMapper {

    int addCart(Cart request);

    int updateCart(Cart request);

    int deleteCart(Cart request);

    List<CartItemResponse> getCartList(@Param("userId") Long userId, @Param("orderBy") String orderBy);

    CartItemResponse getCartItemByCartId(@Param("userId") Long userId, @Param("cartId") Long cartId);
}
