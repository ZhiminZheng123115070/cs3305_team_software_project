import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ruoyi_app/models/cart_item_model.dart';

class ProductDetailPage extends StatelessWidget {
  const ProductDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final item = Get.arguments as CartItem?;
    if (item == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Product')),
        body: const Center(child: Text('Product not found')),
      );
    }

    const lightGreen = Color(0xFFE8F5E9);
    const green = Color(0xFF4CAF50);
    const orange = Color(0xFFFF9800);

    return Scaffold(
      backgroundColor: lightGreen,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Back to Cart',
          style: TextStyle(color: Colors.black87, fontSize: 16),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: item.imageUrl != null && item.imageUrl!.isNotEmpty
                    ? Image.network(
                        item.imageUrl!,
                        height: 220,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _buildPlaceholder(220, lightGreen, green),
                      )
                    : _buildPlaceholder(220, lightGreen, green),
              ),
            ),
            const SizedBox(height: 16),
            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (item.brand != null && item.brand!.isNotEmpty)
                    Text(
                      item.brand!,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  if (item.brand != null && item.brand!.isNotEmpty) const SizedBox(height: 4),
                  Text(
                    item.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (item.price != null)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          formatPrice(item.price),
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: green,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'per unit',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _buildCard(
              title: 'Nutrition Facts',
              icon: Icons.restaurant,
              iconColor: green,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Values from product record (per 100g or total per product by source).',
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 10),
                  _hasAnyNutrition(item)
                      ? Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: [
                            if (item.energyKcal != null)
                              _nutrientChip('Calories', '${item.energyKcal}', 'kcal', orange),
                            if (item.proteins != null)
                              _nutrientChip('Protein', '${item.proteins}', 'g', green),
                            if (item.carbohydrates != null)
                              _nutrientChip('Carbs', '${item.carbohydrates}', 'g', green),
                            if (item.fat != null)
                              _nutrientChip('Fat', '${item.fat}', 'g', orange),
                            if (item.fiber != null)
                              _nutrientChip('Fiber', '${item.fiber}', 'g', green),
                            if (item.salt != null)
                              _nutrientChip('Salt', '${item.salt}', 'g', orange),
                          ],
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            'No nutrition data for this product. It may have been added before we saved OFF data, or OFF had no nutriments for this barcode.',
                            style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                          ),
                        ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _buildCard(
              title: 'Product Information',
              child: Column(
                children: [
                  if (item.barcode.isNotEmpty)
                    _infoRow(Icons.qr_code_2, 'Product Code', item.barcode, orange),
                  if (item.currency != null)
                    _infoRow(Icons.euro_symbol, 'Currency', item.currency!, green),
                  if (item.nutriScore != null && item.nutriScore!.isNotEmpty)
                    _infoRow(Icons.eco, 'Nutri-Score', item.nutriScore!, green),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  static bool _hasAnyNutrition(CartItem item) {
    return item.energyKcal != null ||
        item.proteins != null ||
        item.carbohydrates != null ||
        item.fat != null ||
        item.fiber != null ||
        item.salt != null;
  }

  Widget _buildPlaceholder(double height, Color bg, Color iconColor) {
    return Container(
      height: height,
      color: bg,
      child: Icon(Icons.shopping_bag, size: 64, color: iconColor),
    );
  }

  Widget _buildCard({
    String? title,
    IconData? icon,
    Color? iconColor,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Row(
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 20, color: iconColor ?? Colors.grey),
                  const SizedBox(width: 8),
                ],
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
          ],
          child,
        ],
      ),
    );
  }

  Widget _nutrientChip(String label, String value, String unit, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            '$label ($unit)',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value, Color iconColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(icon, size: 20, color: iconColor),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
