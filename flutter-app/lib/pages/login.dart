import 'dart:convert';

import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform;
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/route_manager.dart';
import 'package:url_launcher/url_launcher.dart';

import '../api/login.dart';

String _googleLoginPlatform() {
  if (defaultTargetPlatform == TargetPlatform.android) return 'android';
  if (defaultTargetPlatform == TargetPlatform.iOS) return 'ios';
  return 'ios';
}

class MyHome extends StatelessWidget {
  const MyHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: const Login(),
      ),
    );
  }
}

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LoginIndex();
  }
}

class LoginIndex extends StatefulWidget {
  const LoginIndex({Key? key}) : super(key: key);

  @override
  State<LoginIndex> createState() => _LoginIndexState();
}

class _LoginIndexState extends State<LoginIndex> {
  var password = "";
  var username = "";
  var _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFFFF8E1),
            Color(0xFFE8F5E9),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 32),
          Center(
            child: Container(
              width: 72,
              height: 72,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.orange.shade400,
                  Colors.green.shade400,
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
              child: const Icon(
                Icons.local_offer_outlined,
                size: 40,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Welcome Back",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E2E2E),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "Sign in to your account",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 28),
          Expanded(child: _buildLoginCard(context)),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don't have an account? ",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: const Text(
                    "Sign Up",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2E7D32),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Username
            Text(
              "Username",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              onChanged: (value) => username = value,
              decoration: InputDecoration(
                hintText: "Enter your username",
                filled: true,
                fillColor: Colors.grey.shade50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Password
            Text(
              "Password",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              onChanged: (value) => password = value,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                hintText: "Enter your password",
                filled: true,
                fillColor: Colors.grey.shade50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey.shade600,
                    size: 22,
                  ),
                  onPressed: () {
                    setState(() => _obscurePassword = !_obscurePassword);
                  },
                ),
              ),
            ),
            const SizedBox(height: 28),
            // Sign In button
            SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: _onSignIn,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E7D32),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text("Sign In", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ),
            ),
            const SizedBox(height: 24),
            // OR CONTINUE WITH
            Row(
              children: [
                Expanded(child: Divider(color: Colors.grey.shade400)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    "OR CONTINUE WITH",
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Expanded(child: Divider(color: Colors.grey.shade400)),
              ],
            ),
            const SizedBox(height: 20),
            // Google
            SizedBox(
              height: 50,
              child: OutlinedButton.icon(
                onPressed: _onGoogleLogin,
                icon: Icon(Icons.g_mobiledata, size: 22, color: Colors.grey.shade700),
                label: Text(
                  "Google",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey.shade800,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: BorderSide(color: Colors.grey.shade300),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Phone
            SizedBox(
              height: 50,
              child: OutlinedButton.icon(
                onPressed: () => _showPhoneLoginDialog(context),
                icon: Icon(Icons.phone_android, size: 22, color: Colors.grey.shade700),
                label: Text(
                  "Phone",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey.shade800,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: BorderSide(color: Colors.grey.shade300),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                "Demo Mode: Enter any username and password",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onSignIn() async {
    if (username.isEmpty) {
      showDialog(
        context: context,
        builder: (ctx) => const AlertDialog(
          content: Text('Username cannot be empty!', style: TextStyle(color: Colors.red)),
        ),
      );
      return;
    }
    if (password.isEmpty) {
      showDialog(
        context: context,
        builder: (ctx) => const AlertDialog(
          content: Text('Password cannot be empty!', style: TextStyle(color: Colors.red)),
        ),
      );
      return;
    }
    var requestData = {
      "uuid": "",
      "username": username.trim(),
      "password": password.trim(),
      "code": "",
    };
    try {
      var data = await logInByClient(requestData);
      var resp = jsonDecode(data.toString());
      if (resp["code"] == 200) {
        if (mounted) Get.toNamed("/home");
      } else {
        if (mounted) {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              content: Text(resp["msg"]?.toString() ?? "Login failed",
                  style: const TextStyle(color: Colors.cyan)),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            content: Text('Error: $e', style: const TextStyle(color: Colors.red)),
          ),
        );
      }
    }
  }

  void _showPhoneLoginDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const _PhoneLoginDialog(),
    );
  }

  Future<void> _onGoogleLogin() async {
    try {
      final platform = _googleLoginPlatform();
      var response = await getGoogleAuthUrl(platform: platform);
      var data = response.data as Map<String, dynamic>?;
      if (data != null &&
          data['code'] == 200 &&
          data['authUrl'] != null) {
        final authUrl = data['authUrl'] as String;
        final parsed = Uri.tryParse(authUrl);
        final params = Map<String, String>.from(parsed?.queryParameters ?? {});
        params['prompt'] = 'select_account';
        params['_t'] = DateTime.now().millisecondsSinceEpoch.toString();
        final uri = parsed != null
            ? parsed.replace(queryParameters: params)
            : Uri.tryParse(authUrl);
        if (uri != null && await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        } else {
          if (mounted) {
            showDialog(
              context: context,
              builder: (ctx) => const AlertDialog(
                content: Text('Cannot open browser', style: TextStyle(color: Colors.red)),
              ),
            );
          }
        }
      } else {
        if (mounted) {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              content: Text(
                data?['msg']?.toString() ?? 'Failed to get Google auth URL',
                style: const TextStyle(color: Colors.red),
              ),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            content: Text('Error: $e', style: const TextStyle(color: Colors.red)),
          ),
        );
      }
    }
  }
}

/// Phone login dialog: phone number, send code, verification code input, login.
class _PhoneLoginDialog extends StatefulWidget {
  const _PhoneLoginDialog();

  @override
  State<_PhoneLoginDialog> createState() => _PhoneLoginDialogState();
}

class _PhoneLoginDialogState extends State<_PhoneLoginDialog> {
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
      _sendTip = 'Please enter phone number';
      setState(() {});
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
      setState(() => _sendTip = 'Please enter phone number');
      return;
    }
    if (code.isEmpty) {
      setState(() => _sendTip = 'Please enter verification code');
      return;
    }
    setState(() {
      _loggingIn = true;
      _sendTip = null;
    });
    try {
      final resp = await mobileLogin({'phone': phone, 'code': code});
      final data = resp.data;
      if (data is Map && data['code'] == 200) {
        if (mounted) Navigator.of(context).pop();
        Get.offAllNamed('/home');
      } else {
        setState(() => _sendTip = data is Map ? (data['msg'] ?? 'Login failed') : 'Login failed');
      }
    } catch (e) {
      setState(() => _sendTip = 'Error: $e');
    } finally {
      setState(() => _loggingIn = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Title bar
              Row(
                children: [
                  Icon(Icons.phone_android, color: Colors.green.shade700, size: 26),
                  const SizedBox(width: 10),
                  const Text(
                    'Phone Login',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2E2E2E)),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Phone Number
              Text(
                'Phone Number',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.grey.shade800),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: 'Enter your phone number',
                  filled: true,
                  fillColor: Colors.grey.shade50,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
              const SizedBox(height: 16),
              // Send Verification Code
              SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: _sending ? null : _sendCode,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF9CCC65),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(_sending ? 'Sending...' : 'Send Verification Code'),
                ),
              ),
              if (_sendTip != null) ...[
                const SizedBox(height: 8),
                Text(_sendTip!, style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
              ],
              const SizedBox(height: 20),
              // Verification Code
              Text(
                'Verification Code',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.grey.shade800),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _codeController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Enter verification code',
                  filled: true,
                  fillColor: Colors.grey.shade50,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
              const SizedBox(height: 20),
              // Login button
              SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: _loggingIn ? null : _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E7D32),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(_loggingIn ? 'Logging in...' : 'Sign In'),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  'Demo Mode: Enter any phone number',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
