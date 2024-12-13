import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_ai/common/firebase_util.dart';
import 'package:video_ai/common/global_data.dart';
import 'package:video_ai/common/ui_colors.dart';
import 'package:video_ai/models/shop_model.dart';
import 'package:video_ai/pages/pro_purchase_page.dart';
import 'package:video_ai/widgets/bottom_item.dart';
import 'package:video_ai/widgets/custom_button.dart';

import '../controllers/shop_controller.dart';

class PointPurchasePage extends StatefulWidget {
  const PointPurchasePage({super.key});

  @override
  State<PointPurchasePage> createState() => _PointPurchasePageState();
}

class _PointPurchasePageState extends State<PointPurchasePage> {
  final ShopController _shopCtr = ShopController();

  @override
  void initState() {
    super.initState();
    FireBaseUtil.logEventPageView(PageName.creditsPurchasePage);
    _getShops();
  }

  void _getShops() {
    _shopCtr.getShopList(GetPlatform.isAndroid
        ? ShopController.productPointType
        : ShopController.iosProductPointType);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UiColors.c121212,
      body: Stack(
        children: [
          Image.asset(
            'assets/images/img_pro_purchase_bg.png',
            fit: BoxFit.fitWidth,
          ),
          SafeArea(
            child: Obx(
              () => Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 14.0, top: 16, bottom: 16),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: GestureDetector(
                        onTap: () => Get.back(),
                        child: Image.asset(
                          'assets/images/ic_close.png',
                          width: 24,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                      child: SingleChildScrollView(
                          child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/images/img_point_buy_top.png',
                          width: 260,
                          height: 140,
                        ),
                        Text(
                          'creditsPackage'.tr,
                          style: const TextStyle(
                              fontSize: 24,
                              color: UiColors.cDBFFFFFF,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          'creditsPackageDesc'.tr,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 12,
                              color: UiColors.c99FFFFFF,
                              fontWeight: FontWeightExt.semiBold),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        if (_shopCtr.isInRequest.value)
                          const Padding(
                              padding: EdgeInsets.only(top: 140),
                              child: Center(child: CircularProgressIndicator()))
                        else if (_shopCtr.shopList.isEmpty)
                          RefreshWidget(
                            onRefresh: _getShops,
                            topPadding: 140,
                          )
                        else
                          ..._shopCtr.shopList.map((e) => _listItem(e)),
                      ],
                    ),
                  ))),
                  if (_shopCtr.shopList.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, top: 18, bottom: 16),
                      child: CustomButton(
                        width: double.infinity,
                        height: 46,
                        onTap: () {
                          FireBaseUtil.logEventButtonClick(
                              PageName.creditsPurchasePage,
                              "creditsPage_purchase_button");
                          _shopCtr.purchase(PageName.creditsPurchasePage);
                        },
                        text: 'purchase'.tr,
                        bgColors: const [UiColors.c7631EC, UiColors.cBC8EF5],
                        textColor: UiColors.cDBFFFFFF,
                        rightIcon: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Image.asset(
                            'assets/images/ic_arrow_right.png',
                            width: 22,
                            height: 22,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  BottomItem(
                    text: 'restore'.tr,
                    onTap: () {
                      GlobalData.buyShop.resumePurchase();
                    },
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _listItem(ShopModel model) {
    return GestureDetector(
      onTap: () => _shopCtr.currentShop.value = model,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        margin: const EdgeInsets.only(top: 12),
        decoration: BoxDecoration(
            color: UiColors.c2B2E38,
            border: Border.all(
                color: _shopCtr.currentShop.value == model
                    ? UiColors.cBC8EF5
                    : UiColors.c2B2E38,
                width: 2),
            borderRadius: BorderRadius.circular(12)),
        child: Row(
          children: [
            Expanded(
              child: Text(
                model.shopNameLocal,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: _shopCtr.currentShop.value == model
                        ? Colors.white
                        : UiColors.c99FFFFFF,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              width: 12,
            ),
            Text(
              model.productDetails?.price ?? '',
              style: TextStyle(
                  color: _shopCtr.currentShop.value == model
                      ? Colors.white
                      : UiColors.c99FFFFFF,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
