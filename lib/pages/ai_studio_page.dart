import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_ai/common/firebase_util.dart';
import 'package:video_ai/common/ui_colors.dart';
import 'package:video_ai/controllers/old_create_controller.dart';
import 'package:video_ai/controllers/main_controller.dart';
import 'package:video_ai/models/example_model.dart';
import 'package:video_ai/pages/effects_detail_page.dart';
import 'package:video_ai/pages/settings_page.dart';
import 'package:video_ai/widgets/carousel_widget.dart';
import 'package:video_ai/widgets/prompt_list_view.dart';
import 'package:video_ai/widgets/user_info_widget.dart';

class AIStudioPage extends StatefulWidget {
  const AIStudioPage({super.key});

  @override
  State<AIStudioPage> createState() => _AIStudioPageState();
}

class _AIStudioPageState extends State<AIStudioPage>
    with AutomaticKeepAliveClientMixin {
  final OldCreateController _createCtr = Get.find<OldCreateController>();
  final MainController _mainCtr = Get.find<MainController>();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    FireBaseUtil.logEventPageView(PageName.aiStudioPage);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(children: [
            Obx(() => _mainCtr.jumpConfigs.value?.isEmpty ?? true
                ? const SizedBox()
                : AspectRatio(aspectRatio: 480/494,
                  child: CarouselWidget(
                      data: _mainCtr.jumpConfigs.value!,
                      showIndicator: true,
                    ),
                )),
            SafeArea(
                child: Column(
              mainAxisSize: MainAxisSize.min,
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
                              PageName.aiStudioPage, 'mine_button');
                        },
                        icon: Image.asset(
                          'assets/images/ic_user.png',
                          width: 24,
                          height: 24,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )),
          ]),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(
              'imageToVideo'.tr,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
          _bottomView(),
        ],
      )),
    );
  }

  @override
  bool get wantKeepAlive => true;

  Widget _bottomView() {
    return Obx(() {
      return GridView.builder(
        padding:
            const EdgeInsets.only(top: 16, left: 20, right: 20, bottom: 16),
        itemCount: _createCtr.effectsList.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 154 / 190,
          mainAxisSpacing: 16.0,
          crossAxisSpacing: 12.0,
        ),
        itemBuilder: (BuildContext context, int index) {
          final dataList =
              List<ExampleModel>.from(_createCtr.effectsList.value);
          ExampleModel model = dataList[index];
          return buildEffectsPromptItem(model, operate: "tryIt".tr,
              onItemClick: () {
            dataList.remove(model);
            dataList.insert(0, model);
            Get.to(() => EffectsDetailPage(
                  dataList: dataList,
                ));
          });
        },
      );
    });
  }
}
