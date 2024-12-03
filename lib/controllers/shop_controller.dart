import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../api/request.dart';
import '../common/global_data.dart';
import '../models/shop_model.dart';

class ShopController extends GetxController {
  RxList shopList = <ShopModel>[].obs;
  Rx<ShopModel> currentShop = ShopModel().obs;

  static int productPointType = 1; //积分商品
  static int productProType = 2; //会员商品
  static int iosProductPointType = 3; //积分商品
  static int iosProductProType = 4; //会员商品
  static int productLimitedOfferProType = 53; //限时折扣会员商品
  static int productLimitedOfferPointType = 54; //限时折扣积分商品

  /// 是否正在请求数据
  RxBool isInRequest = true.obs;

  void purchase(String pageName) {
    GlobalData.buyShop.submit(currentShop.value, false, pageName);
  }

  void subscript(String pageName) {
    GlobalData.buyShop.submit(currentShop.value, true, pageName);
  }

  Future<List<ShopModel>?> getShopList(int type, {bool showToast = true}) async {
    try {
      isInRequest.value = true;
      final res = await Request.getShopList(type);
      final resList = res.map((e) => ShopModel.fromJson(e)).toList();
      resList.removeWhere((e) => e.shopId == null);
      final Set<String> ids = resList.map((e) => e.shopId!).toSet();
      ProductDetailsResponse? pdRes;
      if (ids.isNotEmpty) {
        pdRes = await GlobalData.buyShop.getProduct(ids);
      }
      if (pdRes != null && pdRes.productDetails.isNotEmpty) {
        for (final apiShop in resList) {
          apiShop.productDetails = pdRes.productDetails
              .firstWhereOrNull((element) => apiShop.shopId == element.id);
        }
      }
      resList.removeWhere((e) => e.productDetails == null);
      shopList.value = resList;
      if (shopList.isEmpty && showToast) {
        Fluttertoast.showToast(msg: 'productNotFound'.tr);
        return null;
      }

      currentShop.value =
          resList.firstWhereOrNull((e) => (e.selected ?? false)) ??
              resList.first;
      return resList;
    } catch (e) {
      Get.log(e.toString(), isError: true);
      return null;
    } finally {
      isInRequest.value = false;
    }
  }
}
