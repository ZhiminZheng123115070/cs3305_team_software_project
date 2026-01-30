import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/route_manager.dart';
import 'package:ruoyi_app/icon/ruoyi_icon.dart';

import '../api/login.dart';

/// 清除应用内 WebView 的 Cookie，下次 Google 登录将不显示此前保存的账号（仅 Android）
Future<void> clearWebViewCookies() async {
  const channel = MethodChannel('com.example.ruoyi_app/webview_cookies');
  await channel.invokeMethod('clearCookies');
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
  /// 验证码图片 base64，空表示未加载或加载失败
  var url = "";
  var uuid = "";
  var password = "";
  var username = "";
  var code = "";
  /// 验证码是否加载失败（如网络错误）
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
      if (data is Map && data["img"] != null && data["uuid"] != null) {
        setState(() {
          url = data["img"].toString();
          uuid = data["uuid"].toString();
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

  /// 验证码区域：无数据时显示占位/重试，有数据时安全解码显示，避免 "Codec failed... invalid image data"
  Widget _buildCaptchaImage() {
    if (url.isEmpty) {
      return Container(
        color: Colors.grey[200],
        alignment: Alignment.center,
        child: Text(
          captchaLoadFailed ? "Load failed\nTap to retry" : "Loading...",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12, color: Colors.grey[700]),
        ),
      );
    }
    try {
      return Image.memory(
        Base64Decoder().convert(url),
        fit: BoxFit.fill,
        errorBuilder: (_, __, ___) => Container(
          color: Colors.grey[200],
          alignment: Alignment.center,
          child: Text(
            "Invalid image\nTap to retry",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: Colors.grey[700]),
          ),
        ),
      );
    } catch (_) {
      return Container(
        color: Colors.grey[200],
        alignment: Alignment.center,
        child: Text(
          "Invalid image\nTap to retry",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12, color: Colors.grey[700]),
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
                      if (code.isEmpty) {
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
                        "code": code.trim()
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
              // Google login（应用内 WebView；若提示「此浏览器或应用可能不安全」请用上方用户名或手机号登录）
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton.icon(
                  onPressed: () async {
                    try {
                      // 先清除 WebView 中可能存在的此前 Google 账号缓存，再进入 Google 登录页
                      try {
                        await clearWebViewCookies();
                      } catch (_) {}
                      var response = await getGoogleAuthUrl();
                      var data = response.data as Map<String, dynamic>?;
                      if (data != null &&
                          data['code'] == 200 &&
                          data['authUrl'] != null) {
                        final authUrl = data['authUrl'] as String;
                        final code = await Get.toNamed("/login/googleWebView",
                            arguments: {"authUrl": authUrl});
                        if (code != null && code is String) {
                          var callbackResp = await googleCallback(code);
                          var callbackData =
                              callbackResp.data as Map<String, dynamic>?;
                          if (callbackData != null &&
                              callbackData['code'] == 200) {
                            Get.toNamed("/home");
                          } else {
                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                content: Text(
                                  callbackData?['msg'] ??
                                      'Google login failed',
                                  style: const TextStyle(color: Colors.red),
                                ),
                              ),
                            );
                          }
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
              // Mobile login 按钮（左侧为图标；若需自定义图，将 mobile_icon.png 放入 static/images/ 并取消下方注释）
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
              const SizedBox(
                height: 10,
              ),
              Center(
                child: RichText(
                  text: TextSpan(
                      text: "By logging in, you agree to the ",
                      style: const TextStyle(color: Colors.black),
                      children: [
                        TextSpan(
                          text: "User Agreement",
                          style: const TextStyle(color: Colors.red),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Get.toNamed("/login/webView", arguments: {
                                "title": "User Service Agreement",
                                "url": "https://ruoyi.vip/protocol.html"
                              });
                            },
                        ),
                        TextSpan(
                          text: " and ",
                          style: const TextStyle(color: Colors.black),
                        ),
                        TextSpan(
                          text: "Privacy Policy",
                          style:
                              TextStyle(color: Theme.of(context).colorScheme.secondary),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Get.toNamed("/login/webView", arguments: {
                                "title": "Privacy Policy",
                                "url": "https://ruoyi.vip/protocol.html"
                              });
                            },
                        ),
                      ]),
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
    return ListTile(
      leading: Image.asset(
        "static/logo.png",
      ),
      title: const Text(
        "RuoYi Mobile Login",
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w300,
        ),
      ),
    );
  }
}
