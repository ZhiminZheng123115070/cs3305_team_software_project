import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../api/login.dart';
import '../../utils/sputils.dart';

const Color _lightGreen = Color(0xFFE8F5E9);
const Color _green = Color(0xFF4CAF50);
const Color _orange = Color(0xFFFF9800);

double? _bmi(double? heightM, double? weightKg) {
  if (heightM == null || weightKg == null || heightM <= 0) return null;
  return weightKg / (heightM * heightM);
}

/// Profile data is in-memory only. TODO: persist to backend when API is ready.
class MineIndex extends StatefulWidget {
  const MineIndex({Key? key}) : super(key: key);

  @override
  State<MineIndex> createState() => _MineIndexState();
}

class _MineIndexState extends State<MineIndex> {
  String? _name;
  String? _gender;
  int? _age;
  double? _heightM;
  double? _weightKg;

  static const List<String> _genderOptions = ['Male', 'Female'];

  void _showEditProfile() {
    final nameCtrl = TextEditingController(text: _name ?? GetStorage().read<String>('userName')?.toString() ?? '');
    final ageCtrl = TextEditingController(text: _age?.toString() ?? '');
    final heightCtrl = TextEditingController(text: _heightM?.toString() ?? '');
    final weightCtrl = TextEditingController(text: _weightKg?.toString() ?? '');
    String? selectedGender = _gender;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: const Text('Edit profile'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Name')),
                  DropdownButtonFormField<String>(
                    value: selectedGender != null && _genderOptions.contains(selectedGender) ? selectedGender : null,
                    decoration: const InputDecoration(labelText: 'Gender'),
                    items: [
                      const DropdownMenuItem(value: null, child: Text('—')),
                      ..._genderOptions.map((s) => DropdownMenuItem(value: s, child: Text(s))),
                    ],
                    onChanged: (v) => setDialogState(() => selectedGender = v),
                  ),
                  TextField(controller: ageCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Age')),
                  TextField(controller: heightCtrl, keyboardType: const TextInputType.numberWithOptions(decimal: true), decoration: const InputDecoration(labelText: 'Height (m)')),
                  TextField(controller: weightCtrl, keyboardType: const TextInputType.numberWithOptions(decimal: true), decoration: const InputDecoration(labelText: 'Weight (kg)')),
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
              TextButton(
                onPressed: () {
                  setState(() {
                    _name = nameCtrl.text.trim().isEmpty ? null : nameCtrl.text.trim();
                    _gender = selectedGender;
                    _age = int.tryParse(ageCtrl.text);
                    _heightM = double.tryParse(heightCtrl.text.replaceAll(',', '.'));
                    _weightKg = double.tryParse(weightCtrl.text.replaceAll(',', '.'));
                  });
                  Navigator.pop(ctx);
                },
                child: const Text('Save'),
              ),
            ],
          );
        },
      ),
    );
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
    final name = _name?.isNotEmpty == true ? _name! : (GetStorage().read<String>('userName')?.toString() ?? '');
    final gender = _gender ?? '';
    final age = _age;
    final heightM = _heightM;
    final weightKg = _weightKg;
    final bmi = _bmi(heightM, weightKg);

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
                    Text('Manage your preferences', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[600])),
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
                  child: Row(
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
                            Text(name?.isNotEmpty == true ? name! : '—', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 6),
                            if (gender.isNotEmpty) _chip('$gender', Icons.wc),
                            if (age != null) _chip('$age yrs', Icons.cake),
                            if (heightM != null) _chip('${heightM.toStringAsFixed(2)} m', Icons.height),
                            if (weightKg != null) _chip('${weightKg.toStringAsFixed(1)} kg', Icons.monitor_weight),
                            if (bmi != null) _chip('BMI ${bmi.toStringAsFixed(1)} kg/m²', Icons.analytics),
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
                ),
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
  }

  Widget _chip(String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(icon, size: 14, color: _green),
          const SizedBox(width: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: _lightGreen, borderRadius: BorderRadius.circular(12)),
            child: Text(label, style: const TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
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
