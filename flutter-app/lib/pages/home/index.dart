import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../api/product.dart';
import '../../api/user_info.dart';
import '../../controllers/user_info_controller.dart';
import '../../models/storage_item_model.dart';
import '../../utils/sputils.dart';

const String kDailyCalorieTargetKey = 'daily_calorie_target';
const int kDefaultCalorieTarget = 2000;

const Color _lightGreen = Color(0xFFE8F5E9);
const Color _green = Color(0xFF4CAF50);
const Color _orange = Color(0xFFFF9800);
const Color _red = Color(0xFFE53935);

class HomeIndex extends StatefulWidget {
  const HomeIndex({Key? key}) : super(key: key);

  @override
  State<HomeIndex> createState() => _HomeIndexState();
}

class _HomeIndexState extends State<HomeIndex> {
  DateTime _selectedDate = DateTime.now();
  List<StorageItem> _storageItems = [];
  bool _loadingStorage = false;

  /// Diet log from API (consumed history)
  List<Map<String, dynamic>> _dietLogItems = [];
  bool _loadingDietLog = false;

  /// Daily intake from API (energyKcal, targetKcal, proteins, carbohydrates, fat)
  Map<String, dynamic>? _dailyData;
  bool _loadingDaily = false;

  int get _calorieTarget => SPUtil().get<int>(kDailyCalorieTargetKey) ?? kDefaultCalorieTarget;

  /// Diet log entries for selected date (filtered by eatenAt)
  List<Map<String, dynamic>> get _consumedItems {
    final items = <Map<String, dynamic>>[];
    for (final e in _dietLogItems) {
      final eaten = e['eatenAt']?.toString();
      if (eaten == null) continue;
      DateTime? dt;
      try {
        dt = DateTime.parse(eaten);
      } catch (_) {}
      if (dt != null &&
          dt.year == _selectedDate.year &&
          dt.month == _selectedDate.month &&
          dt.day == _selectedDate.day) {
        items.add(e);
      }
    }
    return items;
  }

  /// Fallback from diet log when daily-calories API has no data
  double get _fallbackCalories => _consumedItems.fold(0.0, (s, e) => s + ((e['energyKcal'] ?? 0) as num).toDouble());
  double get _fallbackProtein => _consumedItems.fold(0.0, (s, e) => s + ((e['proteins'] ?? 0) as num).toDouble());
  double get _fallbackCarbs => _dailyData?['carbohydrates'] != null ? (_dailyData!['carbohydrates'] as num).toDouble() : 0.0;
  double get _fallbackFat => _dailyData?['fat'] != null ? (_dailyData!['fat'] as num).toDouble() : 0.0;

  /// Display values: prefer API daily-calories, else fallback
  double get _displayCalories => _dailyData?['energyKcal'] != null ? (_dailyData!['energyKcal'] as num).toDouble() : _fallbackCalories;
  double get _targetKcal {
    if (_dailyData?['targetKcal'] != null) return (_dailyData!['targetKcal'] as num).toDouble();
    return (UserInfoController.to.bmr ?? _calorieTarget).toDouble();
  }
  double get _displayProtein => _dailyData?['proteins'] != null ? (_dailyData!['proteins'] as num).toDouble() : _fallbackProtein;
  double get _displayCarbs => _dailyData?['carbohydrates'] != null ? (_dailyData!['carbohydrates'] as num).toDouble() : _fallbackCarbs;
  double get _displayFat => _dailyData?['fat'] != null ? (_dailyData!['fat'] as num).toDouble() : _fallbackFat;

  Future<void> _fetchDailyCalories() async {
    if (!mounted) return;
    setState(() => _loadingDaily = true);
    try {
      final dateStr = '${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}';
      final resp = await getDailyCalories(dateStr);
      final data = resp.data;
      if (data is Map && data['code'] == 200) {
        final d = data['data'];
        _dailyData = d is Map ? Map<String, dynamic>.from(d) : null;
      } else {
        _dailyData = null;
      }
    } catch (_) {
      _dailyData = null;
    } finally {
      if (mounted) setState(() => _loadingDaily = false);
    }
  }

