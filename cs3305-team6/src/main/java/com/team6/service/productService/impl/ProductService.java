package com.team6.service.productService.impl;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.github.pagehelper.PageHelper;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.common.utils.StringUtils;
import com.team6.mapper.CartMapper;
import com.team6.mapper.ProductMapper;
import com.team6.pojo.Cart;
import com.team6.pojo.Product;
import com.team6.request.CartListRequest;
import com.team6.request.SortItem;
import com.team6.response.CartItemResponse;
import com.team6.service.productService.IProductService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.io.BufferedReader;
import java.io.InputStreamReader;
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

    private static final Logger log = LoggerFactory.getLogger(ProductService.class);

    @Value("${app.open-food-facts.base-url:https://world.openfoodfacts.org}")
    private String openFoodFactsBaseUrl;

    @Autowired
    private ProductMapper productMapper;

    @Autowired
    private CartMapper cartMapper;

    @Autowired
    private ObjectMapper objectMapper;

    private static final Map<String, String> SORT_FIELD_WHITELIST = new LinkedHashMap<>();
    static {
        SORT_FIELD_WHITELIST.put("price", "p.price");
        SORT_FIELD_WHITELIST.put("brand", "p.brand");
        SORT_FIELD_WHITELIST.put("kcal", "p.energy_kcal");
        SORT_FIELD_WHITELIST.put("fat", "p.fat");
        SORT_FIELD_WHITELIST.put("sugars", "p.sugars");
        SORT_FIELD_WHITELIST.put("fiber", "p.fiber");
        SORT_FIELD_WHITELIST.put("proteins", "p.proteins");
        SORT_FIELD_WHITELIST.put("carbohydrates", "p.carbohydrates");
        SORT_FIELD_WHITELIST.put("salt", "p.salt");
        SORT_FIELD_WHITELIST.put("nutriScore", "p.nutri_score");
        SORT_FIELD_WHITELIST.put("cartId", "c.cart_id");
        SORT_FIELD_WHITELIST.put("updatedAt", "c.updated_at");
    }


    public String buildOrderBy(CartListRequest request){
        List<SortItem> sorts = request.getSorts();

        if (sorts == null || sorts.isEmpty()){
            return "c.cart_id desc";
        }
        String orderBy = sorts.stream()
                .filter(s -> s.getField() != null && SORT_FIELD_WHITELIST.containsKey(s.getField()))
                .map(s -> {
                    String col = SORT_FIELD_WHITELIST.get(s.getField());
                    String dir = "desc".equalsIgnoreCase(s.getOrder()) ? "desc" : "asc";
                    return col + " " + dir;
                })
                .collect(Collectors.joining(", "));
        return orderBy.isEmpty() ? "c.cart_id desc" : orderBy;
    }

    /**
     * Query product by barcode.
     * First use local DB cache, then fallback to Open Food Facts.
     */
    @Override
    public Product getProductByBarcode(String barcode){
        Product local = safeGetLocal(barcode);
        if (local != null) {
            return local;
        }

        Product offProduct = fetchFromOpenFoodFacts(barcode);
        if (offProduct == null) {
            return null;
        }

        // Best-effort cache insert; even if this fails we still return the OFF result.
        try {
            productMapper.insertProduct(offProduct);
            Product inserted = safeGetLocal(barcode);
            return inserted != null ? inserted : offProduct;
        } catch (Exception e) {
            log.warn("Insert OFF product cache failed. barcode={}", barcode, e);
            return offProduct;
        }
    }

    private Product safeGetLocal(String barcode) {
        try {
            return productMapper.getProductBarcode(barcode);
        } catch (Exception e) {
            log.warn("Local product query failed, continue with OFF fallback. barcode={}", barcode, e);
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
            p.setImageUrl(productNode.path("image_url").asText(null));
            p.setCurrency("EUR");
            p.setNutriScore(StringUtils.upperCase(productNode.path("nutriscore_grade").asText(null)));
            p.setSource("OFF");
            p.setSourceUrl(productNode.path("url").asText(null));
            p.setProductStatus("FOUND");
            p.setLastFetchedAt(new Date());
            return p;
        } catch (Exception e) {
            log.error("OFF lookup failed. barcode={}", barcode, e);
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
            log.warn("OFF direct request failed. url={}", url, e);
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
        Long userId = SecurityUtils.getUserId();
        String orderBy = buildOrderBy(request);
        PageHelper.startPage(request.getPageNum(), request.getPageSize());
        return cartMapper.getCartList(userId, orderBy);
    }
}
