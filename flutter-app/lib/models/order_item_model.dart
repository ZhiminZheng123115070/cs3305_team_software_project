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
      unitPrice: json['unitPrice'] != null ? (json['unitPrice'] as num) : null,
      lineTotal: json['lineTotal'] != null ? (json['lineTotal'] as num) : null,
      currency: json['currency']?.toString(),
      energyKcal: json['energyKcal'] != null ? (json['energyKcal'] as num) : null,
      fat: json['fat'] != null ? (json['fat'] as num) : null,
      carbohydrates: json['carbohydrates'] != null ? (json['carbohydrates'] as num) : null,
      fiber: json['fiber'] != null ? (json['fiber'] as num) : null,
      proteins: json['proteins'] != null ? (json['proteins'] as num) : null,
      salt: json['salt'] != null ? (json['salt'] as num) : null,
      createdAt: json['createdAt']?.toString(),
    );
  }

  static int? _toInt(dynamic v) {
    if (v == null) return null;
    if (v is int) return v;
    if (v is num) return v.toInt();
    return int.tryParse(v.toString());
  }

  num? get displayPrice => unitPrice ?? lineTotal;
}
