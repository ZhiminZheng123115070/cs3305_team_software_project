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

// Google login: get auth URL (then open in WebView)
var getGoogleAuthUrl = () async {
  return await DioRequest().httpRequest("/user/login/google/auth-url", false, "get");
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
