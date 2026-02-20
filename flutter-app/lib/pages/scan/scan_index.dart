import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:ruoyi_app/api/product.dart';
import 'package:ruoyi_app/models/product_model.dart';
import 'package:ruoyi_app/services/open_food_facts_service.dart';

class ScanIndex extends StatefulWidget {
  const ScanIndex({Key? key}) : super(key: key);

  @override
  State<ScanIndex> createState() => _ScanIndexState();
}

class _ScanIndexState extends State<ScanIndex>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late final TabController _tabController;

  // Barcode
  final MobileScannerController _scannerController = MobileScannerController();
  final OpenFoodFactsService _off = OpenFoodFactsService();
  bool _barcodeDone = false;
  String _barcodeValue = '';
  bool _lookupLoading = false;

  // Simple debounce / duplicate guard
  String _lastBarcode = '';
  DateTime _lastScanAt = DateTime.fromMillisecondsSinceEpoch(0);

  // OCR
  final ImagePicker _picker = ImagePicker();
  final TextRecognizer _textRecognizer = TextRecognizer();
  File? _pickedImage;
  String _ocrText = '';
  bool _ocrLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scannerController.dispose();
    _textRecognizer.close();
    _tabController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final onBarcodeTab = _tabController.index == 0;
    if (!onBarcodeTab) return;

    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      _scannerController.stop();
    } else if (state == AppLifecycleState.resumed) {
      if (!_barcodeDone) {
        _scannerController.start();
      }
    }
  }

  void _onDetect(BarcodeCapture capture) {
    if (_barcodeDone) return;

    final barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;

    final raw = barcodes.first.rawValue;
    if (raw == null || raw.trim().isEmpty) return;

    final now = DateTime.now();
    final isSame = raw == _lastBarcode;
    final tooSoon = now.difference(_lastScanAt).inMilliseconds < 1000;
    if (isSame && tooSoon) return;

    _lastBarcode = raw;
    _lastScanAt = now;

    setState(() {
      _barcodeDone = true;
      _barcodeValue = raw.trim();
    });

    _scannerController.stop();
  }

  void _resetBarcode() {
    setState(() {
      _barcodeDone = false;
      _barcodeValue = '';
      _lastBarcode = '';
      _lastScanAt = DateTime.fromMillisecondsSinceEpoch(0);
    });
    _scannerController.start();
  }

  Future<void> _copyToClipboard(String text) async {
    if (text.trim().isEmpty) return;
    await Clipboard.setData(ClipboardData(text: text));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Copied to clipboard')),
    );
  }

  
  String? _extractBarcodeFromText(String text) {
    final matches = RegExp(r'\b\d{8,14}\b').allMatches(text);
    if (matches.isEmpty) return null;

    // Prefer EAN-13 if present, otherwise use first numeric token.
    for (final m in matches) {
      final v = m.group(0);
      if (v != null && v.length == 13) return v;
    }

    return matches.first.group(0);
  }

  Future<void> _useBarcodeFromText() async {
    final extracted = _extractBarcodeFromText(_ocrText);
    if (extracted == null || extracted.trim().isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No barcode-like number found in text')),
      );
      return;
    }

    setState(() {
      _barcodeDone = true;
      _barcodeValue = extracted.trim();
      _tabController.index = 0;
    });

    await _useBarcode();
  }
  Future<void> _useBarcode() async {
    final barcode = _barcodeValue.trim();
    if (barcode.isEmpty || _lookupLoading) return;

    setState(() => _lookupLoading = true);

    Product? product;
    String error = '';

    try {
      final response = await searchProductByBarcode(barcode);
      ApiResponse? apiResponse;

      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        apiResponse = ApiResponse.fromJson(response.data as Map<String, dynamic>);
      }

      final backendOk =
          apiResponse != null && apiResponse.code == 200 && apiResponse.data != null;

      if (backendOk) {
        product = apiResponse!.data;
      } else {
        final offProduct = await _off.fetchByBarcode(barcode);
        if (offProduct != null) {
          product = offProduct;
        } else {
          final msg = (apiResponse?.msg ?? '').trim();
          error = msg.isNotEmpty ? msg : 'Product not found';
        }
      }
    } catch (e) {
      error = 'Error: $e';
    } finally {
      if (mounted) setState(() => _lookupLoading = false);
    }

    if (!mounted) return;

    if (product == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.isEmpty ? 'Product not found' : error)),
      );
      return;
    }

    final foundProduct = product;

    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Product Found'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Name: ${foundProduct.productName}'),
              const SizedBox(height: 8),
              Text('Barcode: ${foundProduct.barcode}'),
              if ((foundProduct.brand ?? '').isNotEmpty) ...[
                const SizedBox(height: 8),
                Text('Brand: ${foundProduct.brand}'),
              ],
              if ((foundProduct.nutriScore ?? '').isNotEmpty) ...[
                const SizedBox(height: 8),
                Text('Nutri-Score: ${foundProduct.nutriScore}'),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickAndReadText(ImageSource source) async {
    setState(() {
      _ocrLoading = true;
      _ocrText = '';
    });

    try {
      final xfile = await _picker.pickImage(
        source: source,
        imageQuality: 85,
      );

      if (xfile == null) {
        if (!mounted) return;
        setState(() => _ocrLoading = false);
        return;
      }

      final file = File(xfile.path);
      setState(() => _pickedImage = file);

      final inputImage = InputImage.fromFile(file);
      final result = await _textRecognizer.processImage(inputImage);

      final extracted = result.text.trim();

      if (!mounted) return;
      setState(() {
        _ocrText = extracted.isEmpty ? '(No text found)' : extracted;
        _ocrLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _ocrText = 'OCR Error: $e';
        _ocrLoading = false;
      });
    }
  }

  Widget _barcodeTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: MobileScanner(
                controller: _scannerController,
                onDetect: _onDetect,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Result',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Text(
                  _barcodeDone
                      ? _barcodeValue
                      : 'Position barcode inside the frame',
                  style: const TextStyle(color: Colors.black87),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _barcodeValue.isEmpty
                            ? null
                            : () => _copyToClipboard(_barcodeValue),
                        icon: const Icon(Icons.copy),
                        label: const Text('Copy'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _barcodeValue.isEmpty || _lookupLoading
                            ? null
                            : _useBarcode,
                        icon: _lookupLoading
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.check_circle_outline),
                        label: Text(_lookupLoading ? 'Checking...' : 'Use Barcode'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _scannerController.toggleTorch(),
                  icon: const Icon(Icons.flash_on),
                  label: const Text('Torch'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _barcodeDone ? _resetBarcode : null,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Scan Again'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _textTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          if (_pickedImage != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.file(
                _pickedImage!,
                height: 220,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            )
          else
            Container(
              height: 220,
              width: double.infinity,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: const Text('Pick an image to extract text'),
            ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _ocrLoading
                      ? null
                      : () => _pickAndReadText(ImageSource.gallery),
                  icon: const Icon(Icons.photo),
                  label: const Text('Gallery'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _ocrLoading
                      ? null
                      : () => _pickAndReadText(ImageSource.camera),
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Camera'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: _ocrLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Expanded(
                              child: Text(
                                'Recognized Text',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            IconButton(
                              tooltip: 'Copy',
                              onPressed: _ocrText.trim().isEmpty
                                  ? null
                                  : () => _copyToClipboard(_ocrText),
                              icon: const Icon(Icons.copy),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: (_ocrLoading || _lookupLoading)
                                ? null
                                : _useBarcodeFromText,
                            icon: _lookupLoading
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  )
                                : const Icon(Icons.check_circle_outline),
                            label: Text(_lookupLoading ? 'Checking...' : 'Use Barcode'),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Text(
                              _ocrText.isEmpty
                                  ? 'No text extracted yet.'
                                  : _ocrText,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.transparent,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.black,
          tabs: const [
            Tab(icon: Icon(Icons.qr_code_scanner), text: 'Barcode'),
            Tab(icon: Icon(Icons.text_snippet), text: 'Text'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _barcodeTab(),
          _textTab(),
        ],
      ),
    );
  }
}