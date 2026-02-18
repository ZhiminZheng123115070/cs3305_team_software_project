import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../api/user_info.dart';

/// GetX controller for user health info (nickname, gender, age, height, weight).
/// Uses backend UserInfoController API; shows popup when user info is empty.
class UserInfoController extends GetxController {
  static UserInfoController get to => Get.find<UserInfoController>();

  final Rx<Map<String, dynamic>?> userInfo = Rx<Map<String, dynamic>?>(null);
  final RxBool loading = false.obs;
  final RxBool saving = false.obs;

  /// Backend uses height in cm; mine page uses m. Convert: heightM * 100 = heightCm
  static double? cmToM(dynamic v) {
    if (v == null) return null;
    if (v is num) return (v.toDouble() / 100);
    final d = double.tryParse(v.toString());
    return d != null ? d / 100 : null;
  }

  static num? mToCm(double? v) {
    if (v == null) return null;
    return v * 100;
  }

  /// Backend gender: 0=Male, 1=Female
  static String? genderFromBackend(dynamic v) {
    if (v == null) return null;
    if (v == 0 || v == '0') return 'Male';
    if (v == 1 || v == '1') return 'Female';
    return null;
  }

  static int? genderToBackend(String? v) {
    if (v == null || v.isEmpty) return null;
    if (v == 'Male') return 0;
    if (v == 'Female') return 1;
    return null;
  }

  String? get nickname => userInfo.value?['nickname']?.toString();
  String? get genderStr => genderFromBackend(userInfo.value?['gender']);
  int? get age {
    final v = userInfo.value?['age'];
    if (v == null) return null;
    if (v is int) return v;
    return int.tryParse(v.toString());
  }

  double? get heightM => cmToM(userInfo.value?['height']);
  double? get weightKg {
    final v = userInfo.value?['weight'];
    if (v == null) return null;
    if (v is num) return v.toDouble();
    return double.tryParse(v.toString());
  }

  double? get bmi {
    final v = userInfo.value?['bmi'];
    if (v == null) return null;
    if (v is num) return v.toDouble();
    return double.tryParse(v.toString());
  }

  double? get bmr {
    final v = userInfo.value?['bmr'];
    if (v == null) return null;
    if (v is num) return v.toDouble();
    return double.tryParse(v.toString());
  }

  /// Height in cm for display
  double? get heightCm {
    final v = userInfo.value?['height'];
    if (v == null) return null;
    if (v is num) return v.toDouble();
    return double.tryParse(v.toString());
  }

  final RxList<Map<String, dynamic>> weightRecords = <Map<String, dynamic>>[].obs;

  Future<void> fetchWeightRecords() async {
    try {
      final resp = await getWeightRecords();
      final data = resp.data;
      if (data is Map && data['code'] == 200) {
        final list = data['data'];
        if (list is List) {
          weightRecords.value = list
              .map((e) => e is Map ? Map<String, dynamic>.from(e as Map) : <String, dynamic>{})
              .toList();
          return;
        }
      }
      weightRecords.value = [];
    } catch (_) {
      weightRecords.value = [];
    }
  }

  bool get isEmpty {
    final u = userInfo.value;
    if (u == null) return true;
    final nick = (u['nickname'] as String?)?.trim();
    final g = u['gender'];
    final a = u['age'];
    final h = u['height'];
    final w = u['weight'];
    return (nick == null || nick.isEmpty) &&
        (g == null) &&
        (a == null) &&
        (h == null) &&
        (w == null);
  }


  Future<void> fetchUserInfo() async {
    loading.value = true;
    try {
      final resp = await getUserInfo();
      final data = resp.data;
      if (data is Map && data['code'] == 200) {
        final d = data['data'];
        userInfo.value = d is Map<String, dynamic> ? Map<String, dynamic>.from(d) : null;
      } else {
        userInfo.value = null;
      }
    } catch (_) {
      userInfo.value = null;
    } finally {
      loading.value = false;
    }
  }

