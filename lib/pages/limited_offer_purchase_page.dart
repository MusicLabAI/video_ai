import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_ai/common/firebase_util.dart';
import 'package:video_ai/common/global_data.dart';
import 'package:video_ai/common/ui_colors.dart';
import 'package:video_ai/models/shop_model.dart';
import 'package:video_ai/widgets/bottom_item.dart';
import 'package:video_ai/widgets/custom_button.dart';

import '../widgets/limited_offer_desc_widget.dart';

class LimitedOfferPurchasePage extends StatefulWidget {
  const LimitedOfferPurchasePage(
      {super.key, required this.isYearPlan, required this.shopModel});

  final bool isYearPlan;
  final ShopModel shopModel;

  @override
  State<LimitedOfferPurchasePage> createState() =>
      _LimitedOfferPurchasePageState();
}

class _LimitedOfferPurchasePageState extends State<LimitedOfferPurchasePage> {
  @override
  void initState() {
    super.initState();
    FireBaseUtil.logEventPageView(PageName.proPurchasePage);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            widget.isYearPlan
                ? "assets/images/img_limited_offer_bg1.png"
                : "assets/images/img_limited_offer_bg2.png",
            fit: BoxFit.fitWidth,
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(left: 14.0, top: 12, bottom: 12),
                  child: GestureDetector(
                    onTap: () => Get.back(),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Image.asset(
                        'assets/images/ic_close.png',
                        width: 32,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 240,
                            ),
                            Text(
                              widget.isYearPlan
                                  ? 'superValueAnnuallyPlan'.tr
                                  : 'superValueCreditsRefill'.tr,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 22,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 16.0, bottom: 20),
                              child: LimitedOfferDescWidget(
                                  shopModel: widget.shopModel),
                            ),
                            _buildItem(widget.shopModel)
                          ],
                        ),
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, top: 26, bottom: 16),
                  child: CustomButton(
                    width: double.infinity,
                    height: 46,
                    onTap: () {
                      GlobalData.buyShop.submit(widget.shopModel,
                          widget.isYearPlan, 'limited_offer_purchase_page');
                    },
                    text: widget.isYearPlan ? 'subscribe'.tr : 'purchase'.tr,
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
                if (widget.isYearPlan)
                  Text(
                    'subscribeTips'.tr,
                    style: TextStyle(
                        fontWeight: FontWeightExt.medium,
                        color: UiColors.cBC8EF5,
                        fontSize: 12),
                  ),
                BottomItem(
                  text: 'restore'.tr,
                  onTap: () {
                    GlobalData.buyShop.resumePurchase();
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildItem(ShopModel model) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 4),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: const LinearGradient(
                  colors: [UiColors.cA359EF, UiColors.c7631EC],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 50.0),
                child: Text(
                  'limitedOffer'.tr,
                  style: const TextStyle(
                      fontSize: 12,
                      color: UiColors.cDFC5FF,
                      fontWeight: FontWeightExt.semiBold),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: UiColors.cA754FC, width: 2),
                    color: UiColors.c171C26),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        model.productDetails?.title ?? "",
                        style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeightExt.semiBold),
                      ),
                    ),
                    Column(
                      children: [
                        Text(
                          model.productDetails?.price ?? "",
                          style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeightExt.semiBold),
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        Text(
                          model.getUnitPrice(
                              model.productDetails?.price ?? "", 6,
                              isMultiply: true),
                          style: const TextStyle(
                              fontSize: 12,
                              color: UiColors.c61FFFFFF,
                              fontWeight: FontWeightExt.semiBold,
                              decoration: TextDecoration.lineThrough,
                              decorationColor: UiColors.c61FFFFFF),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 14.0),
          child: Image.asset(
            'assets/images/img_lightning.png',
            width: 32,
            height: 38,
          ),
        )
      ],
    );
  }
}
