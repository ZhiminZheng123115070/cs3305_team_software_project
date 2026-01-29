import '../utils/request.dart';

// Search product by barcode
var searchProductByBarcode = (String barcode) async {
  return await DioRequest().httpRequest(
    "/user/product/search/barcode",
    true,
    "get",
    queryParameters: {"barcode": barcode},
  );
};
