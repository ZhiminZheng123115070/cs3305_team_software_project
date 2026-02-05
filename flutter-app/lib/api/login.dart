import '../utils/request.dart';

var getInfo = () async {
  return await DioRequest().httpRequest("/getInfo", true, "get");
};

var getImage = () async {
  return await DioRequest().httpRequest("/captchaImage", false, "get");
};

var logInByClient = (data) async {
  return await DioRequest().httpRequest("/login", false, "post", data: data);
};

// Mobile phone login related API
var sendSmsCode = (data) async {
  return await DioRequest().httpRequest("/mobile/sendCode", false, "post", data: data);
};

var mobileLogin = (data) async {
  return await DioRequest().httpRequest("/mobile/login", false, "post", data: data);
};

/// Google login: get auth URL. Backend uses platform to pick redirect_uri (Android: 10.0.2.2:8080, iOS: localhost:8080).
/// [platform] should be 'android' or 'ios' from device detection; other values use iOS/localhost URI.
var getGoogleAuthUrl = ({String? platform}) async {
  return await DioRequest().httpRequest(
    "/user/login/google/auth-url",
    false,
    "get",
    queryParameters: platform != null && platform.isNotEmpty ? {"platform": platform} : null,
  );
};

// Google login: exchange code for token (after user returns from Google OAuth)
var googleCallback = (String code) async {
  return await DioRequest().httpRequest(
    "/user/login/google/callback",
    false,
    "get",
    queryParameters: {"code": code},
  );
};

// Logout: call backend to invalidate JWT (remove token from Redis), then clear local
var logout = () async {
  return await DioRequest().httpRequest("/logout", true, "post");
};
