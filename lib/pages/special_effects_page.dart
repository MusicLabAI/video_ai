import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_ai/common/firebase_util.dart';
import 'package:video_ai/common/ui_colors.dart';
import 'package:video_ai/controllers/create_controller.dart';
import 'package:video_ai/pages/settings_page.dart';
import 'package:video_ai/widgets/carousel_widget.dart';
import 'package:video_ai/widgets/effects_widget.dart';
import 'package:video_ai/widgets/user_info_widget.dart';

class SpecialEffectsPage extends StatefulWidget {
  const SpecialEffectsPage({super.key});

  @override
  State<SpecialEffectsPage> createState() => _SpecialEffectsPageState();
}

class _SpecialEffectsPageState extends State<SpecialEffectsPage>
    with AutomaticKeepAliveClientMixin {
  final CreateController _createCtr = Get.find<CreateController>();
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final List<Map<String, String>> carouselData = [
      {
        "image": "https://placebear.com/400/300",
        "title": "Title 1: Beautiful Landscape",
        "text":
            "Slide 1: Beautiful LandscapeSlide 1: Beautiful Landscape Slide 1: Beautiful Landscape Slide 1: Beautiful Landscape Slide 1: Beautiful Landscape"
      },
      {
        "image": "https://picsum.photos/800/600",
        "title": "Title 2: Amazing Scenery",
        "text": "Slide 1:"
      },
      {
        "image": "https://placebear.com/400/300",
        "title": "Title 3: Nature at Its Best",
        "text": "Slide 1: Beautiful Landscape"
      },
    ];

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          CarouselWidget(
            data: carouselData,
            height: 443.0,
            autoPlayInterval: const Duration(seconds: 5),
            showIndicator: true,
          ),
          SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: Colors.transparent,
                padding: const EdgeInsets.only(left: 16),
                height: 56,
                width: double.infinity,
                child: Row(
                  children: [
                    const Text(
                      'Video AI',
                      style: TextStyle(
                        fontSize: 20,
                        color: UiColors.cDBFFFFFF,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    UserInfoWidget(),
                    IconButton(
                      onPressed: () {
                        Get.to(() => const SettingsPage());
                        FireBaseUtil.logEventButtonClick(
                            PageName.specialEffectsPage, 'mine_button');
                      },
                      icon: Image.asset(
                        'images/icon/ic_user.png',
                        width: 24,
                        height: 24,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 280, bottom: 20),
                child: Text(
                  'imageToVideo'.tr,
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
              Expanded(child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: _bottomView(),
              )),
            ],
          )),
          // 顶部导航和用户信息部分
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  Widget _bottomView() {
    return Obx(() {
      return GridView.builder(
        itemCount: _createCtr.effectsList.length,
        // shrinkWrap: false,
        // physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 154 / 212,
          mainAxisSpacing: 16.0,
          crossAxisSpacing: 12.0,
        ),
        itemBuilder: (BuildContext context, int index) {
          return EffectsWidget(
            model: _createCtr.effectsList[index],
            onTap: (model) {
              _createCtr.selectEffects(model);
            },
          );
        },
      );
    });
  }
}
