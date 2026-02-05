import 'dart:convert';

import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/route_manager.dart';
import 'package:ruoyi_app/icon/ruoyi_icon.dart';

import 'package:url_launcher/url_launcher.dart';

import '../api/login.dart';

/// Resolve Google OAuth platform for redirect_uri: Android uses 10.0.2.2, iOS uses localhost.
String _googleLoginPlatform() {
  if (defaultTargetPlatform == TargetPlatform.android) return 'android';
  if (defaultTargetPlatform == TargetPlatform.iOS) return 'ios';
  return 'ios'; // desktop / other: use same as iOS (localhost)
}

class MyHome extends StatelessWidget {
  const MyHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Login",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.transparent, // Set background color to transparent
          shadowColor: Colors.transparent,
        ),
        body: const Login());
  }
}

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LoginIndex();
  }
}

// ignore: must_be_immutable
class LoginIndex extends StatefulWidget {
  LoginIndex({Key? key}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  State<StatefulWidget> createState() {
    // TODO: implement createState
    // ignore: no_logic_in_create_state
    return _LoginIndexState();
  }
}

class _LoginIndexState extends State<LoginIndex> {
  var password = "";
  var username = "";

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Flex(
      direction: Axis.vertical,
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.only(left: 40, right: 40),
            children: [
              const SizedBox(
                height: 60,
              ),
              const Center(
                child: LogInIcon(),
              ),
              const SizedBox(
                height: 70,
              ),
              Container(
                height: 50,
                padding: EdgeInsets.only(left: 10),
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(25.0)),
                    border: Border.all(width: 1.0)),
                child: TextField(
                  onChanged: (value) {
                    username = value;
                  },
                  decoration: const InputDecoration(
                    icon: Icon(RuoYiIcons.user),
                    border: InputBorder.none,
                    hintText: "Please enter username",
                  ),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Container(
                height: 50,
                padding: EdgeInsets.only(left: 10),
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(25.0)),
                    border: Border.all(width: 1.0)),
                child: TextField(
                  obscureText: true,
                  onChanged: (value) {
                    password = value;
                  },
                  decoration: const InputDecoration(
                    icon: Icon(RuoYiIcons.password),
                    border: InputBorder.none,
                    hintText: "Please enter password",
                  ),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Container(
                  height: 50,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(25.0)),
                  ),
                  child: TextButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.blue),
                        shape: MaterialStateProperty.all(
                            const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25.0))))),
                    onPressed: () async {
                      if (username.isEmpty) {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                const AlertDialog(
                                  content: Text(
                                    'Username cannot be empty!',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ));
                        return;
                      }
                      if (password.isEmpty) {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                const AlertDialog(
                                  content: Text(
                                    'Password cannot be empty!',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ));
                        return;
                      }
                      var requestData = {
                        "uuid": "",
                        "username": username.trim(),
                        "password": password.trim(),
                        "code": ""
                      };

                      var data = await logInByClient(requestData);
                      var resp = jsonDecode(data.toString());

                      if (resp["code"] == 200) {
                        // ignore: use_build_context_synchronously
                        Get.toNamed("/home");
                      } else {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                                  content: Text(
                                    resp["msg"],
                                    style: const TextStyle(color: Colors.cyan),
                                  ),
                                ));
                      }
                    },
                    child: const Text(
                      "Login",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  )),
              const SizedBox(height: 20),
              // Google login: opens in system browser (Google OAuth policy); browser returns to app after login
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton.icon(
                  onPressed: () async {
                    try {
                      final platform = _googleLoginPlatform();
                      var response = await getGoogleAuthUrl(platform: platform);
                      var data = response.data as Map<String, dynamic>?;
                      if (data != null &&
                          data['code'] == 200 &&
                          data['authUrl'] != null) {
                        final authUrl = data['authUrl'] as String;
                        // prompt=select_account: each time open account picker so user can retry with another account after a failed login
                        // _t: cache-bust so each tap opens a fresh auth page instead of browser showing cached error page
                        final parsed = Uri.tryParse(authUrl);
                        final params = Map<String, String>.from(parsed?.queryParameters ?? {});
                        params['prompt'] = 'select_account';
                        params['_t'] = DateTime.now().millisecondsSinceEpoch.toString();
                        final uri = parsed != null
                            ? parsed.replace(queryParameters: params)
                            : Uri.tryParse(authUrl);
                        if (uri != null &&
                            await canLaunchUrl(uri)) {
                          await launchUrl(
                              uri,
                              mode: LaunchMode.externalApplication);
                          // Login result returns to app via deep link ruoyiapp://google-login?code=xxx, handled in main
                        } else {
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              content: Text(
                                'Cannot open browser',
                                style: const TextStyle(color: Colors.red),
                              ),
                            ),
                          );
                        }
                      } else {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            content: Text(
                              data?['msg'] ?? 'Failed to get Google auth URL',
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                        );
                      }
                    } catch (e) {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          content: Text(
                            'Error: $e',
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.g_mobiledata, size: 24),
                  label: const Text("Google login"),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.grey),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // Mobile login button (icon on left; for custom icon put mobile_icon.png in static/images/ and uncomment below)
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Get.toNamed("/mobileLogin");
                  },
                  icon: const Icon(Icons.phone_android, size: 24),
                  label: const Text("Mobile login"),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.grey),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ));
  }
}

class LogInIcon extends StatelessWidget {
  const LogInIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Password Login",
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w300,
        ),
      ),
    );
  }
}
