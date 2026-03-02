class OrderItem {
  final int orderId;
  final int userId;
  final int productId;
  final String name;
  final String? brand;
  final String? imageUrl;
  final int quantity;
  final num? unitPrice;
  final num? lineTotal;
  final String? currency;
  final num? energyKcal;
  final num? fat;
  final num? carbohydrates;
  final num? fiber;
  final num? proteins;
  final num? salt;
  final String? createdAt;

  OrderItem({
    required this.orderId,
    required this.userId,
    required this.productId,
    required this.name,
    this.brand,
    this.imageUrl,
    required this.quantity,
    this.unitPrice,
    this.lineTotal,
    this.currency,
    this.energyKcal,
    this.fat,
    this.carbohydrates,
    this.fiber,
    this.proteins,
    this.salt,
    this.createdAt,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      orderId: _toInt(json['orderId']) ?? 0,
      userId: _toInt(json['userId']) ?? 0,
      productId: _toInt(json['productId']) ?? 0,
      name: json['name']?.toString() ?? 'Unknown',
      brand: json['brand']?.toString(),
      imageUrl: json['imageUrl']?.toString(),
      quantity: _toInt(json['quantity']) ?? 1,
      unitPrice: _numFromJson(json['unitPrice']),
      lineTotal: _numFromJson(json['lineTotal']),
      currency: json['currency']?.toString(),
      energyKcal: _numFromJson(json['energyKcal']),
      fat: _numFromJson(json['fat']),
      carbohydrates: _numFromJson(json['carbohydrates']),
      fiber: _numFromJson(json['fiber']),
      proteins: _numFromJson(json['proteins']),
      salt: _numFromJson(json['salt']),
      createdAt: json['createdAt']?.toString(),
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

  static int? _toInt(dynamic v) {
    if (v == null) return null;
    if (v is int) return v;
    if (v is num) return v.toInt();
    return int.tryParse(v.toString());
  }

  num? get displayPrice => unitPrice ?? lineTotal;
}