  Future<void> _fetchDietLog() async {
    if (!mounted) return;
    setState(() => _loadingDietLog = true);
    try {
      final resp = await getDietLog();
      final data = resp.data;
      if (data is Map && data['code'] == 200) {
        final list = data['data'];
        if (list is List) {
          _dietLogItems = list.map((e) => e is Map ? Map<String, dynamic>.from(e) : <String, dynamic>{}).toList();
        } else {
          _dietLogItems = [];
        }
      } else {
        _dietLogItems = [];
      }
    } catch (_) {
      _dietLogItems = [];
    } finally {
      if (mounted) setState(() => _loadingDietLog = false);
    }
  }

  Future<void> _fetchStorage() async {
    setState(() => _loadingStorage = true);
    try {
      final resp = await getStorageList(pageNum: 1, pageSize: 200);
      final data = resp.data;
      if (data is Map && data['code'] == 200) {
        dynamic list = data['data'];
        if (list is List) {
          _storageItems = list.map((e) => e is Map ? StorageItem.fromJson(Map<String, dynamic>.from(e)) : null).whereType<StorageItem>().toList();
        } else if (list is Map && (list['list'] != null || list['rows'] != null)) {
          final rows = list['list'] ?? list['rows'] ?? [];
          _storageItems = (rows as List).map((e) => e is Map ? StorageItem.fromJson(Map<String, dynamic>.from(e)) : null).whereType<StorageItem>().toList();
        } else {
          _storageItems = [];
        }
      } else {
        _storageItems = [];
      }
    } catch (_) {
      _storageItems = [];
    } finally {
      if (mounted) setState(() => _loadingStorage = false);
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchStorage();
    _fetchDietLog();
    _fetchDailyCalories();
  }

  List<DateTime> _weekDays() {
    final weekday = _selectedDate.weekday;
    final start = _selectedDate.subtract(Duration(days: weekday - 1));
    return List.generate(7, (i) => start.add(Duration(days: i)));
  }

  void _showWhatDidYouEat() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        height: MediaQuery.of(ctx).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 12, 12),
              child: Row(
                children: [
                  const Text('What did you eat?', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(ctx),
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: _lightGreen, shape: BoxShape.circle),
                      child: Icon(Icons.close, size: 20, color: Colors.grey[700]),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _storageItems.length,
                itemBuilder: (_, i) {
                  final item = _storageItems[i];
                  return _buildStorageItemCard(ctx, item);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStorageItemCard(BuildContext context, StorageItem item) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        _showHowMuchModal(item);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6, offset: const Offset(0, 2))],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: item.imageUrl != null && item.imageUrl!.isNotEmpty
                  ? Image.network(item.imageUrl!, width: 56, height: 56, fit: BoxFit.cover, errorBuilder: (_, __, ___) => _placeholderImage())
                  : _placeholderImage(),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  if (item.brand != null) Text(item.brand!, style: TextStyle(fontSize: 13, color: Colors.grey[600])),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: _lightGreen, borderRadius: BorderRadius.circular(20)),
              child: Text('${item.percentLeft}% left', style: TextStyle(fontSize: 12, color: Colors.grey[800])),
            ),
            const SizedBox(width: 8),
            Icon(Icons.chevron_right, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }

  Widget _placeholderImage() => Container(width: 56, height: 56, color: Colors.grey.shade200, child: Icon(Icons.image_not_supported, color: Colors.grey[400]));

  void _showHowMuchModal(StorageItem item) {
    final totalKcal = (item.energyKcal ?? 0).toDouble();
    final totalProtein = (item.proteins ?? 0).toDouble();
    final totalCarbs = (item.carbohydrates ?? 0).toDouble();
    final totalFat = (item.fat ?? 0).toDouble();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _HowMuchModal(
        item: item,
        totalKcal: totalKcal,
        totalProtein: totalProtein,
        totalCarbs: totalCarbs,
        totalFat: totalFat,
        onAdd: (portion) async {
          try {
            await addDietLog(item.storageId, portion);
            _fetchStorage();
            _fetchDietLog();
            _fetchDailyCalories();
          } catch (_) {}
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final weekDays = _weekDays();
    // Sun=0, Mon=1, Tue=2, Wed=3, Thu=4, Fri=5, Sat=6. Dart weekday: 1=Mon..7=Sun
    const dayLabels = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];

    return Scaffold(
      backgroundColor: _lightGreen,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Today's Intake", style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                  Text('Track your nutrition.', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[600])),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8, offset: const Offset(0, 2))],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: weekDays.map((d) {
                    final isSelected = d.day == _selectedDate.day && d.month == _selectedDate.month && d.year == _selectedDate.year;
                    return GestureDetector(
                      onTap: () => setState(() {
                        _selectedDate = d;
                        _fetchDailyCalories();
                      }),
                      child: Column(
                        children: [
                          Text(dayLabels[d.weekday % 7], style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: isSelected ? _orange : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text('${d.day}', style: TextStyle(fontWeight: FontWeight.w600, color: isSelected ? Colors.white : Colors.black87)),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _lightGreen,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: _green.withOpacity(0.4)),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6, offset: const Offset(0, 2))],
                ),
                child: Row(
                  children: [
                    _buildCalorieCircle(),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        children: [
                          _macroRow('Protein', _displayProtein, 50.0),
                          const SizedBox(height: 8),
                          _macroRow('Carbs', _displayCarbs, 250.0),
                          const SizedBox(height: 8),
                          _macroRow('Fat', _displayFat, 65.0),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 6),
              child: Text('Consumed History', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey[800])),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _consumedItems.isEmpty
                    ? Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid),
                        ),
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: CustomPaint(
                                painter: _DottedBorderPainter(),
                              ),
                            ),
                            Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.restaurant, size: 48, color: _lightGreen),
                                  const SizedBox(height: 12),
                                  Text('No food logged today', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey[800])),
                                  const SizedBox(height: 4),
                                  Text('Tap the + button to track.', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.only(bottom: 80),
                        itemCount: _consumedItems.length,
                        itemBuilder: (_, i) {
                          final item = _consumedItems[i];
                          final rate = (item['consumptionRate'] ?? 0) as num;
                          final consumedPct = (rate * 100).round();
                          final calories = (item['energyKcal'] ?? 0) as num;
                          final imageUrl = item['imageUrl']?.toString();
                          final name = item['name']?.toString() ?? '—';
                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 6, offset: const Offset(0, 2))],
                            ),
                            child: Row(
                              children: [
                                if (imageUrl != null && imageUrl.isNotEmpty)
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(imageUrl, width: 48, height: 48, fit: BoxFit.cover, errorBuilder: (_, __, ___) => _placeholderImage()),
                                  )
                                else
                                  _placeholderImage(),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
                                      Text('$consumedPct% consumed • ${(calories as num).toStringAsFixed(1)} kcal', style: TextStyle(fontSize: 12, color: _green)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showWhatDidYouEat,
        backgroundColor: _green,
        child: const Icon(Icons.add, color: Colors.white, size: 32),
      ),
    );
  }

  Widget _buildCalorieCircle() {
    final target = _targetKcal;
    final intake = _displayCalories;
    final progress = target > 0 ? (intake / target).clamp(0.0, 1.0) : 0.0;
    final isOver = intake > target;
    final ringColor = isOver ? _red : _green;

    return SizedBox(
      width: 96,
      height: 96,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 96,
            height: 96,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 6,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation(ringColor),
            ),
          ),
          Container(
            width: 84,
            height: 84,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: _lightGreen, width: 2),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 6)],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(intake.toStringAsFixed(1), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                Text('kcal', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _macroRow(String label, double value, double typicalMax) {
    final progress = typicalMax > 0 ? (value / typicalMax).clamp(0.0, 1.0) : 0.0;
    return Row(
      children: [
        SizedBox(width: 60, child: Text(label, style: TextStyle(fontSize: 13, color: Colors.grey[700]))),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: Colors.grey.shade300,
              valueColor: const AlwaysStoppedAnimation(_green),
            ),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(width: 40, child: Text('${value.toStringAsFixed(1)}g', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600))),
      ],
    );
  }
}

