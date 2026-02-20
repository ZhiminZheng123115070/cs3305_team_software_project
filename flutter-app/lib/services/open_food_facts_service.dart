import 'package:dio/dio.dart';
import 'package:ruoyi_app/models/product_model.dart';

class OpenFoodFactsService {
  final Dio _dio;

  OpenFoodFactsService({Dio? dio}) : _dio = dio ?? Dio();

  Future<Product?> fetchByBarcode(String barcode) async {
    final code = barcode.trim();
    if (code.isEmpty) return null;

    final url = "https://world.openfoodfacts.org/api/v2/product/$code.json";

    try {
      final res = await _dio.get(
        url,
        queryParameters: {
          "fields":
              "code,product_name,brands,image_front_url,nutriscore_grade,nutriments,ingredients_text,quantity",
        },
        options: Options(
          headers: {
            "User-Agent": "ruoyi_app/1.0 (cs3305 team project)",
          },
        ),
      );

      final data = res.data;
      if (data == null) return null;

      final status = data["status"];
      if (status != 1) return null;

      final p = data["product"] as Map<String, dynamic>?;
      if (p == null) return null;

      final name = (p["product_name"] ?? "").toString().trim();
      if (name.isEmpty) return null;

      final nutriments =
          (p["nutriments"] is Map<String, dynamic>)
              ? p["nutriments"] as Map<String, dynamic>
              : <String, dynamic>{};

      return Product(
        productId: 0,
        barcode: (p["code"] ?? code).toString(),
        productName: name,
        brand: (p["brands"] ?? "").toString().isEmpty ? null : p["brands"].toString(),
        imageUrl: (p["image_front_url"] ?? "").toString().isEmpty
            ? null
            : p["image_front_url"].toString(),
        nutriScore: _readNutriScore(p),
        price: null,
        currency: null,
        energyKcal100g: _readNum(nutriments, ["energy-kcal_100g", "energy-kcal"]),
        fat100g: _readNum(nutriments, ["fat_100g", "fat"]),
        sugars100g: _readNum(nutriments, ["sugars_100g", "sugars"]),
        salt100g: _readNum(nutriments, ["salt_100g", "salt"]),
        proteins100g: _readNum(nutriments, ["proteins_100g", "proteins"]),
      );
    } catch (_) {
      return null;
    }
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

  String? _readNutriScore(Map<String, dynamic> p) {
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
