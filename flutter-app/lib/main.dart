import 'package:app_links/app_links.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ruoyi_app/api/login.dart';
import 'package:ruoyi_app/api/system/user.dart';
import 'package:ruoyi_app/routes/app_pages.dart';
import 'package:ruoyi_app/utils/sputils.dart';

/// Load user profile and routers only once per app session when entering home.
/// Previously these ran on every route change and caused slow startup and login.
bool _userAndRoutersLoaded = false;

void _loadUserAndRoutersOnce() {
  if (_userAndRoutersLoaded) return;
  _userAndRoutersLoaded = true;
  getInfo();
  getUserProfile();
  getRouters();
}

void main() {
  GetStorage.init();
  // Web: after Google login backend redirects to /#/home?token=xxx — save token so we open home logged in
  if (kIsWeb) {
    final fragment = Uri.base.fragment;
    if (fragment.contains('token=')) {
      final idx = fragment.indexOf('?');
      if (idx >= 0 && idx < fragment.length - 1) {
        final query = fragment.substring(idx + 1);
        final params = Uri.splitQueryString(query);
        final token = params['token'];
        if (token != null && token.isNotEmpty) {
          GetStorage().write('token', token);
          SPUtil().setString('token', token);
        }
      }
    }
  }
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _appLinks = AppLinks();

  @override
  void initState() {
    super.initState();
    _handleInitialLink();
    _listenToLinks();
  }

  Future<void> _handleInitialLink() async {
    try {
      final uri = await _appLinks.getInitialAppLink();
      if (uri != null) _handleGoogleLoginUri(uri);
    } catch (_) {}
  }

  void _listenToLinks() {
    _appLinks.uriLinkStream.listen((Uri? uri) {
      if (uri != null) _handleGoogleLoginUri(uri);
    });
  }

  void _handleGoogleLoginUri(Uri uri) {
    if (uri.scheme != 'ruoyiapp' ||
        uri.host != 'google-login' ||
        !uri.queryParameters.containsKey('code')) return;
    final code = uri.queryParameters['code']?.trim();
    if (code == null || code.isEmpty) return;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        final resp = await googleCallback(code);
        final data = resp.data as Map<String, dynamic>?;
        if (data != null && data['code'] == 200) {
          Get.offAllNamed('/home');
          return;
        }
        // Auth failed: clear token so user can retry or use another account
        GetStorage().remove('token');
        SPUtil().remove('token');
        Get.offAllNamed('/login');
        if (Get.isSnackbarOpen) Get.closeAllSnackbars();
        Get.snackbar(
          'Google sign-in failed',
          data?['msg']?.toString() ?? 'Please try again or choose another account.',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 5),
        );
      } catch (_) {
        GetStorage().remove('token');
        SPUtil().remove('token');
        Get.offAllNamed('/login');
        if (Get.isSnackbarOpen) Get.closeAllSnackbars();
        Get.snackbar(
          'Google sign-in failed',
          'Please try again or choose another account.',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 5),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final hasToken = GetStorage().hasData("token");
    final initialRoute =
        hasToken ? AppPages.INITIAL : AppPages.INITIALLOGIN;
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.fade,

      /// Internationalization custom configuration, currently configured for English and Chinese
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      supportedLocales: const [Locale("en", "US"), Locale("zh", "CN")],

      initialRoute: initialRoute,
      getPages: AppPages.routes,
      routingCallback: (routing) {
        if (routing?.current == "/home") {
          _loadUserAndRoutersOnce();
        } else if (routing?.current == "/login" ||
            routing?.current == "/login/webView") {
          _userAndRoutersLoaded = false;
        }
      },
    );
  }
}
