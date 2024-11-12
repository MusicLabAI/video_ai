import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_ai/common/global_data.dart';
import 'package:video_ai/common/ui_colors.dart';
import 'package:video_ai/models/shop_model.dart';
import 'package:video_ai/widgets/bottom_item.dart';
import 'package:video_ai/widgets/custom_button.dart';

class ProPurchasePage extends StatefulWidget {
  const ProPurchasePage({super.key});

  @override
  State<ProPurchasePage> createState() => _ProPurchasePageState();
}

class _ProPurchasePageState extends State<ProPurchasePage> {
  List<ShopModel>? _goodList = null;
  ShopModel? _currentItem;

  @override
  void initState() {
    super.initState();
    _goodList = [ShopModel(remark: '', point: 0, memberType: 1, shopType: 2, shopId: '221', shopName: 'week plan', price: 5, shopDescribe: "fjadsfkas", selected: false, status: 0), ShopModel(remark: '', point: 0, memberType: 1, shopType: 2, shopId: '23421', shopName: 'year plan', price: 67, shopDescribe: "的法师讲法", selected: false, status: 0), ];
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
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 14.0, top: 16, bottom: 16),
                child: GestureDetector(
                  onTap: () => Get.back(),
                  child: Image.asset('images/icon/img_pro_service_top.png'),
                ),
              ),
              Expanded(
                  child: SingleChildScrollView(
                      child: Column(
                children: [
                  Image.asset('images/icon/ic_close.png'),
                  Text(
                    'proService'.tr,
                    style: const TextStyle(
                        fontSize: 24,
                        color: UiColors.cDBFFFFFF,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    'proServiceDesc'.tr,
                    style: const TextStyle(
                        fontSize: 12,
                        color: UiColors.c99FFFFFF,
                        fontWeight: FontWeightExt.semiBold),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  _IconLabelWidget(label: 'ultraHdResolution'.tr),
                  const SizedBox(
                    height: 10,
                  ),
                  _IconLabelWidget(label: 'highPriorityGenerations'.tr),
                  const SizedBox(
                    height: 10,
                  ),
                  _IconLabelWidget(label: 'commercialUsePermitted'.tr),
                  const SizedBox(
                    height: 10,
                  ),
                  _IconLabelWidget(label: 'removeWatermark'.tr),
                  const SizedBox(
                    height: 24,
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
              ))),
              if (_goodList?.isNotEmpty == true)
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, top: 26, bottom: 16),
                  child: IconTextButton(
                    onTap: () => {},
                    text: 'subscribe'.tr,
                    textColor: UiColors.cDBFFFFFF,
                    icon: Image.asset(
                      'images/icon/ic_arrow_right.png',
                      width: 22,
                      height: 22,
                      color: Colors.white,
                    ),
                  ),
                ),
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
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.only(top: 16),
        decoration: BoxDecoration(
            border: Border.all(
                color: isSelected ? UiColors.cBC8EF5 : UiColors.c30333F,
                width: 2),
            borderRadius: BorderRadius.circular(12)),
        child: Stack(children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                model.shopName ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0, top: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      model.productDetails?.price ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: UiColors.c99FFFFFF,
                          fontSize: 12,
                          fontWeight: FontWeightExt.medium),
                    ),
                    Text(
                      model.productDetails?.price ?? '',
                      style: const TextStyle(
                          color: UiColors.cDBFFFFFF,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              Text(
                model.shopDescribe ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: UiColors.cDBFFFFFF,
                    fontSize: 12,
                    fontWeight: FontWeightExt.medium),
              ),
            ],
          ),
          Align(
            alignment: Alignment.topRight,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: const BoxDecoration(
                  color: UiColors.cBC8EF5,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(12),
                      bottomLeft: Radius.circular(12))),
              child: const Text(
                '88% OFF',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeightExt.semiBold),
              ),
            ),
          )
        ]),
      ),
    );
  }
}

class _IconLabelWidget extends StatelessWidget {
  const _IconLabelWidget({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset('images/icon/ic_checked.png'),
        const SizedBox(
          width: 10,
        ),
        Text(
          label,
          style: const TextStyle(
              color: UiColors.cDBFFFFFF,
              fontSize: 10,
              fontWeight: FontWeight.bold),
        )
      ],
    );
  }
}