  Future<bool> saveUserInfo({
    String? nickname,
    String? genderStr,
    int? age,
    double? heightM,
    double? weightKg,
  }) async {
    saving.value = true;
    try {
      final body = <String, dynamic>{
        if (nickname != null && nickname.isNotEmpty) 'nickname': nickname,
        if (genderStr != null) 'gender': genderToBackend(genderStr),
        if (age != null) 'age': age,
        if (heightM != null) 'height': mToCm(heightM),
        if (weightKg != null) 'weight': weightKg,
      };
      final resp = await saveUserInfoApi(body);
      final data = resp.data;
      if (data is Map && data['code'] == 200) {
        final d = data['data'];
        userInfo.value = d is Map<String, dynamic> ? Map<String, dynamic>.from(d) : null;
        fetchWeightRecords();
        return true;
      }
      return false;
    } catch (_) {
      return false;
    } finally {
      saving.value = false;
    }
  }

  /// Show popup for editing user info. If [requiredAfterLogin] is true, user must fill and save.
  void showEditPopup({bool requiredAfterLogin = false}) {
    final nameCtrl = TextEditingController(
      text: nickname ?? GetStorage().read<String>('userName')?.toString() ?? '',
    );
    final ageCtrl = TextEditingController(text: age?.toString() ?? '');
    final heightCtrl = TextEditingController(text: heightM?.toString() ?? '');
    final weightCtrl = TextEditingController(text: weightKg?.toString() ?? '');
    final selectedGender = Rx<String?>(genderStr);
    const genderOptions = ['Male', 'Female'];

    Get.dialog(
      barrierDismissible: !requiredAfterLogin,
      PopScope(
        canPop: !requiredAfterLogin,
        child: AlertDialog(
          title: Text(requiredAfterLogin ? 'Complete Your Profile' : 'Edit profile'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                Obx(() => DropdownButtonFormField<String>(
                      value: selectedGender.value != null && genderOptions.contains(selectedGender.value)
                          ? selectedGender.value
                          : null,
                      decoration: const InputDecoration(labelText: 'Gender'),
                      items: [
                        const DropdownMenuItem(value: null, child: Text('—')),
                        ...genderOptions.map((s) => DropdownMenuItem(value: s, child: Text(s))),
                      ],
                      onChanged: (v) => selectedGender.value = v,
                    )),
                TextField(
                  controller: ageCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Age'),
                ),
                TextField(
                  controller: heightCtrl,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(labelText: 'Height (m)'),
                ),
                TextField(
                  controller: weightCtrl,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(labelText: 'Weight (kg)'),
                ),
              ],
            ),
          ),
          actions: [
            if (!requiredAfterLogin)
              TextButton(
                onPressed: () => Get.back(),
                child: const Text('Cancel'),
              ),
            TextButton(
              onPressed: () async {
                final name = nameCtrl.text.trim();
                if (name.isEmpty) {
                  Get.snackbar('', 'Please enter your name');
                  return;
                }
                final ageVal = int.tryParse(ageCtrl.text);
                final heightVal = double.tryParse(heightCtrl.text.replaceAll(',', '.'));
                final weightVal = double.tryParse(weightCtrl.text.replaceAll(',', '.'));

                final ok = await saveUserInfo(
                  nickname: name,
                  genderStr: selectedGender.value,
                  age: ageVal,
                  heightM: heightVal,
                  weightKg: weightVal,
                );
                if (ok) {
                  Get.back();
                  Get.snackbar('', 'Saved');
                } else {
                  Get.snackbar('', 'Save failed');
                }
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  /// Check if user info is empty and show popup (after login). Call after navigating to home.
  void checkAndShowPopupIfEmpty() {
    fetchUserInfo().then((_) {
      if (isEmpty) {
        showEditPopup(requiredAfterLogin: true);
      }
    });
  }
}
