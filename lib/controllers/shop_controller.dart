import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../api/request.dart';
import '../common/global_data.dart';
import '../models/shop_model.dart';

class ShopController extends GetxController {
  RxList shopList = <ShopModel>[].obs;
  Rx<ShopModel> currentShop = ShopModel().obs;

  /// 是否正在请求数据
  RxBool isInRequest = true.obs;

  void subscript() {
    GlobalData.buyShop.submit(currentShop.value, false);
  }

  Future<void> getShopList() async {
    // final res = await Request.getShopList('0');


    try {
      // final resList = res.map((e) => ShopModel.fromJson(e)).toList();
      final resList = [
        ShopModel(
           id: 1,
            shopId: 'videoai_weekly_subscription',
            selected: true,),
        ShopModel(
           id: 2,
            shopId: 'videoai_yearly_subscription',
            selected: false,),
      ];
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
          print("${apiShop.productDetails?.price   }  ${apiShop.productDetails?.currencyCode}   ${apiShop.productDetails?.rawPrice}"  );
        }
      }
      resList.removeWhere((e) => e.productDetails == null);
      shopList.value = resList;
      if (shopList.isEmpty) {
        isInRequest.value = false;
        Fluttertoast.showToast(
            msg: 'productNotFound'.tr,
            toastLength: Toast.LENGTH_LONG,
            timeInSecForIosWeb: 5,
            gravity: ToastGravity.CENTER);
        return;
      }

      currentShop.value =
          resList.firstWhereOrNull((e) => (e.selected ?? false)) ??
              resList.first;
      isInRequest.value = false;
    } catch (e) {
      Get.log(e.toString(), isError: true);
      rethrow;
    }
  }
}
