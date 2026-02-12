import 'package:dio/dio.dart';
import 'package:ruoyi_app/models/product_model.dart';

class OpenFoodFactsService {
  final Dio _dio;

  OpenFoodFactsService({Dio? dio}) : _dio = dio ?? Dio();

  /// Fetch a product from Open Food Facts by barcode.
  /// Returns null if not found or missing key fields.
  Future<Product?> fetchByBarcode(String barcode) async {
    final code = barcode.trim();
    if (code.isEmpty) return null;

    // OFF v2 endpoint
    final url = "https://world.openfoodfacts.org/api/v2/product/$code.json";

    try {
      final res = await _dio.get(
        url,
        queryParameters: {
          // Keep payload small:
          "fields":
              "code,product_name,brands,image_front_url,nutriments,ingredients_text,quantity",
        },
        options: Options(
          headers: {
            "User-Agent": "ruoyi_app/1.0 (cs3305 team project)",
          },
        ),
      );

      final data = res.data;
      if (data == null) return null;

      // OFF uses status: 1 (found) / 0 (not found)
      final status = data["status"];
      if (status != 1) return null;

      final p = data["product"] as Map<String, dynamic>?;
      if (p == null) return null;

      final name = (p["product_name"] ?? "").toString().trim();
      if (name.isEmpty) return null;

      // Map OFF -> your Product model
      return Product(
        productId: 0, // OFF doesn't provide your backend productId
        barcode: (p["code"] ?? code).toString(),
        productName: name,
        brand: (p["brands"] ?? "").toString().isEmpty ? null : p["brands"].toString(),
        imageUrl: (p["image_front_url"] ?? "").toString().isEmpty ? null : p["image_front_url"].toString(),
        // OFF nutriments are nested; you can expand later
        nutriScore: _readNutriScore(p),
        price: null,
        currency: null,
      );
    } catch (_) {
      return null;
    }
  }

  String? _readNutriScore(Map<String, dynamic> p) {
    // OFF sometimes provides nutriscore in different fields depending on product
    // Keep it safe and optional.
    final nutriments = p["nutriments"];
    if (nutriments is Map<String, dynamic>) {
      final ns = nutriments["nutriscore_grade"];
      if (ns != null) return ns.toString();
    }
    final alt = p["nutriscore_grade"];
    if (alt != null) return alt.toString();
    return null;
  }
}

