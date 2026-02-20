import 'package:dio/dio.dart';
import '../utils/request.dart';
import '../models/product_model.dart';

/// Backend-first search (kept for UI usage).
/// If backend fails/unavailable, fallback to OFF for display only.
var searchProductByBarcode = (String barcode) async {
  try {
    final backendResp = await DioRequest().httpRequest(
      "/user/product/search/barcode",
      true,
      "get",
      queryParameters: {"barcode": barcode},
    );

    if (backendResp.statusCode == 200 && backendResp.data is Map<String, dynamic>) {
      final api = ApiResponse.fromJson(backendResp.data as Map<String, dynamic>);
      if (api.code == 200 && api.data != null) {
        return backendResp;
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
          "msg": "Found via Open Food Facts (backend unavailable)",
          "data": offProduct.toJson(),
        },
      );
    }

    rethrow;
  }
};

Future<Response<dynamic>> addProductToCart(int productId, {int quantity = 1}) async {
  return await DioRequest().httpRequest(
    "/user/product/cart?product_id=$productId&quantity=$quantity",
    true,
    "post",
  );
}

/// One-step backend endpoint: resolve/cache by barcode and add to cart.
Future<Response<dynamic>> addProductToCartByBarcode(String barcode, {int quantity = 1}) async {
  return await DioRequest().httpRequest(
    "/user/product/cart/barcode?barcode=$barcode&quantity=$quantity",
    true,
    "post",
  );
}

num? _readNum(Map<String, dynamic> node, List<String> keys) {
  for (final k in keys) {
    final v = node[k];
    if (v == null) continue;
    if (v is num) return v;
    final parsed = num.tryParse(v.toString());
    if (parsed != null) return parsed;
  }
  return null;
}

Future<Product?> _fetchFromOpenFoodFacts(String barcode) async {
  try {
    final dio = Dio(BaseOptions(
      connectTimeout: const Duration(milliseconds: 10000),
      receiveTimeout: const Duration(milliseconds: 10000),
    ));

    final url = "https://world.openfoodfacts.org/api/v2/product/$barcode.json";
    final resp = await dio.get(
      url,
      queryParameters: {
        "fields": "code,product_name,brands,image_url,image_front_url,nutriscore_grade,nutriments,quantity"
      },
    );

    if (resp.statusCode != 200 || resp.data == null) return null;
    if (resp.data is! Map<String, dynamic>) return null;

    final data = resp.data as Map<String, dynamic>;
    final productJson = data["product"];
    if (productJson is! Map<String, dynamic>) return null;

    final name = (productJson["product_name"] ?? "").toString().trim();
    if (name.isEmpty) return null;

    final brand = (productJson["brands"] ?? "").toString().trim();
    final imageUrl =
        ((productJson["image_front_url"] ?? productJson["image_url"]) ?? "")
            .toString()
            .trim();
    final nutriScore = (productJson["nutriscore_grade"] ?? "").toString().trim();

    final nutriments =
        (productJson["nutriments"] is Map<String, dynamic>)
            ? productJson["nutriments"] as Map<String, dynamic>
            : <String, dynamic>{};

    final energyKcal100g = _readNum(nutriments, ["energy-kcal_100g", "energy-kcal"]);
    final fat100g = _readNum(nutriments, ["fat_100g", "fat"]);
    final sugars100g = _readNum(nutriments, ["sugars_100g", "sugars"]);
    final salt100g = _readNum(nutriments, ["salt_100g", "salt"]);
    final proteins100g = _readNum(nutriments, ["proteins_100g", "proteins"]);

    return Product(
      productId: 0,
      barcode: barcode,
      productName: name,
      brand: brand.isEmpty ? null : brand,
      imageUrl: imageUrl.isEmpty ? null : imageUrl,
      price: null,
      currency: null,
      nutriScore: nutriScore.isEmpty ? null : nutriScore.toUpperCase(),
      energyKcal100g: energyKcal100g,
      fat100g: fat100g,
      sugars100g: sugars100g,
      salt100g: salt100g,
      proteins100g: proteins100g,
    );
  } catch (_) {
    return null;
  }
}
