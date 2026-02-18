import '../utils/request.dart';

var addOrder = (int cartId) async {
  return await DioRequest().httpRequest(
    "/user/product/order",
    true,
    "post",
    queryParameters: {"cart_id": cartId},
  );
};

var getOrderList = () async {
  return await DioRequest().httpRequest(
    "/user/product/order",
    true,
    "get",
  );
};

var searchProductByBarcode = (String barcode) async {
  return await DioRequest().httpRequest(
    "/user/product/search/barcode",
    true,
    "get",
    queryParameters: {"barcode": barcode},
  );
};

var addCart = (int productId, {int quantity = 1}) async {
  return await DioRequest().httpRequest(
    "/user/product/cart",
    true,
    "post",
    queryParameters: {"product_id": productId, "quantity": quantity},
  );
};

var updateCart = (int cartId, int quantity) async {
  return await DioRequest().httpRequest(
    "/user/product/cart",
    true,
    "put",
    queryParameters: {"cart_id": cartId, "quantity": quantity},
  );
};

var deleteCart = (int cartId) async {
  return await DioRequest().httpRequest(
    "/user/product/cart/",
    true,
    "delete",
    queryParameters: {"cart_id": cartId},
  );
};

/// GET /user/product/storage/list - pantry/storage items (app_user_storage)
var getStorageList = ({int pageNum = 1, int pageSize = 100}) async {
  return await DioRequest().httpRequest(
    "/user/product/storage/list",
    true,
    "get",
    queryParameters: {"pageNum": pageNum, "pageSize": pageSize},
  );
};

/// PUT /user/product/storage - update consumption (subtract portion consumed)
var updateStorage = (int storageId, double consumptionRate) async {
  return await DioRequest().httpRequest(
    "/user/product/storage",
    true,
    "put",
    queryParameters: {"storage_id": storageId, "consumption_rate": consumptionRate},
  );
};

var getCartList = (String? sortField, String sortOrder, {int pageNum = 1, int pageSize = 100}) async {
  final params = <String, dynamic>{"pageNum": pageNum, "pageSize": pageSize};
  if (sortField != null && sortField.isNotEmpty) {
    params["sorts[0].field"] = sortField;
    params["sorts[0].order"] = sortOrder;
  }
  return await DioRequest().httpRequest(
    "/user/product/cart/list",
    true,
    "get",
    queryParameters: params,
  );
};
