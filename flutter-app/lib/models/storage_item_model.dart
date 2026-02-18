/// Model for app_user_storage (pantry items).
/// Backend: StorageResponse from GET /user/product/storage/list
class StorageItem {
  final int storageId;
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
  final num? proteins;
  /// consumption: 1 = 100% left, 0.5 = 50% left, etc.
  final double consumption;

  StorageItem({
    required this.storageId,
    required this.productId,
    required this.name,
    this.brand,
    this.imageUrl,
    this.quantity = 1,
    this.unitPrice,
    this.lineTotal,
    this.currency,
    this.energyKcal,
    this.fat,
    this.carbohydrates,
    this.proteins,
    this.consumption = 1.0,
  });

  int get percentLeft => (consumption * 100).round().clamp(0, 100);

  factory StorageItem.fromJson(Map<String, dynamic> json) {
    final c = json['consumption'];
    double consumption = 1.0;
    if (c != null) {
      if (c is num) consumption = c.toDouble();
      else consumption = double.tryParse(c.toString()) ?? 1.0;
    }
    return StorageItem(
      storageId: _toInt(json['storageId']) ?? 0,
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
      proteins: json['proteins'] != null ? (json['proteins'] as num) : null,
      consumption: consumption.clamp(0.0, 1.0),
    );
  }

  static int? _toInt(dynamic v) {
    if (v == null) return null;
    if (v is int) return v;
    if (v is num) return v.toInt();
    return int.tryParse(v.toString());
  }
}
