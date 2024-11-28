import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:video_ai/common/firebase_util.dart';
import 'package:video_ai/common/global_data.dart';
import 'package:video_ai/common/ui_colors.dart';
import 'package:video_ai/controllers/shop_controller.dart';
import 'package:video_ai/controllers/user_controller.dart';
import 'package:video_ai/models/shop_model.dart';
import 'package:video_ai/widgets/bottom_item.dart';
import 'package:video_ai/widgets/custom_button.dart';

class ProPurchasePage extends StatefulWidget {
  const ProPurchasePage({super.key});

  @override
  State<ProPurchasePage> createState() => _ProPurchasePageState();
}

class _ProPurchasePageState extends State<ProPurchasePage> {
  final ShopController _shopCtr = ShopController();
  final UserController _userCtr = Get.find<UserController>();
  bool _isSubmitted = false; //是否提交购买了
  Worker? _worker;
  late CachedVideoPlayerPlusController _controller;

  @override
  void initState() {
    super.initState();
    FireBaseUtil.logEventPageView(PageName.proPurchasePage);
    _getShops();

    ///处理登录后是会员的情况
    _worker = ever(_userCtr.userInfo, (userInfo) {
      if (_isSubmitted) {
        return;
      }
      if (userInfo.isVip == true) {
        Fluttertoast.showToast(msg: "noNeedsSubscribed".tr);
        Get.until((route) => Get.currentRoute == '/');
      }
    });
    _controller = CachedVideoPlayerPlusController.asset("videos/pro.mp4")
      ..initialize().then((_) {
        setState(() {
          _controller.setVolume(0);
          _controller.setLooping(true);
          _controller.play();
        });
      });
  }

  @override
  void dispose() {
    _isSubmitted = false;
    _controller.dispose();
    _worker?.dispose();
    super.dispose();
  }

  void _getShops() {
    _shopCtr.getShopList(GetPlatform.isAndroid
        ? ShopController.productProType
        : ShopController.iosProductProType);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          if (_controller.value.isInitialized)
            AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: CachedVideoPlayerPlus(_controller),
            ),
          Container(
            margin: const EdgeInsets.only(top: 160),
            height: 288,
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.transparent, Colors.black],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter)),
          ),
          SafeArea(
              child: Obx(
            () => Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(left: 14.0, top: 12, bottom: 12),
                  child: GestureDetector(
                    onTap: () => Get.back(),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Image.asset(
                        'images/icon/ic_close_with_bg.png',
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 152,
                            ),
                            Text(
                              'proService'.tr,
                              style: const TextStyle(
                                  fontSize: 24,
                                  color: UiColors.cDBFFFFFF,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            _IconLabelWidget(label: 'ultraHdResolution'.tr),
                            const SizedBox(
                              height: 8,
                            ),
                            _IconLabelWidget(
                                label: 'highPriorityGenerations'.tr),
                            const SizedBox(
                              height: 8,
                            ),
                            _IconLabelWidget(
                                label: 'commercialUsePermitted'.tr),
                            const SizedBox(
                              height: 16,
                            ),
                            if (_shopCtr.isInRequest.value)
                              const Padding(
                                  padding: EdgeInsets.only(top: 100),
                                  child: Center(
                                      child: CircularProgressIndicator()))
                            else if (_shopCtr.shopList.isEmpty)
                              RefreshWidget(
                                onRefresh: _getShops,
                              )
                            else
                              ..._shopCtr.shopList.map((e) => _buildItem(e)),
                          ],
                        ),
                      )),
                ),
                if (_shopCtr.shopList.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, top: 26, bottom: 16),
                    child: CustomButton(
                      width: double.infinity,
                      height: 46,
                      onTap: () {
                        if (!_userCtr.isLogin.value) {
                          _userCtr.showLogin();
                          return;
                        }
                        _isSubmitted = true;
                        _shopCtr.subscript('pro_purchase_page');
                      },
                      text: 'subscribe'.tr,
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
          ))
        ],
      ),
    );
  }

  Widget _buildItem(ShopModel model) {
    return GestureDetector(
      onTap: () => _shopCtr.currentShop.value = model,
      child: Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: Stack(children: [
          Obx(
            () => Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  border: Border.all(
                      color: _shopCtr.currentShop.value == model
                          ? UiColors.cBC8EF5
                          : UiColors.c30333F,
                      width: 2),
                  borderRadius: BorderRadius.circular(12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    model.shopNameLocal,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          model.shopSecondDescribeLocal,
                          style: const TextStyle(
                              color: UiColors.cDBFFFFFF,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                  Text(
                    model.shopDescribeLocal ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: UiColors.cDBFFFFFF,
                        fontSize: 12,
                        fontWeight: FontWeightExt.medium),
                  ),
                ],
              ),
            ),
          ),
          if (model.badgeContent.isNotEmpty)
            Align(
              alignment: Alignment.topRight,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: const BoxDecoration(
                    color: UiColors.cBC8EF5,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(12),
                        bottomLeft: Radius.circular(12))),
                child: Text(
                  model.badgeContent,
                  style: const TextStyle(
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
  const _IconLabelWidget({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(
          'images/icon/ic_checked.png',
          width: 16,
        ),
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

class RefreshWidget extends StatelessWidget {
  const RefreshWidget({super.key, required this.onRefresh, this.topPadding});

  final VoidCallback onRefresh;
  final double? topPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: topPadding ?? 100),
      child: GestureDetector(
        onTap: onRefresh,
        child: Column(
          children: [
            Image.asset(
              'images/icon/ic_refresh_shop.png',
              width: 60,
            ),
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  "shopRefreshTips".tr,
                  textAlign: TextAlign.center,
                  style:
                      const TextStyle(color: UiColors.cDBFFFFFF, fontSize: 14),
                ))
          ],
        ),
      ),
    );
  }
}
