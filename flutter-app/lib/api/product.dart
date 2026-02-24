import 'package:dio/dio.dart';

import '../models/product_model.dart';
import '../utils/request.dart';

var addOrder = (int cartId) async {
  return await DioRequest().httpRequest(
    "/user/product/order",
    true,
    "post",
    queryParameters: {"cart_id": cartId},
  );
};

var getOrderList = () async {
  return await DioRequest().httpRequest(
    "/user/product/order",
    true,
    "get",
  );
};

var searchProductByBarcode = (String barcode) async {
  try {
    final backendResp = await DioRequest().httpRequest(
      "/user/product/search/barcode",
      true,
      "get",
      queryParameters: {"barcode": barcode},
      suppressErrorToast: true,
    );

    if (backendResp.statusCode == 200 && backendResp.data is Map<String, dynamic>) {
      final data = backendResp.data as Map<String, dynamic>;
      if (data['code'] == 200 || data['code'] == '200') {
        return backendResp;
      }
    }

    final offProduct = await _fetchFromOpenFoodFacts(barcode);
    if (offProduct != null) {
      return Response(
        requestOptions: backendResp.requestOptions,
        statusCode: 200,
        data: {
          "code": 200,
          "msg": "Found via Open Food Facts",
          "data": offProduct.toJson(),
        },
      );
    }

    return backendResp;
  } catch (_) {
    final offProduct = await _fetchFromOpenFoodFacts(barcode);
    if (offProduct != null) {
      return Response(
        requestOptions: RequestOptions(path: "/user/product/search/barcode"),
        statusCode: 200,
        data: {
          "code": 200,
          "msg": "Found via Open Food Facts (client fallback)",
          "data": offProduct.toJson(),
        },
      );
    }
    rethrow;
  }
};

var searchProductByBarcodeForScanning = (String barcode) async {
  try {
    final backendResp = await DioRequest().httpRequest(
      "/user/product/search/barcode/scanning",
      true,
      "get",
      queryParameters: {"barcode": barcode},
      suppressErrorToast: true,
    );

    if (backendResp.statusCode == 200 && backendResp.data is Map<String, dynamic>) {
      final data = backendResp.data as Map<String, dynamic>;
      if (data['code'] == 200 || data['code'] == '200') {
        return backendResp;
      }
    }

    final offProduct = await _fetchFromOpenFoodFacts(barcode);
    if (offProduct != null) {
      return Response(
        requestOptions: backendResp.requestOptions,
        statusCode: 200,
        data: {
          "code": 200,
          "msg": "Found via Open Food Facts",
          "data": offProduct.toJson(),
        },
      );
    }

    // Compatibility fallback for servers that do not support the scanning route yet:
    // try the normal barcode search endpoint (which may still return DB products).
    return await searchProductByBarcode(barcode);
  } catch (_) {
    // On network/route errors, reuse the normal barcode search flow, which already
    // includes backend + OFF fallback logic.
    return await searchProductByBarcode(barcode);
  }
};

var addCart = (int productId, {int quantity = 1}) async {
  return await DioRequest().httpRequest(
    "/user/product/cart",
    true,
    "post",
    queryParameters: {"product_id": productId, "quantity": quantity},
  );
};

var addProductToCartByBarcode = (String barcode, {int quantity = 1}) async {
  try {
    final directResp = await DioRequest().httpRequest(
      "/user/product/cart/barcode",
      true,
      "post",
      queryParameters: {"barcode": barcode, "quantity": quantity},
      suppressErrorToast: true,
    );

    if (directResp.statusCode == 200 && directResp.data is Map) {
      final d = directResp.data as Map;
      if (d['code'] == 200 || d['code'] == '200') {
        return directResp;
      }
    }

    // Fall through to compatibility path below (older backend may not support /cart/barcode).
  } catch (_) {
    // Continue to compatibility path below.
  }

  // Compatibility fallback:
  // 1) force backend barcode lookup (which caches OFF result into app_products on updated backend)
  // 2) use normal cart add by resolved product_id
  Response? backendSearchResp;
  try {
    backendSearchResp = await DioRequest().httpRequest(
      "/user/product/search/barcode/scanning",
      true,
      "get",
      queryParameters: {"barcode": barcode},
      suppressErrorToast: true,
    );
  } catch (_) {
    try {
      backendSearchResp = await DioRequest().httpRequest(
        "/user/product/search/barcode",
        true,
        "get",
        queryParameters: {"barcode": barcode},
        suppressErrorToast: true,
      );
    } catch (_) {
      // If both backend routes fail, return a clear error instead of a false success.
      return Response(
        requestOptions: RequestOptions(path: "/user/product/cart/barcode"),
        statusCode: 200,
        data: {
          "code": 500,
          "msg": "Backend could not cache scanned product before adding to cart",
        },
      );
    }
  }

  if (backendSearchResp != null &&
      backendSearchResp.statusCode == 200 &&
      backendSearchResp.data is Map<String, dynamic>) {
    final map = backendSearchResp.data as Map<String, dynamic>;
    if (map['code'] == 200 || map['code'] == '200') {
      final data = map['data'];
      if (data is Map<String, dynamic>) {
        final productId = data['productId'];
        if (productId is num && productId > 0) {
          return await addCart(productId.toInt(), quantity: quantity);
        }
      }
    }
  }

  // Do not return backend/client search success as cart success.
  return Response(
    requestOptions: RequestOptions(path: "/user/product/cart/barcode"),
    statusCode: 200,
    data: {
      "code": 500,
      "msg": "Scanned product found but not saved in app_products, so cart add was not completed",
    },
  );
};

