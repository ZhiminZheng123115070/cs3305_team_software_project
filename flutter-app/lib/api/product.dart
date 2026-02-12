import 'package:dio/dio.dart';
import '../utils/request.dart';
import '../models/product_model.dart';

/// Search product by barcode:
/// 1) Try your backend first (requires token)
/// 2) If backend doesn't have it, fallback to Open Food Facts (no token)
///
/// This keeps the SAME function name/signature so other code won't break.
var searchProductByBarcode = (String barcode) async {
  // 1) Try backend first
  try {
    final backendResp = await DioRequest().httpRequest(
      "/user/product/search/barcode",
      true,
      "get",
      queryParameters: {"barcode": barcode},
    );

    // If backend returned something, decide if it's a hit
    if (backendResp.statusCode == 200 && backendResp.data is Map<String, dynamic>) {
      final api = ApiResponse.fromJson(backendResp.data as Map<String, dynamic>);

      // Backend success + has product => return as-is
      if (api.code == 200 && api.data != null) {
        return backendResp;
      }

      // Backend said "not found" or no data => fallback
      final offProduct = await _fetchFromOpenFoodFacts(barcode);
      if (offProduct != null) {
        // Return in the SAME JSON shape your UI expects
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

      // OFF also not found -> return backend response (keeps msg)
      return backendResp;
    }

    // If backend gave a weird response, fallback anyway
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
    // If backend fails (network/auth/etc.), try OFF so scan still works
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

    // Still throw so your Cart shows the error message
    rethrow;
  }
};

/// Open Food Facts fallback.
/// API: https://world.openfoodfacts.org/api/v2/product/{barcode}.json
Future<Product?> _fetchFromOpenFoodFacts(String barcode) async {
  try {
    final dio = Dio(BaseOptions(
      connectTimeout: 10000,
      receiveTimeout: 10000,
    ));

    final url = "https://world.openfoodfacts.org/api/v2/product/$barcode.json";
    final resp = await dio.get(
      url,
      queryParameters: {
        // keep it small + fast
        "fields": "code,product_name,brands,image_url,nutriscore_grade,nutriments,quantity"
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
    final imageUrl = (productJson["image_url"] ?? "").toString().trim();
    final nutriScore = (productJson["nutriscore_grade"] ?? "").toString().trim();

    // Optional: try to infer a "price" from OFF? (OFF doesn't give price)
    // We'll leave price null so your UI can still show info without breaking.
    return Product(
      productId: 0, // OFF has no internal productId, so keep 0
      barcode: barcode,
      productName: name,
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

