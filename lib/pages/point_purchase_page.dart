import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_ai/common/global_data.dart';
import 'package:video_ai/common/ui_colors.dart';
import 'package:video_ai/models/shop_model.dart';
import 'package:video_ai/widgets/bottom_item.dart';
import 'package:video_ai/widgets/custom_button.dart';

class PointPurchasePage extends StatefulWidget {
  const PointPurchasePage({super.key});

  @override
  State<PointPurchasePage> createState() => _PointPurchasePageState();
}

class _PointPurchasePageState extends State<PointPurchasePage> {
  List<ShopModel>? _goodList = null;
  ShopModel? _currentItem;

  @override
  void initState() {
    super.initState();
    _goodList = [
      ShopModel(
          id: 1,
          remark: '',
          point: 0,
          memberType: 1,
          shopType: 2,
          shopId: '221',
          shopName: 'week plan',
          price: 5,
          shopDescribe: "fjadsfkas",
          selected: false,
          status: 0),
      ShopModel(
          id: 2,
          remark: '',
          point: 0,
          memberType: 1,
          shopType: 2,
          shopId: '23421',
          shopName: 'year plan',
          price: 67,
          shopDescribe: "的法师讲法",
          selected: false,
          status: 0),
    ];
    setState(() {
      _currentItem = _goodList![0];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UiColors.c121212,
      body: Stack(
        children: [
          Image.asset(
            'images/icon/img_pro_purchase_bg.png',
            fit: BoxFit.fitWidth,
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(left: 14.0, top: 16, bottom: 16),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: GestureDetector(
                      onTap: () => Get.back(),
                      child: Image.asset(
                        'images/icon/ic_close.png',
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
                        'images/icon/img_point_buy_top.png',
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
                      if (_goodList == null || _goodList!.isEmpty)
                        SizedBox(
                          height: 100,
                          child: _goodList == null
                              ? const Center(child: CircularProgressIndicator())
                              : null,
                        )
                      else
                        ..._goodList!.map((e) => _listItem(e)),
                    ],
                  ),
                ))),
                if (_goodList?.isNotEmpty == true)
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, top: 18, bottom: 16),
                    child: CustomButton(
                      width: double.infinity,
                      height: 46,
                      onTap: () => {},
                      text: 'purchase'.tr,
                      bgColors: const [UiColors.c7631EC, UiColors.cBC8EF5],
                      textColor: UiColors.cDBFFFFFF,
                      rightIcon: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Image.asset(
                          'images/icon/ic_arrow_right.png',
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
          )
        ],
      ),
    );
  }

  Widget _listItem(ShopModel model) {
    bool isSelected = _currentItem == model;
    return GestureDetector(
      onTap: () => setState(() {
        _currentItem = model;
      }),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        margin: const EdgeInsets.only(top: 12),
        decoration: BoxDecoration(
            color: UiColors.c2B2E38,
            border: Border.all(
                color: isSelected ? UiColors.cBC8EF5 : UiColors.c2B2E38,
                width: 2),
            borderRadius: BorderRadius.circular(12)),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    model.shopName ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: isSelected ? Colors.white : UiColors.c99FFFFFF,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Text(
                    model.shopDescribe ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: isSelected ? Colors.white : UiColors.c99FFFFFF,
                        fontSize: 12,
                        fontWeight: FontWeightExt.medium),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 12,
            ),
            Text(
              model.productDetails?.price ?? '',
              style: TextStyle(
                  color: isSelected ? Colors.white : UiColors.c99FFFFFF,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

String getWeekPrice(String priceText, int dividedNum) {
  if (dividedNum <= 1) {
    return priceText;
  }
  Pattern pattern = RegExp(r'\d');
  // 找到第一个和最后一个数字的位置
  int index = priceText.indexOf(pattern);
  int endIndex = priceText.lastIndexOf(pattern);

  // 如果找不到数字，则返回空字符串
  if (index == -1 || endIndex == -1) {
    return '';
  }

  // 提取单位部分
  String unit = index == 0
      ? priceText.substring(endIndex + 1)
      : priceText.substring(0, index);

  // 提取数值部分
  String value = priceText.substring(index, endIndex + 1);
  double? parsedValue = double.tryParse(value);
  if (parsedValue == null) {
    return '';
  }

  String result = (parsedValue / dividedNum).toStringAsFixed(2);
  return index == 0 ? "$result$unit" : "$unit$result";
}
