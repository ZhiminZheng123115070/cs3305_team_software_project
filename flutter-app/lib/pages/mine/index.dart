import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../api/login.dart';
import '../../controllers/user_info_controller.dart';
import '../../utils/sputils.dart';

const Color _lightGreen = Color(0xFFE8F5E9);
const Color _green = Color(0xFF4CAF50);
const Color _orange = Color(0xFFFF9800);

const String _hideHealthKey = 'hideHealthInfo';

double? _bmi(double? heightM, double? weightKg) {
  if (heightM == null || weightKg == null || heightM <= 0) return null;
  return weightKg / (heightM * heightM);
}

String _bmiStatus(double? bmi) {
  if (bmi == null) return '';
  if (bmi < 18.5) return 'Underweight';
  if (bmi < 25) return 'Normal';
  if (bmi < 30) return 'Overweight';
  return 'Obese';
}

class MineIndex extends StatefulWidget {
  const MineIndex({Key? key}) : super(key: key);

  @override
  State<MineIndex> createState() => _MineIndexState();
}

class _MineIndexState extends State<MineIndex> {
  bool _hideHealthInfo = false;

  @override
  void initState() {
    super.initState();
    _hideHealthInfo = GetStorage().read(_hideHealthKey) ?? false;
    UserInfoController.to.fetchWeightRecords();
  }

  void _toggleHideHealth() {
    setState(() {
      _hideHealthInfo = !_hideHealthInfo;
      GetStorage().write(_hideHealthKey, _hideHealthInfo);
    });
  }

  void _showEditProfile() {
    UserInfoController.to.showEditPopup(requiredAfterLogin: false);
  }

