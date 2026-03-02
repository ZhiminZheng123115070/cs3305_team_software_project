import 'package:dio/dio.dart';

import '../models/product_model.dart';
import '../utils/request.dart';

/// True if product has at least one nutrition value (used to decide when to refresh from OFF).
bool productHasAnyNutrition(Product p) {
  return p.energyKcal != null ||
      p.fat != null ||
      p.proteins != null ||
      p.carbohydrates != null ||
      p.sugars != null ||
      p.fiber != null ||
      p.salt != null;
}

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
      "/user/product/search/barcode",
      true,
      "get",
      queryParameters: {"barcode": barcode},
    );

    if (backendResp.statusCode == 200 && backendResp.data is Map<String, dynamic>) {
      final data = backendResp.data as Map<String, dynamic>;
      if (data['code'] == 200 || data['code'] == '200') {
        final rawData = data['data'];
        if (rawData is Map<String, dynamic>) {
          final product = Product.fromJson(rawData);
          if (!productHasAnyNutrition(product)) {
            final offProduct = await _fetchFromOpenFoodFacts(barcode);
            if (offProduct != null && productHasAnyNutrition(offProduct)) {
              final ensureResp = await ensureProduct(offProduct);
              if (ensureResp.statusCode == 200 &&
                  ensureResp.data is Map<String, dynamic>) {
                final ensureData = ensureResp.data as Map<String, dynamic>;
                if (ensureData['code'] == 200 || ensureData['code'] == '200') {
                  return Response(
                    requestOptions: backendResp.requestOptions,
                    statusCode: 200,
                    data: ensureData,
                  );
                }
              }
            }
          }
        }
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

var addCart = (int productId, {int quantity = 1}) async {
  return await DioRequest().httpRequest(
    "/user/product/cart",
    true,
    "post",
    queryParameters: {"product_id": productId, "quantity": quantity},
  );
};

var addProductToCartByBarcode = (String barcode, {int quantity = 1}) async {
  return await DioRequest().httpRequest(
    "/user/product/cart/barcode",
    true,
    "post",
    queryParameters: {"barcode": barcode, "quantity": quantity},
  );
};

/// POST /user/product - ensure product exists (create from OFF data if needed). Returns product with productId.
var ensureProduct = (Product product) async {
  final ns = _normalizeNutriScore(product.nutriScore);
  final body = <String, dynamic>{
    'barcode': product.barcode,
    'name': product.productName,
    if (product.brand != null) 'brand': product.brand,
    if (product.imageUrl != null) 'imageUrl': product.imageUrl,
    if (product.price != null) 'price': product.price,
    'currency': (product.currency != null && product.currency!.trim().isNotEmpty) ? product.currency! : 'EUR',
    if (ns != null) 'nutriScore': ns,
    if (product.energyKcal != null) 'energyKcal': product.energyKcal,
    if (product.fat != null) 'fat': product.fat,
    if (product.saturatedFat != null) 'saturatedFat': product.saturatedFat,
    if (product.carbohydrates != null) 'carbohydrates': product.carbohydrates,
    if (product.sugars != null) 'sugars': product.sugars,
    if (product.fiber != null) 'fiber': product.fiber,
    if (product.proteins != null) 'proteins': product.proteins,
    if (product.salt != null) 'salt': product.salt,
  };
  return await DioRequest().httpRequest(
    "/user/product",
    true,
    "post",
    data: body,
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
    // Request without fields filter to get full product (including full nutriments object)
    final res = await dio.get(
      "https://world.openfoodfacts.org/api/v2/product/$code.json",
      options: Options(headers: const {
        "User-Agent": "ruoyi_app/1.0 (cs3305 team project)",
      }),
    );

    final data = res.data;
    if (res.statusCode != 200 || data is! Map<String, dynamic>) return null;
    if (data["status"] != 1) return null;

    final p = data["product"];
    if (p is! Map<String, dynamic>) return null;
    final name = (p["product_name"] ?? p["product_name_en"] ?? p["product_name_fr"] ?? "").toString().trim();
    if (name.isEmpty) return null;

    final brand = (p["brands"] ?? "").toString().trim();
    final imageUrl = ((p["image_front_url"] ?? p["image_url"]) ?? "").toString().trim();
    final nutriScore = (p["nutriscore_grade"] ?? "").toString().trim();

    // Product total weight/volume in grams (for converting per-100g to total)
    final totalGrams = _parseQuantityGrams(p);

    num? energyKcal;
    num? fat;
    num? saturatedFat;
    num? carbohydrates;
    num? sugars;
    num? fiber;
    num? proteins;
    num? salt;
    final nutriments = p["nutriments"];
    if (nutriments is Map<String, dynamic>) {
      // OFF: _100g = per 100g, _serving = per serving, no suffix = entered value. energy_100g is kJ. salt from salt_100g or sodium_100g*2.5.
      num? e100 = _nutrientNum(nutriments, "energy-kcal_100g", "energy_kcal_100g", "energy-kcal", "energy-kcal_value");
      if (e100 == null) {
        final kj = _nutrientNum(nutriments, "energy_100g", "energy-kj_100g");
        if (kj != null) e100 = kj / 4.184;
      }
      final f100 = _nutrientNum(nutriments, "fat_100g", "fat_serving", "fat", "fat_value");
      final s100 = _nutrientNum(nutriments, "saturated-fat_100g", "saturated_fat_100g", "saturated-fat_serving", "saturated-fat", "saturated-fat_value");
      final c100 = _nutrientNum(nutriments, "carbohydrates_100g", "carbohydrates_serving", "carbohydrates", "carbohydrates_value");
      final su100 = _nutrientNum(nutriments, "sugars_100g", "sugars_serving", "sugars", "sugars_value");
      final fi100 = _nutrientNum(nutriments, "fiber_100g", "fiber_serving", "fiber", "fiber_value");
      final pr100 = _nutrientNum(nutriments, "proteins_100g", "proteins_serving", "proteins", "proteins_value");
      num? sa100 = _nutrientNum(nutriments, "salt_100g", "salt_serving", "salt", "salt_value");
      if (sa100 == null) {
        final sodium = _nutrientNum(nutriments, "sodium_100g", "sodium_serving", "sodium");
        if (sodium != null) sa100 = sodium * 2.5;
      }
      // Scale per-100g to total when quantity present; otherwise use per-100g as-is
      if (totalGrams != null && totalGrams > 0) {
        final scale = totalGrams / 100;
        energyKcal = e100 != null ? e100 * scale : null;
        fat = f100 != null ? f100 * scale : null;
        saturatedFat = s100 != null ? s100 * scale : null;
        carbohydrates = c100 != null ? c100 * scale : null;
        sugars = su100 != null ? su100 * scale : null;
        fiber = fi100 != null ? fi100 * scale : null;
        proteins = pr100 != null ? pr100 * scale : null;
        salt = sa100 != null ? sa100 * scale : null;
      } else {
        energyKcal = e100;
        fat = f100;
        saturatedFat = s100;
        carbohydrates = c100;
        sugars = su100;
        fiber = fi100;
        proteins = pr100;
        salt = sa100;
      }
    }

    return Product(
      productId: 0,
      barcode: (p["code"] ?? code).toString(),
      productName: name,
      brand: brand.isEmpty ? null : brand,
      imageUrl: imageUrl.isEmpty ? null : imageUrl,
      price: null,
      currency: null,
      nutriScore: _normalizeNutriScore(nutriScore),
      energyKcal: energyKcal,
      fat: fat,
      saturatedFat: saturatedFat,
      carbohydrates: carbohydrates,
      sugars: sugars,
      fiber: fiber,
      proteins: proteins,
      salt: salt,
    );
  } catch (_) {
    return null;
  }
}

/// Nutri-Score is one letter A-E. OFF may return "unknown" etc; we normalize or return null.
String? _normalizeNutriScore(String? s) {
  if (s == null) return null;
  final t = s.trim();
  if (t.isEmpty) return null;
  final c = t.toUpperCase().substring(0, 1);
  return (c == 'A' || c == 'B' || c == 'C' || c == 'D' || c == 'E') ? c : null;
}

/// Try multiple OFF nutriment keys (e.g. energy-kcal_100g, energy_kcal_100g, energy-kcal_serving); first non-null wins.
num? _nutrientNum(Map<String, dynamic> nutriments, String key1, [String? key2, String? key3, String? key4, String? key5]) {
  final keys = [key1, if (key2 != null) key2, if (key3 != null) key3, if (key4 != null) key4, if (key5 != null) key5];
  for (final k in keys) {
    final v = nutriments[k];
    final n = _numFromNutrient(v);
    if (n != null) return n;
  }
  return null;
}

num? _numFromNutrient(dynamic v) {
  if (v == null) return null;
  if (v is num) return v;
  if (v is String) return double.tryParse(v);
  // OFF sometimes nests value: {"value": 592, "unit": "kcal"}
  if (v is Map) {
    final val = v["value"];
    if (val != null) return _numFromNutrient(val);
  }
  return null;
}

/// Parse OFF quantity/product_quantity to total grams (for converting per-100g to total).
/// Examples: "500 g" -> 500, "1 kg" -> 1000, "330 ml" -> 330.
double? _parseQuantityGrams(Map<String, dynamic> product) {
  final pq = product["product_quantity"];
  if (pq != null) {
    if (pq is num) return pq.toDouble();
    if (pq is String) return double.tryParse(pq.trim());
  }
  final q = product["quantity"]?.toString().trim();
  if (q == null || q.isEmpty) return null;
  final lower = q.toLowerCase();
  final numPart = double.tryParse(q.replaceAll(RegExp(r'[^\d.,]'), '').replaceAll(',', '.'));
  if (numPart == null || numPart <= 0) return null;
  if (lower.contains('kg')) return numPart * 1000;
  if (lower.contains('g') || lower.contains('ml')) return numPart;
  return numPart;
}
