import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:ruoyi_app/api/product.dart';
import 'package:ruoyi_app/models/cart_item_model.dart';
import 'package:ruoyi_app/models/order_item_model.dart';
import 'package:ruoyi_app/models/product_model.dart';
import 'package:ruoyi_app/routes/app_routes.dart';

class CartIndex extends StatefulWidget {
  const CartIndex({Key? key}) : super(key: key);

  @override
  State<CartIndex> createState() => _CartIndexState();
}

class _CartIndexState extends State<CartIndex> {
  List<CartItem> _cartItems = [];
  List<OrderItem> _orderHistory = [];
  bool _loading = true;
  String? _sortField;
  String _sortOrder = 'asc';
  OverlayEntry? _toastOverlay;

  final List<Map<String, String>> _sortOptions = [
    {'field': 'price', 'label': 'Price'},
    {'field': 'kcal', 'label': 'Energy'},
    {'field': 'fat', 'label': 'Fat'},
    {'field': 'carbohydrates', 'label': 'Carbohydrates'},
    {'field': 'fiber', 'label': 'Fiber'},
    {'field': 'proteins', 'label': 'Protein'},
    {'field': 'salt', 'label': 'Salt'},
  ];

  @override
  void initState() {
    super.initState();
    _loadCart();
    _loadOrderHistory();
  }

  Future<void> _loadOrderHistory() async {
    try {
      final resp = await getOrderList();
      if (resp.statusCode == 200 && resp.data != null) {
        final data = resp.data;
        if (data is Map && data['code'] == 200) {
          final rows = data['rows'] ?? data['list'] ?? data['data'];
          if (rows is List) {
            setState(() {
              _orderHistory = rows
                  .map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
                  .toList();
            });
            return;
          }
        }
      }
      setState(() => _orderHistory = []);
    } catch (_) {
      setState(() => _orderHistory = []);
    }
  }

  Future<void> _loadCart() async {
    setState(() => _loading = true);
    try {
      final resp = await getCartList(_sortField, _sortOrder);
      if (resp.statusCode == 200 && resp.data != null) {
        final data = resp.data;
        if (data is Map && data['code'] == 200) {
          final rows = data['rows'] ?? data['list'] ?? data['data'];
          if (rows is List) {
            setState(() {
              _cartItems = rows
                  .map((e) => CartItem.fromJson(e as Map<String, dynamic>))
                  .toList();
            });
            return;
          }
        }
      }
      setState(() => _cartItems = []);
    } catch (_) {
      setState(() => _cartItems = []);
    } finally {
      setState(() => _loading = false);
    }
  }

