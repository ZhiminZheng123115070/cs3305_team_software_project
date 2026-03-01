class CartItem {
  final int cartId;
  final int quantity;
  final int productId;
  final String barcode;
  final String name;
  final String? brand;
  final String? imageUrl;
  final num? price;
  final String? currency;
  final num? energyKcal;
  final num? fat;
  final num? carbohydrates;
  final num? fiber;
  final num? proteins;
  final num? salt;
  final String? nutriScore;
  final String? updatedAt;
  final String? purchasedAt;

  CartItem({
    required this.cartId,
    required this.quantity,
    required this.productId,
    required this.barcode,
    required this.name,
    this.brand,
    this.imageUrl,
    this.price,
    this.currency,
    this.energyKcal,
    this.fat,
    this.carbohydrates,
    this.fiber,
    this.proteins,
    this.salt,
    this.nutriScore,
    this.updatedAt,
    this.purchasedAt,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      cartId: _toInt(json['cartId']) ?? 0,
      quantity: _toInt(json['quantity']) ?? 1,
      productId: _toInt(json['productId']) ?? 0,
      barcode: _strFromJson(json['barcode']) ?? '',
      name: _strFromJson(json['name']) ?? 'unknown',
      brand: _strFromJson(json['brand']),
      imageUrl: _strFromJson(json['imageUrl']),
      price: _numFromJson(json['price']),
      currency: _strFromJson(json['currency']),
      energyKcal: _numFromJson(json['energyKcal']),
      fat: _numFromJson(json['fat']),
      carbohydrates: _numFromJson(json['carbohydrates']),
      fiber: _numFromJson(json['fiber']),
      proteins: _numFromJson(json['proteins']),
      salt: _numFromJson(json['salt']),
      nutriScore: _strFromJson(json['nutriScore']),
      updatedAt: json['updatedAt']?.toString(),
      purchasedAt: json['purchasedAt']?.toString(),
    );
  }

  static num? _numFromJson(dynamic v) {
    if (v == null) return null;
    if (v is num && (v == -1 || v == -1.0)) return null;
    if (v is int && v == -1) return null;
    if (v is num) return v;
    if (v is String) {
      final parsed = double.tryParse(v);
      return (parsed != null && parsed != -1) ? parsed : null;
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
      'cartId': cartId,
      'quantity': quantity,
      'productId': productId,
      'barcode': barcode,
      'name': name,
      if (brand != null) 'brand': brand,
      if (imageUrl != null) 'imageUrl': imageUrl,
      if (price != null) 'price': price,
      if (currency != null) 'currency': currency,
      if (energyKcal != null) 'energyKcal': energyKcal,
      if (fat != null) 'fat': fat,
      if (carbohydrates != null) 'carbohydrates': carbohydrates,
      if (fiber != null) 'fiber': fiber,
      if (proteins != null) 'proteins': proteins,
      if (salt != null) 'salt': salt,
      if (nutriScore != null) 'nutriScore': nutriScore,
      if (updatedAt != null) 'updatedAt': updatedAt,
      if (purchasedAt != null) 'purchasedAt': purchasedAt,
    };
  }

  static int? _toInt(dynamic v) {
    if (v == null) return null;
    if (v is int) return v;
    if (v is num) return v.toInt();
    return int.tryParse(v.toString());
  }

  CartItem copyWith({
    int? cartId,
    int? quantity,
    String? purchasedAt,
  }) {
    return CartItem(
      cartId: cartId ?? this.cartId,
      quantity: quantity ?? this.quantity,
      productId: productId,
      barcode: barcode,
      name: name,
      brand: brand,
      imageUrl: imageUrl,
      price: price,
      currency: currency,
      energyKcal: energyKcal,
      fat: fat,
      carbohydrates: carbohydrates,
      fiber: fiber,
      proteins: proteins,
      salt: salt,
      nutriScore: nutriScore,
      updatedAt: updatedAt,
      purchasedAt: purchasedAt ?? this.purchasedAt,
    );
  }
}

String formatPrice(num? price) {
  if (price == null || price == -1) return 'unknown';
  final v = price is int ? price.toDouble() : (price as num).toDouble();
  if (v < 0 || v == -1) return 'unknown';
  if (v == v.truncate()) return '€${v.toInt()}';
  return '€${v.toStringAsFixed(2)}';
}
