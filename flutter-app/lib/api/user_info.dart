import '../utils/request.dart';

/// GET /user/info - fetch current user's health info
var getUserInfo = () async {
  return await DioRequest().httpRequest("/user/info", true, "get");
};

/// GET /user/info/history - weight history for line chart
var getWeightRecords = () async {
  return await DioRequest().httpRequest("/user/info/history", true, "get");
};

/// POST /user/info - insert or update user info
var saveUserInfoApi = (Map<String, dynamic> data) async {
  return await DioRequest().httpRequest("/user/info", true, "post", data: data);
};
