import 'dart:convert';

class ApiResponse {
  final String msg;
  final int code;
  final Product? data;

  ApiResponse({
    required this.msg,
    required this.code,
    this.data,
  });

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

class Product {
  final int productId;
  final String barcode;
  final String productName;
  final String? brand;
  final String? imageUrl;
  final num? price;
  final String? currency;
  final String? nutriScore;
  final num? energyKcal100g;
  final num? fat100g;
  final num? sugars100g;
  final num? salt100g;
  final num? proteins100g;

  Product({
    required this.productId,
    required this.barcode,
    required this.productName,
    this.brand,
    this.imageUrl,
    this.price,
    this.currency,
    this.nutriScore,
    this.energyKcal100g,
    this.fat100g,
    this.sugars100g,
    this.salt100g,
    this.proteins100g,
  });

  static num? _toNum(dynamic v) {
    if (v == null) return null;
    if (v is num) return v;
    return num.tryParse(v.toString());
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      productId: (json['productId'] is int)
          ? json['productId'] as int
          : (json['productId'] as num?)?.toInt() ?? 0,
      barcode: json['barcode']?.toString() ?? '',
      productName: json['name']?.toString() ??
          json['productName']?.toString() ??
          'Unknown Product',
      brand: json['brand']?.toString(),
      imageUrl: json['imageUrl']?.toString(),
      price: _toNum(json['price']),
      currency: json['currency']?.toString(),
      nutriScore: json['nutriScore']?.toString(),
      energyKcal100g: _toNum(json['energyKcal100g']),
      fat100g: _toNum(json['fat100g']),
      sugars100g: _toNum(json['sugars100g']),
      salt100g: _toNum(json['salt100g']),
      proteins100g: _toNum(json['proteins100g']),
    );
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
      if (energyKcal100g != null) 'energyKcal100g': energyKcal100g,
      if (fat100g != null) 'fat100g': fat100g,
      if (sugars100g != null) 'sugars100g': sugars100g,
      if (salt100g != null) 'salt100g': salt100g,
      if (proteins100g != null) 'proteins100g': proteins100g,
    };
  }

  String get summary {
    return 'Product ID: $productId\nBarcode: $barcode\nName: $productName';
  }
}

ApiResponse apiResponseFromJson(String str) {
  return ApiResponse.fromJson(json.decode(str));
}

String apiResponseToJson(ApiResponse data) {
  return json.encode(data.toJson());
}

Product productFromJson(String str) {
  return Product.fromJson(json.decode(str));
}

String productToJson(Product data) {
  return json.encode(data.toJson());
}
