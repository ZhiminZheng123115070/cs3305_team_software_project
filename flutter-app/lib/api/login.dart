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