var updateCart = (int cartId, int quantity) async {
  return await DioRequest().httpRequest(
    "/user/product/cart",
    true,
    "put",
    queryParameters: {"cart_id": cartId, "quantity": quantity},
  );
};

var deleteCart = (int cartId) async {
  return await DioRequest().httpRequest(
    "/user/product/cart/",
    true,
    "delete",
    queryParameters: {"cart_id": cartId},
  );
};

/// GET /user/product/storage/list - pantry/storage items (app_user_storage)
var getStorageList = ({int pageNum = 1, int pageSize = 100}) async {
  return await DioRequest().httpRequest(
    "/user/product/storage/list",
    true,
    "get",
    queryParameters: {"pageNum": pageNum, "pageSize": pageSize},
  );
};

/// PUT /user/product/storage - update consumption (subtract portion consumed)
var updateStorage = (int storageId, double consumptionRate) async {
  return await DioRequest().httpRequest(
    "/user/product/storage",
    true,
    "put",
    queryParameters: {"storage_id": storageId, "consumption_rate": consumptionRate},
  );
};

var getCartList = (String? sortField, String sortOrder, {int pageNum = 1, int pageSize = 100}) async {
  final params = <String, dynamic>{"pageNum": pageNum, "pageSize": pageSize};
  if (sortField != null && sortField.isNotEmpty) {
    params["sorts[0].field"] = sortField;
    params["sorts[0].order"] = sortOrder;
  }
  return await DioRequest().httpRequest(
    "/user/product/cart/list",
    true,
    "get",
    queryParameters: params,
  );
};

Future<Product?> _fetchFromOpenFoodFacts(String barcode) async {
  final code = barcode.trim();
  if (code.isEmpty) return null;

  try {
    final dio = Dio(BaseOptions(
      connectTimeout: 10000,
      receiveTimeout: 10000,
    ));
    final res = await dio.get(
      "https://world.openfoodfacts.org/api/v2/product/$code.json",
      queryParameters: {
        "fields":
            "code,product_name,product_name_en,brands,image_url,image_front_url,nutriscore_grade",
      },
      options: Options(headers: const {
        "User-Agent": "ruoyi_app/1.0 (cs3305 team project)",
      }),
    );

    final data = res.data;
    if (res.statusCode != 200 || data is! Map<String, dynamic>) return null;
    if (data["status"] != 1) return null;

    final p = data["product"];
    if (p is! Map<String, dynamic>) return null;
    final name = ((p["product_name"] ?? p["product_name_en"]) ?? "").toString().trim();
    final resolvedName = name.isEmpty ? "Unknown Product" : name;

    final brand = (p["brands"] ?? "").toString().trim();
    final imageUrl = ((p["image_front_url"] ?? p["image_url"]) ?? "").toString().trim();
    final nutriScore = (p["nutriscore_grade"] ?? "").toString().trim();

    return Product(
      productId: 0,
      barcode: (p["code"] ?? code).toString(),
      productName: resolvedName,
      brand: brand.isEmpty ? null : brand,
      imageUrl: imageUrl.isEmpty ? null : imageUrl,
      price: null,
      currency: null,
      nutriScore: nutriScore.isEmpty ? null : nutriScore.toUpperCase(),
    );
  } catch (_) {
    return null;
  }
}
