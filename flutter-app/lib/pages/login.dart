import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/route_manager.dart';
import 'package:ruoyi_app/icon/ruoyi_icon.dart';

import 'package:url_launcher/url_launcher.dart';

import '../api/login.dart';

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
  /// Captcha image base64; empty means not loaded or load failed
  var url = "";
  var uuid = "";
  var password = "";
  var username = "";
  var code = "";
  /// Whether captcha is enabled (from backend; default true so UI shows captcha if API fails)
  var captchaEnabled = true;
  /// Whether captcha load failed (e.g. network error)
  var captchaLoadFailed = false;

  @override
  void initState() {
    super.initState();
    getImg();
  }

  void getImg() async {
    setState(() => captchaLoadFailed = false);
    try {
      var reps = await getImage();
      var data = reps.data;
      if (data is Map) {
        final enabled = data["captchaEnabled"] == true;
        setState(() {
          captchaEnabled = enabled;
          if (enabled && data["img"] != null && data["uuid"] != null) {
            url = data["img"].toString();
            uuid = data["uuid"].toString();
          } else {
            url = "";
            uuid = "";
            if (enabled) captchaLoadFailed = true;
          }
        });
      } else {
        setState(() {
          url = "";
          captchaLoadFailed = true;
        });
      }
    } catch (e) {
      print(e);
      setState(() {
        url = "";
        captchaLoadFailed = true;
      });
    }
  }

  /// Captcha area: placeholder/retry when no data; safe decode when data exists to avoid Codec failed
  Widget _buildCaptchaImage() {
    if (url.isEmpty) {
      return Container(
        color: Colors.grey.shade200,
        alignment: Alignment.center,
        child: Text(
          captchaLoadFailed ? "Load failed\nTap to retry" : "Loading...",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
        ),
      );
    }
    try {
      return Image.memory(
        Base64Decoder().convert(url),
        fit: BoxFit.fill,
        errorBuilder: (_, __, ___) => Container(
          color: Colors.grey.shade200,
          alignment: Alignment.center,
          child: Text(
            "Invalid image\nTap to retry",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
          ),
        ),
      );
    } catch (_) {
      return Container(
        color: Colors.grey.shade200,
        alignment: Alignment.center,
        child: Text(
          "Invalid image\nTap to retry",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
        ),
      );
    }
  }

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
              if (captchaEnabled) ...[
                Container(
                    height: 50,
                    padding: EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(25.0),
                            bottomLeft: Radius.circular(25.0)),
                        border: Border.all(width: 1.0)),
                    child: Flex(
                      direction: Axis.horizontal,
                      children: [
                        Expanded(
                            flex: 7,
                            child: TextField(
                              onChanged: (value) {
                                code = value;
                              },
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                icon: Icon(RuoYiIcons.code),
                                border: InputBorder.none,
                                hintText: "Please enter verification code",
                              ),
                            )),
                        Expanded(
                            flex: 5,
                            child: InkWell(
                                onTap: () => getImg(),
                                child: _buildCaptchaImage())),
                      ],
                    )),
                const SizedBox(
                  height: 45,
                ),
              ],
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
                      if (captchaEnabled && code.isEmpty) {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                const AlertDialog(
                                  content: Text(
                                    'Verification code cannot be empty!',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ));
                        return;
                      }
                      var requestData = {
                        "uuid": uuid,
                        "username": username.trim(),
                        "password": password.trim(),
                        "code": captchaEnabled ? code.trim() : ""
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
                        getImg();
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
                      var response = await getGoogleAuthUrl();
                      var data = response.data as Map<String, dynamic>?;
                      if (data != null &&
                          data['code'] == 200 &&
                          data['authUrl'] != null) {
                        final authUrl = data['authUrl'] as String;
                        final uri = Uri.tryParse(authUrl);
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
