package com.team6.service.productService.impl;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.github.pagehelper.PageHelper;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.common.utils.StringUtils;
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
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.math.BigDecimal;
import java.net.Proxy;
import java.net.URL;
import java.net.URLConnection;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
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

    @Value("${app.open-food-facts.base-url:https://world.openfoodfacts.org}")
    private String openFoodFactsBaseUrl;

    @Autowired
    private ProductMapper productMapper;

    @Autowired
    private CartMapper cartMapper;

    @Autowired
    private OrderMapper orderMapper;

    @Autowired
    private StorageMapper storageMapper;

    @Autowired
    private ObjectMapper objectMapper;

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
        return getProductByBarcodeForScanning(barcode);
    }

    @Override
    public Product getProductByBarcodeForScanning(String barcode) {
        Product local = safeGetLocal(barcode);
        if (local != null) {
            return local;
        }

        Product offProduct = fetchFromOpenFoodFacts(barcode);
        if (offProduct == null) {
            return null;
        }

        try {
            productMapper.insertProduct(offProduct);
            Product inserted = safeGetLocal(barcode);
            return inserted != null ? inserted : offProduct;
        } catch (Exception e) {
            Product existing = safeGetLocal(barcode);
            return existing != null ? existing : offProduct;
        }
    }

    private Product safeGetLocal(String barcode) {
        try {
            return productMapper.getProductBarcode(barcode);
        } catch (Exception e) {
            return null;
        }
    }

    private Product fetchFromOpenFoodFacts(String barcode) {
        try {
            String encodedBarcode = URLEncoder.encode(barcode, StandardCharsets.UTF_8.name());
            String url = openFoodFactsBaseUrl + "/api/v0/product/" + encodedBarcode + ".json";
            String body = fetchOffJsonWithoutProxy(url);

            if (StringUtils.isBlank(body)) {
                return null;
            }

            JsonNode root = objectMapper.readTree(body);
            if (root.path("status").asInt(0) != 1) {
                return null;
            }

            JsonNode productNode = root.path("product");
            if (productNode.isMissingNode() || productNode.isNull()) {
                return null;
            }

            Product p = new Product();
            p.setBarcode(barcode);
            p.setName(firstNonBlank(productNode.path("product_name").asText(null), "Unknown Product"));
            p.setBrand(productNode.path("brands").asText(null));
            p.setImageUrl(productNode.path("image_front_url").asText(productNode.path("image_url").asText(null)));
            p.setCurrency("EUR");
            String nutriScore = productNode.path("nutriscore_grade").asText(null);
            p.setNutriScore(StringUtils.isNotBlank(nutriScore) ? nutriScore.toUpperCase() : null);
            p.setSource("OFF");
            p.setSourceUrl(productNode.path("url").asText(null));
            p.setProductStatus("FOUND");
            p.setLastFetchedAt(new Date());
            return p;
        } catch (Exception e) {
            return null;
        }
    }

    private String fetchOffJsonWithoutProxy(String url) {
        StringBuilder result = new StringBuilder();
        try {
            URL realUrl = new URL(url);
            URLConnection connection = realUrl.openConnection(Proxy.NO_PROXY);
            connection.setRequestProperty("accept", "application/json");
            connection.setRequestProperty("connection", "Keep-Alive");
            connection.setRequestProperty("user-agent", "Mozilla/5.0");
            connection.setConnectTimeout(8000);
            connection.setReadTimeout(8000);

            try (BufferedReader in = new BufferedReader(
                    new InputStreamReader(connection.getInputStream(), StandardCharsets.UTF_8))) {
                String line;
                while ((line = in.readLine()) != null) {
                    result.append(line);
                }
            }
        } catch (Exception e) {
            return "";
        }
        return result.toString();
    }

    private String firstNonBlank(String value, String fallback) {
        return StringUtils.isNotBlank(value) ? value : fallback;
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
