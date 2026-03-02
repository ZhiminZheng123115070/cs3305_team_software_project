package com.team6.service.productService;

import com.team6.pojo.Cart;
import com.team6.pojo.Order;
import com.team6.pojo.Product;
import com.team6.pojo.Storage;
import com.team6.request.AddProductRequest;
import com.team6.request.CartListRequest;
import com.team6.request.ProductSearchRequest;
import com.team6.request.StorageListRequest;
import com.team6.response.AddOrderResult;
import com.team6.response.CartItemResponse;
import com.team6.response.OrderResponse;
import com.team6.response.ProductSearchResponse;
import com.team6.response.StorageResponse;

import java.math.BigDecimal;
import java.util.List;

/**
 * Product Service Interface
 * @author zhimin
 * 2026/1/24 11:23
 */
public interface IProductService {
    /**
     * Query product by barcode
     * @param barcode Product barcode
     * @return Product information
     */
    public Product getProductByBarcode(String barcode);

    public Product addProduct(Product product);

    /**
     * Ensure product exists: return existing by barcode, or create from request (e.g. OFF data).
     */
    Product ensureProduct(AddProductRequest request);

    /**
     * Ensure product exists by barcode only; creates minimal "Unknown" product if not found.
     * Use when adding to cart by barcode and product may not be in DB yet.
     */
    Product ensureProductByBarcodeOnly(String barcode);

    /**
     * Scanner flow lookup with OFF fallback and cache insert.
     */
    public Product getProductByBarcodeForScanning(String barcode);


    public int addCart(Long productId, Integer quantity);

    public int updateCart(Long cartId, Integer quantity);

    public int deleteCart(Long cartId);

    public List<CartItemResponse> getCartPageList(CartListRequest request);

    /**
     * Get one cart item by cart_id (must belong to current user).
     * @param cartId cart_id
     * @return CartItemResponse or null if not found
     */
    CartItemResponse getCartItemByCartId(Long cartId);



    public AddOrderResult addOrder(Long cartId);


    public List<OrderResponse> getOrdersByUserId();



    public int updateStorage(Long storageId, BigDecimal consumptionRate);

    public StorageResponse findStorageById(Long storageId);

    public List<StorageResponse> findStoragesPageList(StorageListRequest request);

    public int deleteStorage(Long storageId);





}