  void _showAccountSecurity() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('Account & Security', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.email_outlined, color: _green, size: 20),
                label: const Text('Bind Google Email'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  side: const BorderSide(color: Colors.grey),
                ),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.phone_outlined, color: _green, size: 20),
                label: const Text('Bind Phone Number'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  side: const BorderSide(color: Colors.grey),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () async {
                  Navigator.pop(ctx);
                  Get.dialog(
                    AlertDialog(
                      title: const Text('Sign Out'),
                      content: const Text('Are you sure you want to sign out?'),
                      actions: [
                        TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
                        TextButton(
                          onPressed: () async {
                            try { await logout(); } catch (_) {}
                            SPUtil().clean();
                            GetStorage().erase();
                            Get.offAllNamed('/login');
                          },
                          child: const Text('Sign Out'),
                        ),
                      ],
                    ),
                  );
                },
                icon: const Icon(Icons.logout, color: Colors.white, size: 20),
                label: const Text('Sign Out'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _orange,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancel'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final c = UserInfoController.to;
      final name = c.nickname ?? GetStorage().read<String>('userName')?.toString() ?? '';
      final gender = c.genderStr ?? '';
      final age = c.age;
      final heightCm = c.heightCm;
      final weightKg = c.weightKg;
      final bmi = c.bmi ?? _bmi(c.heightM, weightKg);
      final bmr = c.bmr;
      c.userInfo.value;

      return Scaffold(
        backgroundColor: _lightGreen,
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Mine', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                      Text('Manage your profile & stats.', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[600])),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8, offset: const Offset(0, 2))],
                    ),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: CustomPaint(
                            size: const Size(double.infinity, 120),
                            painter: _DecorativeCurvesPainter(),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 72,
                                  height: 72,
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(colors: [_orange, Color(0xFFFFCC80)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.person, color: Colors.white, size: 40),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(name.isNotEmpty ? name : '—', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                      const SizedBox(height: 4),
                                      if (gender.isNotEmpty || age != null)
                                        Text(
                                          [if (gender.isNotEmpty) gender, if (age != null) '$age years'].join(' • '),
                                          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                                        ),
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: _showEditProfile,
                                  child: Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(colors: [_orange, Color(0xFFFFCC80)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.edit, color: Colors.white, size: 20),
                                  ),
                                ),
                              ],
                            ),
                            if (!_hideHealthInfo) ...[
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(child: _metricCard('Height', heightCm != null ? '${heightCm.toStringAsFixed(0)} cm' : '—')),
                                  const SizedBox(width: 12),
                                  Expanded(child: _metricCard('Weight', weightKg != null ? '${weightKg.toStringAsFixed(0)} kg' : '—')),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: _metricCard(
                                      'BMI',
                                      bmi != null ? bmi.toStringAsFixed(1) : '—',
                                      subtitle: bmi != null ? _bmiStatus(bmi) : null,
                                    ),
                                  ),
                                ],
                              ),
                              if (bmr != null) ...[
                                const SizedBox(height: 8),
                                Text('BMR: ${bmr.toStringAsFixed(0)} kcal/day', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                              ],
                              const SizedBox(height: 12),
                              TextButton.icon(
                                onPressed: _toggleHideHealth,
                                icon: Icon(_hideHealthInfo ? Icons.visibility : Icons.visibility_off, size: 18, color: _green),
                                label: Text(_hideHealthInfo ? 'Show health info' : 'Hide health info', style: TextStyle(color: _green, fontSize: 13)),
                              ),
                            ] else
                              Padding(
                                padding: const EdgeInsets.only(top: 12),
                                child: TextButton.icon(
                                  onPressed: _toggleHideHealth,
                                  icon: const Icon(Icons.visibility, size: 18, color: _green),
                                  label: const Text('Show health info', style: TextStyle(color: _green, fontSize: 13)),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 6),
                  child: Row(
                    children: [
                      Icon(Icons.show_chart, size: 18, color: Colors.grey[700]),
                      const SizedBox(width: 6),
                      Text('WEEKLY TRACKER', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey[700])),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Obx(() => _buildWeeklyTrackerCard(c)),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 6),
                  child: Text('ACCOUNT', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey[700])),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _sectionCard(
                    context,
                    icon: Icons.lock_outline,
                    title: 'Account & Security',
                    subtitle: 'Password and security settings',
                    onTap: _showAccountSecurity,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 6),
                  child: Text('PREFERENCES', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey[700])),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      _sectionCard(context, icon: Icons.settings_outlined, title: 'General Settings', subtitle: 'App preferences and defaults', onTap: () => Get.toNamed('/home/settings')),
                      const SizedBox(height: 8),
                      _sectionCard(context, icon: Icons.notifications_outlined, title: 'Notification Settings', subtitle: 'Manage your notifications', onTap: () {}),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 6),
                  child: Text('SUPPORT', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey[700])),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      _sectionCard(context, icon: Icons.help_outline, title: 'Help & Support', subtitle: 'Get help and contact support', onTap: () => Get.toNamed('/home/help')),
                      const SizedBox(height: 8),
                      _sectionCard(context, icon: Icons.info_outline, title: 'About', subtitle: 'App version and information', onTap: () => Get.toNamed('/home/about')),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 32, 20, 24),
                  child: Center(
                    child: Column(
                      children: [
                        Text('Version 1.0.0', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                        const SizedBox(height: 4),
                        Text('© 2026 Nutrition Tracker', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _metricCard(String label, String value, {String? subtitle}) {
    return Container(
      height: 88,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          if (subtitle != null && subtitle.isNotEmpty)
            Text(subtitle, style: TextStyle(fontSize: 11, color: _green)),
        ],
      ),
    );
  }

  Widget _buildWeeklyTrackerCard(UserInfoController c) {
    c.weightRecords.length;
    final records = c.weightRecords;
    final currentWeight = c.weightKg;
    final parsed = _parseWeightRecords(records);
    double? monthDiff;
    if (parsed.isNotEmpty && parsed.length >= 2) {
      final now = DateTime.now();
      final thisMonth = parsed.where((r) => r['month'] == now.month && r['year'] == now.year).toList();
      final lastMonth = parsed.where((r) {
        final d = DateTime(r['year']!, r['month']!, 1);
        final prev = DateTime(now.year, now.month - 1);
        return d.year == prev.year && d.month == prev.month;
      }).toList();
      if (thisMonth.isNotEmpty && lastMonth.isNotEmpty) {
        final avgThis = thisMonth.map((e) => e['weight'] as double).reduce((a, b) => a + b) / thisMonth.length;
        final avgLast = lastMonth.map((e) => e['weight'] as double).reduce((a, b) => a + b) / lastMonth.length;
        monthDiff = avgThis - avgLast;
      }
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Current Weight', style: TextStyle(fontSize: 13, color: Colors.grey[600])),
                  Text(currentWeight != null ? '${currentWeight.toStringAsFixed(0)} kg' : '—', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
              if (monthDiff != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: monthDiff <= 0 ? _lightGreen : Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${monthDiff >= 0 ? '+' : ''}${monthDiff.toStringAsFixed(1)}kg this month',
                    style: TextStyle(fontSize: 12, color: monthDiff <= 0 ? _green : Colors.orange.shade800),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 120,
            child: parsed.isEmpty
                ? Center(
                    child: Text(
                      'No weight records yet.\nUpdate your profile to track weight.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                    ),
                  )
                : _WeightLineChart(records: parsed),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _parseWeightRecords(List<Map<String, dynamic>> records) {
    final list = <Map<String, dynamic>>[];
    for (final r in records) {
      final w = r['weight'];
      final created = r['createdAt']?.toString();
      if (w == null || created == null) continue;
      double? weightVal;
      if (w is num) weightVal = w.toDouble();
      else weightVal = double.tryParse(w.toString());
      if (weightVal == null) continue;
      DateTime? dt;
      try {
        dt = DateTime.parse(created);
      } catch (_) {}
      if (dt == null) continue;
      list.add({'weight': weightVal, 'date': dt, 'year': dt.year, 'month': dt.month});
    }
    list.sort((a, b) => (a['date'] as DateTime).compareTo(b['date'] as DateTime));
    return list;
  }

  Widget _sectionCard(BuildContext context, {required IconData icon, required String title, required String subtitle, required VoidCallback onTap}) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(color: _lightGreen, shape: BoxShape.circle),
                child: Icon(icon, color: _green, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
                    Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}

class _DecorativeCurvesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = _lightGreen.withOpacity(0.6)
      ..style = PaintingStyle.fill;
    final path = Path();
    path.moveTo(size.width * 0.7, 0);
    path.quadraticBezierTo(size.width * 0.9, size.height * 0.3, size.width, size.height * 0.5);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width * 0.7, size.height);
    path.quadraticBezierTo(size.width * 0.5, size.height * 0.7, size.width * 0.6, 0);
    path.close();
    canvas.drawPath(path, paint);
    final path2 = Path();
    path2.moveTo(size.width * 0.85, size.height * 0.2);
    path2.quadraticBezierTo(size.width, size.height * 0.4, size.width * 0.95, size.height);
    path2.lineTo(size.width, size.height);
    path2.lineTo(size.width, 0);
    path2.close();
    canvas.drawPath(path2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _WeightLineChart extends StatelessWidget {
  final List<Map<String, dynamic>> records;

  const _WeightLineChart({required this.records});

  @override
  Widget build(BuildContext context) {
    if (records.isEmpty) return const SizedBox.shrink();
    final spots = records.asMap().entries.map((e) => FlSpot(e.key.toDouble(), (e.value['weight'] as num).toDouble())).toList();
    final minY = (records.map((r) => (r['weight'] as num).toDouble()).reduce((a, b) => a < b ? a : b) - 2).clamp(0.0, double.infinity);
    final maxY = (records.map((r) => (r['weight'] as num).toDouble()).reduce((a, b) => a > b ? a : b) + 2);

    return LineChart(
      LineChartData(
        minX: 0,
        maxX: (spots.length - 1).toDouble().clamp(1, double.infinity),
        minY: minY,
        maxY: maxY,
        gridData: FlGridData(show: true, drawVerticalLine: false, horizontalInterval: (maxY - minY) / 4),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 32, getTitlesWidget: (v, _) => Text(v.toStringAsFixed(0), style: TextStyle(fontSize: 10, color: Colors.grey[600])))),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (v, _) {
                final i = v.toInt();
                if (i >= 0 && i < records.length) {
                  final d = records[i]['date'] as DateTime;
                  final week = ((d.day - 1) ~/ 7) + 1;
                  return Padding(padding: const EdgeInsets.only(top: 8), child: Text('W$week', style: TextStyle(fontSize: 10, color: Colors.grey[600])));
                }
                return const SizedBox.shrink();
              },
              reservedSize: 24,
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: _green,
            barWidth: 2.5,
            isStrokeCapRound: true,
            dotData: FlDotData(show: true, getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(radius: 3, color: _green, strokeWidth: 0)),
            belowBarData: BarAreaData(show: true, color: _lightGreen.withOpacity(0.5)),
          ),
        ],
      ),
      duration: const Duration(milliseconds: 200),
    );
  }
}
