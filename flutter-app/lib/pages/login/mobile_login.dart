import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../api/login.dart';

/// Mobile (SMS) login page: phone input, send code, code input, login.
class MobileLoginPage extends StatefulWidget {
  const MobileLoginPage({Key? key}) : super(key: key);

  @override
  State<MobileLoginPage> createState() => _MobileLoginPageState();
}

class _MobileLoginPageState extends State<MobileLoginPage> {
  final _phoneController = TextEditingController();
  final _codeController = TextEditingController();
  bool _sending = false;
  bool _loggingIn = false;
  String? _sendTip;

  @override
  void dispose() {
    _phoneController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _sendCode() async {
    final phone = _phoneController.text.trim();
    if (phone.isEmpty) {
      Get.snackbar('Tip', 'Please enter phone number');
      return;
    }
    setState(() {
      _sending = true;
      _sendTip = null;
    });
    try {
      final resp = await sendSmsCode({'phone': phone});
      final data = resp.data;
      if (data is Map && data['code'] == 200) {
        setState(() => _sendTip = 'Code sent');
      } else {
        setState(() => _sendTip = data is Map ? (data['msg'] ?? 'Send failed') : 'Send failed');
      }
    } catch (e) {
      setState(() => _sendTip = 'Error: $e');
    } finally {
      setState(() => _sending = false);
    }
  }

  Future<void> _login() async {
    final phone = _phoneController.text.trim();
    final code = _codeController.text.trim();
    if (phone.isEmpty) {
      Get.snackbar('Tip', 'Please enter phone number');
      return;
    }
    if (code.isEmpty) {
      Get.snackbar('Tip', 'Please enter verification code');
      return;
    }
    setState(() => _loggingIn = true);
    try {
      final resp = await mobileLogin({'phone': phone, 'code': code});
      final data = resp.data;
      if (data is Map && data['code'] == 200) {
        Get.offAllNamed('/home');
      } else {
        Get.snackbar('Login failed', data is Map ? (data['msg'] ?? '') : 'Unknown error');
      }
    } catch (e) {
      Get.snackbar('Error', '$e');
    } finally {
      setState(() => _loggingIn = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mobile Login', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Phone number',
                hintText: 'Please enter phone number',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _codeController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Verification code',
                      hintText: 'Enter code',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _sending ? null : _sendCode,
                  child: Text(_sending ? 'Sending...' : 'Send code'),
                ),
              ],
            ),
            if (_sendTip != null) ...[
              const SizedBox(height: 8),
              Text(_sendTip!, style: TextStyle(color: Colors.grey.shade700, fontSize: 12)),
            ],
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _loggingIn ? null : _login,
                child: Text(_loggingIn ? 'Logging in...' : 'Login'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
