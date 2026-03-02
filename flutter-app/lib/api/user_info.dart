import '../utils/request.dart';

/// GET /user/info - fetch current user's health info
var getUserInfo = () async {
  return await DioRequest().httpRequest("/user/info", true, "get");
};

/// POST /user/info/health - add diet log (creates NutritionRecord, DietLog, updates storage)
var addDietLog = (int storageId, double consumptionRate) async {
  return await DioRequest().httpRequest(
    "/user/info/health",
    true,
    "post",
    queryParameters: {"storage_id": storageId, "consumption_rate": consumptionRate},
  );
};

/// GET /user/info/health/diet-log - diet log list (consumed history)
var getDietLog = () async {
  return await DioRequest().httpRequest("/user/info/health/diet-log", true, "get");
};

/// GET /user/info/health/daily-calories - daily intake (energyKcal, targetKcal, proteins, carbohydrates, fat)
var getDailyCalories = (String date) async {
  return await DioRequest().httpRequest("/user/info/health/daily-calories", true, "get", queryParameters: {"date": date});
};

/// GET /user/info/history - weight history for line chart
var getWeightRecords = () async {
  return await DioRequest().httpRequest("/user/info/history", true, "get");
};

/// POST /user/info - insert or update user info
var saveUserInfoApi = (Map<String, dynamic> data) async {
  return await DioRequest().httpRequest("/user/info", true, "post", data: data);
};
