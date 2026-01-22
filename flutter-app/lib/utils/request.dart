import "package:dio/dio.dart";
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ruoyi_app/utils/sputils.dart';

/// Dio network request configuration table (custom)
class DioConfig {
  // Development environment: local backend address
  // Note: If the Flutter App is running on an emulator/real device, localhost needs to be changed to the computer's LAN IP
  // Android emulator can use 10.0.2.2:8080
  // iOS emulator can use localhost:8080
  // Real device needs to use the computer's LAN IP, e.g.: 192.168.x.x:8080
  static const baseURL = "http://localhost:8080"; // Domain name
  static const timeout = 10000; // Timeout duration
}

// Network request utility class
class DioRequest {
  late Dio dio;
  static DioRequest? _instance;

  /// Constructor
  DioRequest() {
    dio = Dio();
    dio.options = BaseOptions(
        baseUrl: DioConfig.baseURL,
        connectTimeout: DioConfig.timeout,
        sendTimeout: DioConfig.timeout,
        receiveTimeout: DioConfig.timeout,
        contentType: "application/json; charset=utf-8",
        headers: {});

    /// Request interceptor, response interceptor and error handling
    dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
      options.responseType = ResponseType.json;
      print("================== Request Data ==========================");
      print("url = ${options.uri.toString()}");
      print("headers = ${options.headers}");
      print("params = ${options.data}");
      return handler.next(options);
    }, onResponse: (response, handler) {
      if (response.realUri.path == "/login") {
        if (response.data["code"] == 200) {
          GetStorage().write("token", response.data["token"]);
          SPUtil().setString("token", response.data["token"]);
        }
      }
      if (response.realUri.path == "/system/user/profile") {
        if (response.data["code"] == 200) {
          GetStorage().write("roleGroup", response.data["roleGroup"]);
        }
      }
      if (response.realUri.path == "/getRouters") {
        if (response.data["code"] == 200) {
          GetStorage().write("route", response.data["data"]);
        }
      }

      if (response.realUri.path == "/getInfo") {
        if (response.data["code"] == 200) {
          GetStorage().write("nickName", response.data["user"]["nickName"]);
          GetStorage().write("userName", response.data["user"]["userName"]);
          SPUtil().setString(
              "avatar",
              response.data["user"]["avatar"] ??
                  "http://vue.ruoyi.vip/static/img/profile.473f5971.jpg");
        }
      }
      if (response.data["code"] == 403) {
        SPUtil().clean();
        GetStorage().erase();
        Get.toNamed("/login");
      }
      if ((response.data["code"] == 401)) {
        SPUtil().clean();
        GetStorage().erase();
        Get.offAll("/login");
      }
      // Handle mobile login token storage
      if (response.realUri.path == "/mobile/login") {
        if (response.data["code"] == 200) {
          GetStorage().write("token", response.data["token"]);
          SPUtil().setString("token", response.data["token"]);
        }
      }
      print("================== Response Data ==========================");
      print("code = ${response.statusCode}");
      print("data = ${response.data}");
      handler.next(response);
    }, onError: (DioError e, handler) {
      Get.snackbar("Network Error", "Request Failed");
      print("================== Error Response Data ======================");
      print("type = ${e.type}");
      print("message = ${e.message}");
      return handler.next(e);
    }));
  }

  static DioRequest getInstance() {
    return _instance ??= DioRequest();
  }

  httpRequest(
    String path,
    bool isToken,
    String method, {
    data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    Options? options,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    Options options;
    if (isToken) {
      if (!GetStorage().hasData("token")) {
        var token = SPUtil().get("token");
        if (token != null) {
          GetStorage().write("token", token);
        } else {
          ///TODO If it's also empty, clear all information and navigate to login page logic
          GetStorage().remove("token");
          SPUtil().remove("token");
          Get.offNamed("/login");
        }
      }
      options = Options(
        headers: {
          "content-type": "application/json; charset=utf-8",
          "Authorization": "Bearer ${GetStorage().read("token")}",
        },
        method: method,
      );
    } else {
      options = Options(
        headers: {"content-type": "application/json; charset=utf-8"},
        method: method,
      );
    }
    switch (method) {
      case "get":
        return await dio.request(path,
            queryParameters: queryParameters, options: options);
      case "post":
        return await dio.request(path, data: data, options: options);
      case "put":
        return await dio.request(
          path,
          queryParameters: data,
          data: data,
          options: options,
        );
      case "delete":
        return await dio.request(path, data: data, options: options);
    }
  }
}
