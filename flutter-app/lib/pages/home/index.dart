import 'package:flutter/material.dart';

import 'package:ruoyi_app/utils/sputils.dart';

/// Storage key for daily calorie target (set in Mine / Settings).
const String kDailyCalorieTargetKey = 'daily_calorie_target';
const int kDefaultCalorieTarget = 2000;

/// Time-based greeting: 6-12 morning, 12-18 afternoon, 18-6 evening.
String _greeting() {
  final h = DateTime.now().hour;
  if (h >= 6 && h < 12) return 'Good morning';
  if (h >= 12 && h < 18) return 'Good afternoon';
  return 'Good evening';
}

const List<String> _nutrientTypes = ['fat', 'carbohydrates', 'fiber', 'protein', 'salt'];

class HomeIndex extends StatefulWidget {
  const HomeIndex({Key? key}) : super(key: key);

  @override
  State<HomeIndex> createState() => _HomeIndexState();
}

class _HomeIndexState extends State<HomeIndex> {
  int _breakfast = 0;
  int _lunch = 0;
  int _dinner = 0;
  int _other = 0;
  final List<String> _nutrients = [];

  int get _calorieTarget => SPUtil().get<int>(kDailyCalorieTargetKey) ?? kDefaultCalorieTarget;
  int get _totalCalories => _breakfast + _lunch + _dinner + _other;
  int get _progressPercent => _calorieTarget > 0 ? ((_totalCalories / _calorieTarget) * 100).round() : 0;
  bool get _isOverTarget => _calorieTarget > 0 && _totalCalories > _calorieTarget;

  /// Week runs Sunday (0) to Saturday (6). Sunday is the first day.
  List<DateTime> _weekDays() {
    final now = DateTime.now();
    final weekday = now.weekday;
    final start = now.subtract(Duration(days: weekday % 7));
    return List.generate(7, (i) => start.add(Duration(days: i)));
  }

  void _showCalorieEdit() {
    final b = TextEditingController(text: _breakfast.toString());
    final l = TextEditingController(text: _lunch.toString());
    final d = TextEditingController(text: _dinner.toString());
    final o = TextEditingController(text: _other.toString());
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit daily calories'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: b,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Breakfast (kcal)'),
              ),
              TextField(
                controller: l,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Lunch (kcal)'),
              ),
              TextField(
                controller: d,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Dinner (kcal)'),
              ),
              TextField(
                controller: o,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Other (kcal)'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _breakfast = int.tryParse(b.text) ?? 0;
                _lunch = int.tryParse(l.text) ?? 0;
                _dinner = int.tryParse(d.text) ?? 0;
                _other = int.tryParse(o.text) ?? 0;
              });
              Navigator.pop(ctx);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showAddNutrient() {
    final options = _nutrientTypes.where((t) => !_nutrients.contains(t)).toList();
    if (options.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All nutrient types already added')),
      );
      return;
    }
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add nutrient'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: options
              .map((t) => ListTile(
                    title: Text(t),
                    onTap: () {
                      setState(() => _nutrients.add(t));
                      Navigator.pop(ctx);
                    },
                  ))
              .toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final weekDays = _weekDays();
    const lightGreen = Color(0xFFE8F5E9);
    const green = Color(0xFF4CAF50);
    const orange = Color(0xFFFF9800);

    return Scaffold(
      backgroundColor: lightGreen,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Hi there,', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.black87)),
              const SizedBox(height: 4),
              Text(_greeting(), style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8, offset: const Offset(0, 2))],
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                      child: Row(
                        children: [
                          Text('This Week', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 0, 8, 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: weekDays.map((d) {
                          final isSelected = d.day == now.day && d.month == now.month && d.year == now.year;
                          final dayLabels = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
                          return Column(
                              children: [
                                Text(dayLabels[d.weekday % 7], style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: isSelected ? orange : Colors.transparent,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text('${d.day}', style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: isSelected ? Colors.white : Colors.black87,
                                  )),
                                ),
                              ],
                            );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: green.withOpacity(0.35),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: green.withOpacity(0.5), width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Daily Calories', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
                        IconButton(
                          icon: Icon(Icons.edit, color: green, size: 22),
                          onPressed: _showCalorieEdit,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text('$_totalCalories / $_calorieTarget', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(width: 8),
                        Text('kcal', style: TextStyle(fontSize: 14, color: Colors.grey[700])),
                        const Spacer(),
                        SizedBox(
                          width: 44,
                          height: 44,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              CircularProgressIndicator(
                                value: _calorieTarget > 0
                                    ? (_totalCalories / _calorieTarget).clamp(0.0, 1.0)
                                    : 0,
                                strokeWidth: 4,
                                backgroundColor: Colors.white54,
                                valueColor: AlwaysStoppedAnimation<Color>(_isOverTarget ? orange : green),
                              ),
                              Text('$_progressPercent%', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _mealChip(Icons.free_breakfast, 'Breakfast', _breakfast),
                        const SizedBox(width: 8),
                        _mealChip(Icons.restaurant, 'Lunch', _lunch),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _mealChip(Icons.nightlight_round, 'Dinner', _dinner),
                        const SizedBox(width: 8),
                        _mealChip(Icons.cake, 'Other', _other),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8, offset: const Offset(0, 2))],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Nutrients', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
                        IconButton(
                          icon: const Icon(Icons.add_circle, color: orange, size: 28),
                          onPressed: _showAddNutrient,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                        ),
                      ],
                    ),
                    if (_nutrients.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Center(
                          child: Text('No nutrients yet. Tap + to add.', style: TextStyle(color: Colors.grey[600], fontSize: 14)),
                        ),
                      )
                    else
                      ..._nutrients.map((n) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Icon(_nutrientIcon(n), size: 20, color: green),
                                  const SizedBox(width: 8),
                                  Text(n, style: const TextStyle(fontWeight: FontWeight.w500)),
                                  const Spacer(),
                                  IconButton(
                                    icon: const Icon(Icons.close, size: 18),
                                    onPressed: () => setState(() => _nutrients.remove(n)),
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                                  ),
                                ],
                              ),
                            ),
                          )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _mealChip(IconData icon, String label, int kcal) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: Colors.grey[700]),
            const SizedBox(width: 6),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[700])),
                  Text('$kcal kcal', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _nutrientIcon(String type) {
    switch (type) {
      case 'fat': return Icons.opacity;
      case 'carbohydrates': return Icons.grain;
      case 'fiber': return Icons.eco;
      case 'protein': return Icons.set_meal;
      case 'salt': return Icons.water_drop;
      default: return Icons.restaurant;
    }
  }
}
