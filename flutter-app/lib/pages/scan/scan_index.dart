import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

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
  bool _barcodeDone = false;
  String _barcodeValue = '';

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

  // Pause/resume camera cleanly when app backgrounds/foregrounds
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Only manage camera when on Barcode tab
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

  // ---------- Barcode ----------
  void _onDetect(BarcodeCapture capture) {
    if (_barcodeDone) return;

    final barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;

    final raw = barcodes.first.rawValue;
    if (raw == null || raw.trim().isEmpty) return;

    final now = DateTime.now();

    // Debounce: ignore if same barcode within 1 second
    final isSame = raw == _lastBarcode;
    final tooSoon = now.difference(_lastScanAt).inMilliseconds < 1000;
    if (isSame && tooSoon) return;

    _lastBarcode = raw;
    _lastScanAt = now;

    setState(() {
      _barcodeDone = true;
      _barcodeValue = raw;
    });

    // Stop camera after scan (safe call)
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

  // Return barcode back to previous page (Cart can await it)
  void _useBarcode() {
    if (_barcodeValue.trim().isEmpty) return;
    Navigator.of(context).pop(_barcodeValue.trim());
  }

  // ---------- OCR ----------
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
                  "Result",
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
                        label: const Text("Copy"),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _barcodeValue.isEmpty ? null : _useBarcode,
                        icon: const Icon(Icons.check_circle_outline),
                        label: const Text("Use Barcode"),
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
                                "Recognized Text",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            IconButton(
                              tooltip: "Copy",
                              onPressed: _ocrText.trim().isEmpty
                                  ? null
                                  : () => _copyToClipboard(_ocrText),
                              icon: const Icon(Icons.copy),
                            ),
                          ],
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

