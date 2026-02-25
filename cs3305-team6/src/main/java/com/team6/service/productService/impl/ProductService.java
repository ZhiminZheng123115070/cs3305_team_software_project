package com.team6.service.productService.impl;

import com.github.pagehelper.PageHelper;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.SecurityUtils;
import com.team6.mapper.CartMapper;
import com.team6.mapper.OrderMapper;
import com.team6.mapper.ProductMapper;
import com.team6.mapper.StorageMapper;
import com.team6.pojo.Cart;
import com.team6.pojo.Order;
import com.team6.pojo.Product;
import com.team6.pojo.Storage;
import com.team6.request.*;
import com.team6.response.CartItemResponse;
import com.team6.response.OrderResponse;
import com.team6.response.ProductSearchResponse;
import com.team6.response.StorageResponse;
import com.team6.service.productService.IProductService;
import org.apache.catalina.security.SecurityUtil;
import org.apache.ibatis.annotations.Param;
import org.checkerframework.checker.units.qual.C;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.Date;
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

    @Autowired
    private OrderMapper orderMapper;

    @Autowired
    private StorageMapper storageMapper;

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

    /**
     * Scanner flow: lookup by barcode (from DB). Returns null if not found.
     * Can be extended later with OFF API fallback and cache insert.
     */
    @Override
    public Product getProductByBarcodeForScanning(String barcode) {
        return productMapper.getProductBarcode(barcode);
    }

    @Override
    public Product addProduct(Product product) {
        if (product.getBarcode() == null || product.getBarcode().trim().isEmpty()) {
            throw new ServiceException("Product barcode cannot be empty");
        }
        Product existing = productMapper.getProductBarcode(product.getBarcode().trim());
        if (existing != null) {
            throw new ServiceException("Product with barcode already exists: " + product.getBarcode());
        }
        Date now = new Date();
        if (product.getCreatedAt() == null) {
            product.setCreatedAt(now);
        }
        if (product.getUpdatedAt() == null) {
            product.setUpdatedAt(now);
        }
        if (product.getLastFetchedAt() == null) {
            product.setLastFetchedAt(now);
        }
        // Defensive: DB column nutri_score is short (A-E). Normalize before insert.
        product.setNutriScore(normalizeNutriScore(product.getNutriScore()));
        productMapper.addProduct(product);
        return productMapper.getProductBarcode(product.getBarcode());
    }

    /** Nutri-Score is one letter A-E; DB column is short. Normalize or null. */
    private static String normalizeNutriScore(String s) {
        if (s == null || s.trim().isEmpty()) return null;
        String c = s.trim().toUpperCase().substring(0, 1);
        return "A".equals(c) || "B".equals(c) || "C".equals(c) || "D".equals(c) || "E".equals(c) ? c : null;
    }

    /**
     * Ensure product exists: return existing by barcode, or create from request (e.g. OFF data from app).
     */
    @Override
    public Product ensureProduct(AddProductRequest request) {
        if (request == null || request.getBarcode() == null || request.getBarcode().trim().isEmpty()) {
            throw new ServiceException("Product barcode cannot be empty");
        }
        Product existing = productMapper.getProductBarcode(request.getBarcode().trim());
        if (existing != null) {
            // If request has nutrition and existing has none, update from OFF
            boolean hasRequestNutrition = request.getEnergyKcal() != null || request.getFat() != null
                || request.getProteins() != null || request.getCarbohydrates() != null
                || request.getSugars() != null || request.getFiber() != null || request.getSalt() != null;
            boolean existingMissingNutrition = existing.getEnergyKcal() == null && existing.getFat() == null
                && existing.getProteins() == null && existing.getCarbohydrates() == null;
            if (hasRequestNutrition && existingMissingNutrition) {
                existing.setEnergyKcal(request.getEnergyKcal() != null ? request.getEnergyKcal() : BigDecimal.ZERO);
                existing.setFat(request.getFat() != null ? request.getFat() : BigDecimal.ZERO);
                existing.setSaturatedFat(request.getSaturatedFat() != null ? request.getSaturatedFat() : BigDecimal.ZERO);
                existing.setCarbohydrates(request.getCarbohydrates() != null ? request.getCarbohydrates() : BigDecimal.ZERO);
                existing.setSugars(request.getSugars() != null ? request.getSugars() : BigDecimal.ZERO);
                existing.setFiber(request.getFiber() != null ? request.getFiber() : BigDecimal.ZERO);
                existing.setProteins(request.getProteins() != null ? request.getProteins() : BigDecimal.ZERO);
                existing.setSalt(request.getSalt() != null ? request.getSalt() : BigDecimal.ZERO);
                Date now = new Date();
                existing.setLastFetchedAt(now);
                existing.setUpdatedAt(now);
                productMapper.updateProductNutrition(existing);
                return productMapper.getProductBarcode(request.getBarcode().trim());
            }
            return existing;
        }
        Product product = new Product();
        product.setBarcode(request.getBarcode().trim());
        product.setName(request.getName() != null ? request.getName().trim() : "Unknown");
        product.setBrand(request.getBrand());
        product.setImageUrl(request.getImageUrl());
        product.setPrice(request.getPrice() != null ? request.getPrice() : BigDecimal.ZERO);
        String currency = request.getCurrency();
        product.setCurrency(currency != null && !currency.trim().isEmpty() ? currency.trim() : "EUR");
        product.setEnergyKcal(request.getEnergyKcal() != null ? request.getEnergyKcal() : BigDecimal.ZERO);
        product.setFat(request.getFat() != null ? request.getFat() : BigDecimal.ZERO);
        product.setSaturatedFat(request.getSaturatedFat() != null ? request.getSaturatedFat() : BigDecimal.ZERO);
        product.setCarbohydrates(request.getCarbohydrates() != null ? request.getCarbohydrates() : BigDecimal.ZERO);
        product.setSugars(request.getSugars() != null ? request.getSugars() : BigDecimal.ZERO);
        product.setFiber(request.getFiber() != null ? request.getFiber() : BigDecimal.ZERO);
        product.setProteins(request.getProteins() != null ? request.getProteins() : BigDecimal.ZERO);
        product.setSalt(request.getSalt() != null ? request.getSalt() : BigDecimal.ZERO);
        product.setNutriScore(normalizeNutriScore(request.getNutriScore()));
        String source = request.getSource();
        product.setSource(source != null && !source.trim().isEmpty() ? source.trim() : "open_food_facts");
        String sourceUrl = request.getSourceUrl();
        product.setSourceUrl(sourceUrl != null ? sourceUrl : "");
        String status = request.getProductStatus();
        product.setProductStatus(status != null && !status.trim().isEmpty() ? status.trim() : "active");
        return addProduct(product);
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

    @Override
    public CartItemResponse getCartItemByCartId(Long cartId){
        Long userId = SecurityUtils.getUserId();
        return cartMapper.getCartItemByCartId(userId, cartId);
    }


    @Override
    public int addOrder(Long cartId) {
        Long userId = SecurityUtils.getUserId();
        CartItemResponse cart = cartMapper.getCartItemByCartId(userId, cartId);
        if (cart == null) {
            return 0;
        }
        int quantity = cart.getQuantity();
        BigDecimal qty = BigDecimal.valueOf(quantity);
        if (cart.getEnergyKcal() != null) cart.setEnergyKcal(cart.getEnergyKcal().multiply(qty));
        if (cart.getFat() != null) cart.setFat(cart.getFat().multiply(qty));
        if (cart.getSaturatedFat() != null) cart.setSaturatedFat(cart.getSaturatedFat().multiply(qty));
        if (cart.getCarbohydrates() != null) cart.setCarbohydrates(cart.getCarbohydrates().multiply(qty));
        if (cart.getSugars() != null) cart.setSugars(cart.getSugars().multiply(qty));
        if (cart.getFiber() != null) cart.setFiber(cart.getFiber().multiply(qty));
        if (cart.getProteins() != null) cart.setProteins(cart.getProteins().multiply(qty));
        if (cart.getSalt() != null) cart.setSalt(cart.getSalt().multiply(qty));

        Order order = Order.fromCartItem(cart, userId);
        Storage storage=Storage.fromCartItem(cart, userId);
        storageMapper.addStorage(storage);
        return orderMapper.addOrder(order);
    }

    @Override
    public List<OrderResponse> getOrdersByUserId(){
        Long userId = SecurityUtils.getUserId();

        List<Order> orders = orderMapper.findOrdersbyUserId(userId);
        return orders.stream()
                .map(OrderResponse::from)
                .collect(java.util.stream.Collectors.toList());
    }

    @Override
    public int updateStorage(Long storageId, BigDecimal consumptionRate){
        StorageResponse storage= storageMapper.findStorageById(storageId);

        if(storage==null){
            throw new RuntimeException("Storage didn't existed");
        }



        BigDecimal consumption=storage.getConsumption();
        consumption=consumption.subtract(consumptionRate);
        if(consumption !=null && consumption.compareTo(BigDecimal.ZERO)<0){
            throw new RuntimeException("Insufficient stock in storage");
        }

        if(consumption !=null && consumption.compareTo(BigDecimal.ZERO)==0){
            storageMapper.deleteStorage(storage.getStorageId(),storage.getUserId());
            return 1;
        }

        Storage request=new Storage();
        request.setStorageId(storage.getStorageId());
        request.setUserId(storage.getUserId());

        request.setConsumption(consumption);
        return storageMapper.updateStorage(request);
    }

    @Override
    public StorageResponse findStorageById(Long storageId){
        return storageMapper.findStorageById(storageId);
    }

    @Override
    public List<StorageResponse> findStoragesPageList(StorageListRequest request){
        Long userId = SecurityUtils.getUserId();
        PageHelper.startPage(request.getPageNum(), request.getPageSize());
        return storageMapper.findStoragesByUserId(userId);
    }


    @Override
    public int deleteStorage(Long storageId){
        Long userId=SecurityUtils.getUserId();
        return storageMapper.deleteStorage(storageId,userId);
    }

}