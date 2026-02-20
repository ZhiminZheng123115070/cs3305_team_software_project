import 'package:flutter/material.dart';
import 'package:ruoyi_app/api/product.dart';
import 'package:ruoyi_app/models/product_model.dart';

class ProductQueryPage extends StatefulWidget {
  const ProductQueryPage({Key? key}) : super(key: key);

  @override
  State<ProductQueryPage> createState() => _ProductQueryPageState();
}

class _ProductQueryPageState extends State<ProductQueryPage> {
  final TextEditingController _barcodeController = TextEditingController();
  Product? _product; // Current product
  bool _isLoading = false; // Loading state
  String _errorMessage = ''; // Error message

  // Send HTTP request to search product
  Future<void> _searchProduct() async {
    final barcode = _barcodeController.text.trim();

    if (barcode.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter a barcode';
        _product = null;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
      _product = null;
    });

    try {
      // Send GET request using Dio
      final response = await searchProductByBarcode(barcode);

      // Check response status
      if (response.statusCode == 200) {
        // Parse JSON response (Dio already parses JSON, so response.data is Map)
        final apiResponse = ApiResponse.fromJson(response.data as Map<String, dynamic>);

        if (apiResponse.code == 200) {
          // Successfully got product info
          setState(() {
            _product = apiResponse.data;
            _errorMessage = '';
          });
        } else {
          // API returned error
          setState(() {
            _errorMessage = apiResponse.msg;
            _product = null;
          });
        }
      } else {
        // HTTP request failed
        setState(() {
          _errorMessage = 'HTTP Error: ${response.statusCode}';
          _product = null;
        });
      }
    } catch (e) {
      // Catch exceptions (network error, parsing error, etc.)
      setState(() {
        _errorMessage = 'Error: $e';
        _product = null;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Clear input and results
  void _clearSearch() {
    _barcodeController.clear();
    setState(() {
      _product = null;
      _errorMessage = '';
    });
  }

  // Build result content based on current state
  Widget _buildResultContent() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Searching for product...'),
          ],
        ),
      );
    }

    if (_product != null) {
      return SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle,
              size: 80,
              color: Colors.green[400],
            ),
            const SizedBox(height: 24),
            Text(
              'Product Found!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green[700],
              ),
            ),
            const SizedBox(height: 32),
            _buildProductInfoCard(),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _clearSearch,
              icon: const Icon(Icons.search_off),
              label: const Text('Clear & Search Again'),
            ),
          ],
        ),
      );
    }

    // Default state - waiting for search
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 80,
            color: Colors.grey,
          ),
          SizedBox(height: 16),
          Text(
            'No product searched yet',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Enter a barcode and click "Search Product"',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Build product information card
  Widget _buildProductInfoCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Name (from app_products.name)
            Row(
              children: [
                const Icon(Icons.shopping_bag, color: Colors.blue),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _product!.productName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Product ID
            _buildInfoRow('Product ID:', '${_product!.productId}'),
            const SizedBox(height: 12),

            // Barcode
            _buildInfoRow('Barcode:', _product!.barcode),
            if (_product!.brand != null && _product!.brand!.isNotEmpty) ...[
              const SizedBox(height: 12),
              _buildInfoRow('Brand:', _product!.brand!),
            ],
            if (_product!.price != null) ...[
              const SizedBox(height: 12),
              _buildInfoRow(
                'Price:',
                '${_product!.price} ${_product!.currency ?? ''}'.trim(),
              ),
            ],
            if (_product!.nutriScore != null &&
                _product!.nutriScore!.isNotEmpty) ...[
              const SizedBox(height: 12),
              _buildInfoRow('Nutri-Score:', _product!.nutriScore!),
            ],
            const SizedBox(height: 12),

            // Search time
            _buildInfoRow('Search Time:', _getCurrentTime()),
          ],
        ),
      ),
    );
  }

  // Helper method to build info row
  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }

  // Helper method to get current time
  String _getCurrentTime() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _barcodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Inquiry System'),
        actions: [
          if (_product != null)
            IconButton(
              onPressed: _clearSearch,
              icon: const Icon(Icons.clear_all),
              tooltip: 'Clear search',
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 1. Input field
            TextField(
              controller: _barcodeController,
              decoration: InputDecoration(
                labelText: 'Please enter the product barcode:',
                hintText: 'e.g.: 880123456701',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                prefixIcon: const Icon(Icons.qr_code_scanner),
                suffixIcon: _barcodeController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _barcodeController.clear();
                          setState(() {});
                        },
                      )
                    : null,
              ),
              keyboardType: TextInputType.number,
              onChanged: (_) => setState(() {}),
            ),

            const SizedBox(height: 16),

            // 2. Error message (if any)
            if (_errorMessage.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: Colors.red[200]!),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _errorMessage,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ),

            if (_errorMessage.isNotEmpty) const SizedBox(height: 16),

            // 3. Search button
            ElevatedButton(
              onPressed: _isLoading ? null : _searchProduct,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: _isLoading ? Colors.grey : null,
              ),
              child: _isLoading
                  ? const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                        SizedBox(width: 12),
                        Text('Searching...'),
                      ],
                    )
                  : const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search),
                        SizedBox(width: 8),
                        Text('Search Product'),
                      ],
                    ),
            ),

            const SizedBox(height: 24),

            // 4. Results display area
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: _buildResultContent(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
