package com.team6.mapper;


import com.team6.pojo.Order;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface OrderMapper {
    /** Insert order line; on duplicate (user_id, product_id) update quantity. */
    int addOrder(Order order);

    /** Get order list by user id, ordered by created_at desc. */
    List<Order> getOrderList(@Param("userId") Long userId);

}
