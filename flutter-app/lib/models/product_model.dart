import 'dart:convert';

// API response wrapper class
class ApiResponse {
  final String msg;     // message
  final int code;       // status code
  final Product? data;   // product data

  ApiResponse({
    required this.msg,
    required this.code,
    this.data,
  });

  // Factory method to create ApiResponse from JSON
  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      msg: json['msg'] ?? '',
      code: json['code'] ?? 0,
      data: json['data'] != null ? Product.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'msg': msg,
      'code': code,
      'data': data?.toJson(),
    };
  }
}

// Product data class (matches app_products / ProductSearchResponse API)
class Product {
  final int productId;
  final String barcode;
  final String productName;  // from API field "name"
  final String? brand;
  final String? imageUrl;
  final num? price;          // from app_products.price
  final String? currency;
  final String? nutriScore;
  // Nutrition per 100g (from OFF nutriments or backend)
  final num? energyKcal;
  final num? fat;
  final num? saturatedFat;
  final num? carbohydrates;
  final num? sugars;
  final num? fiber;
  final num? proteins;
  final num? salt;

  Product({
    required this.productId,
    required this.barcode,
    required this.productName,
    this.brand,
    this.imageUrl,
    this.price,
    this.currency,
    this.nutriScore,
    this.energyKcal,
    this.fat,
    this.saturatedFat,
    this.carbohydrates,
    this.sugars,
    this.fiber,
    this.proteins,
    this.salt,
  });

  // Factory method to create Product from JSON (app_products response)
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      productId: (json['productId'] is int)
          ? json['productId'] as int
          : (json['productId'] as num?)?.toInt() ?? 0,
      barcode: _strFromJson(json['barcode']) ?? json['barcode']?.toString() ?? '',
      productName: _strFromJson(json['name']) ?? _strFromJson(json['productName']) ?? 'Unknown Product',
      brand: _strFromJson(json['brand']),
      imageUrl: _strFromJson(json['imageUrl']),
      price: _numFromJson(json['price']),
      currency: _strFromJson(json['currency']),
      nutriScore: _strFromJson(json['nutriScore']),
      energyKcal: _numFromJson(json['energyKcal']),
      fat: _numFromJson(json['fat']),
      saturatedFat: _numFromJson(json['saturatedFat']),
      carbohydrates: _numFromJson(json['carbohydrates']),
      sugars: _numFromJson(json['sugars']),
      fiber: _numFromJson(json['fiber']),
      proteins: _numFromJson(json['proteins']),
      salt: _numFromJson(json['salt']),
    );
  }

  static num? _numFromJson(dynamic v) {
    if (v == null) return null;
    if (v is num && (v == -1 || v == -1.0)) return null;
    if (v is int && v == -1) return null;
    if (v is num) return v;
    if (v is String) {
      final parsed = double.tryParse(v);
      if (parsed == null) return null;
      if (parsed == -1 || parsed == -1.0) return null;
      return parsed;
    }
    return null;
  }

  static String? _strFromJson(dynamic v) {
    if (v == null) return null;
    final s = v.toString().trim();
    if (s.isEmpty || s == '-1') return null;
    return s;
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'barcode': barcode,
      'name': productName,
      if (brand != null) 'brand': brand,
      if (imageUrl != null) 'imageUrl': imageUrl,
      if (price != null) 'price': price,
      if (currency != null) 'currency': currency,
      if (nutriScore != null) 'nutriScore': nutriScore,
      if (energyKcal != null) 'energyKcal': energyKcal,
      if (fat != null) 'fat': fat,
      if (saturatedFat != null) 'saturatedFat': saturatedFat,
      if (carbohydrates != null) 'carbohydrates': carbohydrates,
      if (sugars != null) 'sugars': sugars,
      if (fiber != null) 'fiber': fiber,
      if (proteins != null) 'proteins': proteins,
      if (salt != null) 'salt': salt,
    };
  }

  String get summary {
    return 'Product ID: $productId\nBarcode: $barcode\nName: $productName';
  }
}

/// Display helper: show "unknown" only for null or -1 (missing data). Genuine 0 shows as "0".
String formatDisplayValue(dynamic value) {
  if (value == null) return 'unknown';
  if (value is num && (value == -1 || value == -1.0)) return 'unknown';
  if (value is String) {
    final s = value.trim();
    if (s.isEmpty) return 'unknown';
    if (s == '-1' || s == '-1.0' || s == '-1.00') return 'unknown';
    final n = double.tryParse(s);
    if (n != null && (n == -1 || n == -1.0)) return 'unknown';
  }
  return value.toString();
}

// Parse JSON string to ApiResponse object
ApiResponse apiResponseFromJson(String str) {
  return ApiResponse.fromJson(json.decode(str));
}

// Convert ApiResponse object to JSON string
String apiResponseToJson(ApiResponse data) {
  return json.encode(data.toJson());
}

// Parse JSON string to Product object
Product productFromJson(String str) {
  return Product.fromJson(json.decode(str));
}

// Convert Product object to JSON string
String productToJson(Product data) {
  return json.encode(data.toJson());
}
