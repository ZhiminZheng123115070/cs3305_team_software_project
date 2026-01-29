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

// Product data class
class Product {
  final int productId;       // product ID
  final String barcode;      // barcode
  final String productName;  // product name

  Product({
    required this.productId,
    required this.barcode,
    required this.productName,
  });

  // Factory method to create Product from JSON
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      productId: json['productId']?.toInt() ?? 0,
      barcode: json['barcode'] ?? '',
      productName: json['productName'] ?? 'Unknown Product',
    );
  }

  // Convert Product to Map (if needed)
  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'barcode': barcode,
      'productName': productName,
    };
  }

  // Get product summary (for display)
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