class _HowMuchModal extends StatefulWidget {
  final StorageItem item;
  final double totalKcal;
  final double totalProtein;
  final double totalCarbs;
  final double totalFat;
  final void Function(double portion) onAdd;

  const _HowMuchModal({
    required this.item,
    required this.totalKcal,
    required this.totalProtein,
    required this.totalCarbs,
    required this.totalFat,
    required this.onAdd,
  });

  @override
  State<_HowMuchModal> createState() => _HowMuchModalState();
}

class _HowMuchModalState extends State<_HowMuchModal> {
  double _portion = 0.5;

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final totalKcal = widget.totalKcal;

    final portionPct = ((_portion * 100).round() / 5).round() * 5;

    return Container(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back),
                    padding: EdgeInsets.zero,
                  ),
                  const Expanded(child: Text('How much?', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: Colors.grey.shade200, shape: BoxShape.circle),
                      child: Icon(Icons.close, size: 18, color: Colors.grey[700]),
                    ),
                    padding: EdgeInsets.zero,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Center(
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: item.imageUrl != null && item.imageUrl!.isNotEmpty
                          ? Image.network(item.imageUrl!, width: 120, height: 120, fit: BoxFit.cover, errorBuilder: (_, __, ___) => _placeholderImage())
                          : _placeholderImage(),
                    ),
                    const SizedBox(height: 8),
                    Text(item.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    if (item.brand != null) Text(item.brand!, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Available in pantry', style: TextStyle(fontSize: 14, color: Colors.grey[700])),
                        Text('${item.percentLeft}% left', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: item.consumption,
                        minHeight: 8,
                        backgroundColor: Colors.grey.shade300,
                        valueColor: const AlwaysStoppedAnimation(_green),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text('Portion Consumed: $portionPct%', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              SliderTheme(
                data: SliderThemeData(
                  activeTrackColor: _orange,
                  thumbColor: _orange,
                  overlayColor: _orange.withOpacity(0.2),
                ),
                child: Slider(
                  value: _portion,
                  min: 0.05,
                  max: 1.0,
                  divisions: 19,
                  onChanged: (v) => setState(() => _portion = v),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Small Bite', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                  Text('Half', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                  Text('Finish It', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _portionButton('1/4 (25%)', 0.25),
                  const SizedBox(width: 8),
                  _portionButton('1/2 (50%)', 0.5),
                  const SizedBox(width: 8),
                  Expanded(child: _portionButton('All Remaining', 1.0)),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _orange.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Calories to add', style: TextStyle(fontSize: 14, color: Colors.grey[800])),
                    Text('${(totalKcal * _portion).toStringAsFixed(1)} kcal', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _orange)),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    widget.onAdd(_portion);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Add to Log'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _placeholderImage() => Container(width: 120, height: 120, color: Colors.grey.shade200, child: Icon(Icons.image_not_supported, color: Colors.grey[400]));

  Widget _portionButton(String label, double value) {
    final selected = (_portion - value).abs() < 0.01;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _portion = value),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected ? _lightGreen : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: selected ? _green : Colors.grey.shade300),
          ),
          child: Text(label, textAlign: TextAlign.center, style: TextStyle(fontSize: 12, fontWeight: selected ? FontWeight.w600 : FontWeight.normal, color: selected ? _green : Colors.grey[800])),
        ),
      ),
    );
  }
}

class _DottedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.shade300
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    const dashWidth = 8;
    const dashSpace = 6;
    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(Rect.fromLTWH(2, 2, size.width - 4, size.height - 4), const Radius.circular(14)));
    Path dashedPath = Path();
    for (final metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        final length = (distance + dashWidth > metric.length) ? metric.length - distance : dashWidth.toDouble();
        dashedPath.addPath(metric.extractPath(distance, distance + length), Offset.zero);
        distance += length + dashSpace;
      }
    }
    canvas.drawPath(dashedPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