  void _showProductAddedToast() {
    _toastOverlay?.remove();
    _toastOverlay = OverlayEntry(
      builder: (ctx) => Positioned(
        top: MediaQuery.of(ctx).padding.top + 60,
        left: 24,
        right: 24,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.green.shade600,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Text(
              'Product added to cart',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
    Overlay.of(context).insert(_toastOverlay!);
    Future.delayed(const Duration(seconds: 1), () {
      _toastOverlay?.remove();
      _toastOverlay = null;
    });
  }

  void _showAddProductModal() {
    final barcodeController = TextEditingController();
    Product? foundProduct;
    bool searching = false;
    String errorMsg = '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) {
          return Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(ctx).viewInsets.bottom,
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Add Product',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(ctx),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Product Code',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: barcodeController,
                    decoration: InputDecoration(
                      hintText: 'Enter product code',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  if (errorMsg.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Text(
                      errorMsg,
                      style: TextStyle(color: Colors.red.shade700, fontSize: 13),
                    ),
                  ],
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: searching
                              ? null
                              : () async {
                                  final barcode = barcodeController.text.trim();
                                  if (barcode.isEmpty) {
                                    setModalState(() {
                                      errorMsg = 'Please enter a product code';
                                      foundProduct = null;
                                    });
                                    return;
                                  }
                                  setModalState(() {
                                    searching = true;
                                    errorMsg = '';
                                    foundProduct = null;
                                  });
                                  try {
                                    final resp =
                                        await searchProductByBarcode(barcode);
                                    if (resp.statusCode == 200 &&
                                        resp.data != null) {
                                      final d = resp.data as Map<String, dynamic>?;
                                      if (d != null &&
                                          (d['code'] == 200 || d['code'] == '200')) {
                                        final pd = d['data'];
                                        if (pd != null) {
                                          setModalState(() {
                                            foundProduct =
                                                Product.fromJson(pd as Map<String, dynamic>);
                                            errorMsg = '';
                                          });
                                        } else {
                                          setModalState(() {
                                            errorMsg = d['msg']?.toString() ??
                                                'Product not found';
                                          });
                                        }
                                      } else {
                                        setModalState(() {
                                          errorMsg = d?['msg']?.toString() ??
                                              'Product not found';
                                        });
                                      }
                                    } else {
                                      setModalState(() {
                                        errorMsg = 'Product not found';
                                      });
                                    }
                                  } catch (_) {
                                    setModalState(() {
                                      errorMsg = 'Search failed';
                                    });
                                  } finally {
                                    setModalState(() => searching = false);
                                  }
                                },
                          icon: searching
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(Icons.search, size: 20),
                          label: Text(searching ? 'Searching...' : 'Search'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade600,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Scan feature coming soon'),
                              ),
                            );
                          },
                          icon: const Icon(Icons.document_scanner, size: 20),
                          label: const Text('Scan'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (foundProduct != null) ...[
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.green.shade200),
                      ),
                      child: Row(
                        children: [
                          if (foundProduct!.imageUrl != null &&
                              foundProduct!.imageUrl!.isNotEmpty)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                foundProduct!.imageUrl!,
                                width: 56,
                                height: 56,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  width: 56,
                                  height: 56,
                                  color: Colors.grey.shade300,
                                  child: const Icon(Icons.image_not_supported),
                                ),
                              ),
                            )
                          else
                            Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(Icons.shopping_bag,
                                  color: Colors.grey.shade600),
                            ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  foundProduct!.productName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                if (foundProduct!.brand != null)
                                  Text(
                                    foundProduct!.brand!,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                if (foundProduct!.price != null)
                                  Text(
                                    formatPrice(foundProduct!.price),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green.shade700,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () async {
                              try {
                                final ok = await _addToCartOrIncrement(foundProduct!.productId);
                                if (mounted && ok) Navigator.pop(ctx);
                              } catch (e) {
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Failed to add to cart: ${e.toString()}'),
                                    ),
                                  );
                                }
                              }
                            },
                            icon: Icon(
                              Icons.add_circle,
                              color: Colors.green.shade600,
                              size: 36,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _onPurchase(CartItem item) async {
    try {
      final resp = await addOrder(item.cartId);
      if (resp.statusCode == 200 && resp.data != null) {
        final d = resp.data as Map?;
        if (d != null && (d['code'] == 200 || d['code'] == '200')) {
          await deleteCart(item.cartId);
          await _loadOrderHistory();
          await _loadCart();
          return;
        }
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Purchase failed')),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Purchase failed')),
        );
      }
    }
  }

  Future<void> _onDecrementQuantity(CartItem item) async {
    if (item.quantity <= 1) return;
    try {
      final resp = await updateCart(item.cartId, item.quantity - 1);
      if (resp.statusCode == 200 && resp.data != null) {
        final d = resp.data as Map?;
        if (d != null && (d['code'] == 200 || d['code'] == '200')) {
          _loadCart();
          return;
        }
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update quantity')),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update quantity')),
        );
      }
    }
  }

  Future<void> _onIncrementQuantity(CartItem item) async {
    try {
      final resp = await updateCart(item.cartId, item.quantity + 1);
      if (resp.statusCode == 200 && resp.data != null) {
        final d = resp.data as Map?;
        if (d != null && (d['code'] == 200 || d['code'] == '200')) {
          _loadCart();
          return;
        }
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update quantity')),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update quantity')),
        );
      }
    }
  }

  Future<void> _onDelete(CartItem item) async {
    try {
      await deleteCart(item.cartId);
      _loadCart();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Delete failed')),
        );
      }
    }
  }

  Future<bool> _addToCartOrIncrement(int productId) async {
    try {
      final listResp = await getCartList(null, 'asc');
      if (listResp.statusCode == 200 && listResp.data != null) {
        final data = listResp.data as Map?;
        if (data != null && (data['code'] == 200 || data['code'] == '200')) {
          final rows = data['rows'] ?? data['list'] ?? data['data'];
          if (rows is List) {
            for (final e in rows) {
              final existing = CartItem.fromJson(e as Map<String, dynamic>);
              if (existing.productId == productId) {
                final resp = await updateCart(existing.cartId, existing.quantity + 1);
                if (resp.statusCode == 200 && resp.data != null) {
                  final d = resp.data as Map?;
                  if (d != null && (d['code'] == 200 || d['code'] == '200')) {
                    _showProductAddedToast();
                    _loadCart();
                    return true;
                  }
                }
                break;
              }
            }
          }
        }
      }
      final resp = await addCart(productId);
      if (resp.statusCode == 200 && resp.data != null) {
        final d = resp.data as Map?;
        if (d != null && (d['code'] == 200 || d['code'] == '200')) {
          _showProductAddedToast();
          _loadCart();
          return true;
        }
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to add to cart')),
      );
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to add to cart')),
      );
    }
    return false;
  }

  Future<void> _onReAddFromHistory(OrderItem item) async {
    await _addToCartOrIncrement(item.productId);
  }

  void _openProductDetail(CartItem item) {
    Get.toNamed(AppRoutes.productDetail, arguments: item);
  }

  void _openOrderDetail(OrderItem item) {
    Get.toNamed(AppRoutes.orderDetail, arguments: item);
  }

  String _formatPurchaseDate(String isoDate) {
    try {
      final d = DateTime.parse(isoDate);
      const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      return '${months[d.month - 1]} ${d.day}, ${d.year}';
    } catch (_) {
      return isoDate;
    }
  }

  Widget _buildProductCard(CartItem item) {
    const lightGreen = Color(0xFFE8F5E9);
    const green = Color(0xFF4CAF50);
    const orange = Color(0xFFFF9800);

    return GestureDetector(
      onTap: () => _openProductDetail(item),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 12, top: 12, bottom: 12),
              child: item.imageUrl != null && item.imageUrl!.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        item.imageUrl!,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          width: 80,
                          height: 80,
                          color: Colors.grey.shade200,
                          child: Icon(Icons.image_not_supported, color: Colors.grey.shade600),
                        ),
                      ),
                    )
                  : Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.shopping_bag, color: Colors.grey.shade600, size: 32),
                    ),
            ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  if (item.brand != null && item.brand!.isNotEmpty)
                    Text(
                      item.brand!,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  if (item.price != null)
                    Text(
                      formatPrice(item.price),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: green,
                        fontSize: 15,
                      ),
                    ),
                  if (item.quantity > 1)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        'Qty: ${item.quantity}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                  if (item.energyKcal != null) ...[
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: orange.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '${item.energyKcal} cal',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.orange.shade800,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: item.quantity <= 1 ? null : () => _onDecrementQuantity(item),
                  child: Opacity(
                    opacity: item.quantity <= 1 ? 0.4 : 1,
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: lightGreen,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.remove, color: green, size: 26),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => _onIncrementQuantity(item),
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: lightGreen,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.add, color: green, size: 26),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      ),
    );
  }

  Widget _buildCartContent() {
    const lightGreen = Color(0xFFE8F5E9);
    const green = Color(0xFF4CAF50);

    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_cartItems.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: lightGreen,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.search, size: 40, color: Colors.green.shade700),
            ),
            const SizedBox(height: 16),
            Text(
              'Your cart is empty',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Add products to get started',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ..._cartItems.asMap().entries.map((e) {
            final item = e.value;
            return Slidable(
              key: ValueKey(item.cartId),
              endActionPane: ActionPane(
                motion: const DrawerMotion(),
                extentRatio: 0.25,
                children: [
                  SlidableAction(
                    onPressed: (_) => _onPurchase(item),
                    backgroundColor: green,
                    foregroundColor: Colors.white,
                    icon: Icons.shopping_bag,
                    label: 'Buy',
                  ),
                ],
              ),
              startActionPane: ActionPane(
                motion: const DrawerMotion(),
                extentRatio: 0.25,
                children: [
                  SlidableAction(
                    onPressed: (_) => _onDelete(item),
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    icon: Icons.delete,
                    label: 'Delete',
                  ),
                ],
              ),
              child: _buildProductCard(item),
            );
          }),
      ],
    );
  }

  Map<String, List<OrderItem>> _groupOrderHistoryByDate() {
    final map = <String, List<OrderItem>>{};
    for (final item in _orderHistory) {
      if (item.createdAt == null) continue;
      try {
        final d = DateTime.parse(item.createdAt!);
        final key = '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
        map.putIfAbsent(key, () => []).add(item);
      } catch (_) {}
    }
    return map;
  }

  Widget _buildOrderHistorySection() {
    const lightGreen = Color(0xFFE8F5E9);
    const green = Color(0xFF4CAF50);

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
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: lightGreen,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.calendar_today, color: green, size: 20),
              ),
              const SizedBox(width: 12),
              const Text(
                'Order History',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _orderHistory.isEmpty ? 'No purchased items yet' : 'Last 7 days',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade600,
            ),
          ),
          if (_orderHistory.isNotEmpty) ...[
            const SizedBox(height: 16),
            ..._buildOrderHistoryGroupedByDate(lightGreen, green),
          ],
        ],
      ),
    );
  }

  List<Widget> _buildOrderHistoryGroupedByDate(Color lightGreen, Color green) {
    final grouped = _groupOrderHistoryByDate();
    if (grouped.isEmpty) return [];
    final keys = grouped.keys.toList()..sort((a, b) => b.compareTo(a));
    final widgets = <Widget>[];
    for (final key in keys) {
      final items = grouped[key]!;
      if (items.isEmpty) continue;
      final dateLabel = items.first.createdAt != null
          ? _formatPurchaseDate(items.first.createdAt!)
          : key;
      widgets.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: green,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    dateLabel,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ...items.map((item) => _buildOrderCard(item)),
            ],
          ),
        ),
      );
    }
    return widgets;
  }

  Widget _buildOrderCard(OrderItem item) {
    const lightGreen = Color(0xFFE8F5E9);
    const green = Color(0xFF4CAF50);
    const orange = Color(0xFFFF9800);

    return GestureDetector(
      onTap: () => _openOrderDetail(item),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 12, top: 12, bottom: 12),
              child: item.imageUrl != null && item.imageUrl!.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        item.imageUrl!,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          width: 80,
                          height: 80,
                          color: Colors.grey.shade200,
                          child: Icon(Icons.image_not_supported, color: Colors.grey.shade600),
                        ),
                      ),
                    )
                  : Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.shopping_bag, color: Colors.grey.shade600, size: 32),
                    ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    if (item.brand != null && item.brand!.isNotEmpty)
                      Text(
                        item.brand!,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    Text(
                      formatPrice(item.displayPrice),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: green,
                        fontSize: 15,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        'Qty: ${item.quantity}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                    if (item.lineTotal != null && item.quantity > 1)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          'Line total: ${formatPrice(item.lineTotal)}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ),
                    if (item.energyKcal != null) ...[
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: orange.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '${item.energyKcal} cal',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.orange.shade800,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => _onReAddFromHistory(item),
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: lightGreen,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.add, color: green, size: 26),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const lightGreen = Color(0xFFE8F5E9);
    const green = Color(0xFF4CAF50);

    return Scaffold(
      backgroundColor: lightGreen,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Cart',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${_cartItems.length} items in your cart',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  if (_cartItems.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _sortField ?? _sortOptions.first['field'],
                                isExpanded: true,
                                items: _sortOptions.map((opt) {
                                  final f = opt['field']!;
                                  return DropdownMenuItem<String>(
                                    value: f,
                                    child: Text(opt['label']!),
                                  );
                                }).toList(),
                                onChanged: (v) {
                                  if (v != null) {
                                    setState(() {
                                      _sortField = v;
                                      _loadCart();
                                    });
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _sortOrder =
                                  _sortOrder == 'asc' ? 'desc' : 'asc';
                              _loadCart();
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: _sortOrder == 'asc'
                                  ? green
                                  : green.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              _sortOrder == 'asc'
                                  ? Icons.arrow_upward
                                  : Icons.arrow_downward,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 500),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: lightGreen,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: green.withOpacity(0.3)),
                          ),
                          child: _buildCartContent(),
                        ),
                        const SizedBox(height: 16),
                        _buildOrderHistorySection(),
                        const SizedBox(height: 80),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddProductModal,
        backgroundColor: green,
        child: const Icon(Icons.search, color: Colors.white, size: 28),
      ),
    );
  }
}
