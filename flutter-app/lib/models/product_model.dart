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

  Product({
    required this.productId,
    required this.barcode,
    required this.productName,
    this.brand,
    this.imageUrl,
    this.price,
    this.currency,
    this.nutriScore,
  });

  // Factory method to create Product from JSON (app_products response)
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      productId: (json['productId'] is int)
          ? json['productId'] as int
          : (json['productId'] as num?)?.toInt() ?? 0,
      barcode: json['barcode']?.toString() ?? '',
      productName: json['name']?.toString() ?? json['productName']?.toString() ?? 'Unknown Product',
      brand: json['brand']?.toString(),
      imageUrl: json['imageUrl']?.toString(),
      price: json['price'] != null ? (json['price'] as num) : null,
      currency: json['currency']?.toString(),
      nutriScore: json['nutriScore']?.toString(),
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
    };
  }

  String get summary {
    return 'Product ID: $productId\nBarcode: $barcode\nName: $productName';
  }
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
