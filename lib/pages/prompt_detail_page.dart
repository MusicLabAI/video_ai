import 'dart:math';

import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:video_ai/common/ui_colors.dart';
import 'package:video_ai/controllers/create_controller.dart';
import 'package:video_ai/models/effects_model.dart';
import 'package:video_ai/widgets/prompt_list_view.dart';

import '../widgets/custom_button.dart';
import '../widgets/loading_widget.dart';
import 'effects_detail_page.dart';

class PromptDetailPage extends StatefulWidget {
  PromptDetailPage(
      {super.key, required this.dataList, required this.curEffectsModel});

  late EffectsModel curEffectsModel;
  final List<EffectsModel> dataList;

  @override
  State<PromptDetailPage> createState() => _EffectsDetailPageState();
}

class _EffectsDetailPageState extends State<PromptDetailPage> {
  late CachedVideoPlayerPlusController _controller;
  bool _isExpand = false;
  final CreateController _createCtr = Get.find<CreateController>();
  late List<EffectsModel> randomList;

  @override
  void initState() {
    super.initState();
    refreshRandomList();
    _initController();
  }

  _initController() {
    _controller = CachedVideoPlayerPlusController.networkUrl(
        Uri.parse(widget.curEffectsModel.videoUrl ?? ""))
      ..initialize().then((_) {
        setState(() {
          _controller.setLooping(true);
          _controller.play();
        });
      })
      ..addListener(() {
        setState(() {});
      });
  }

  // 动态切换视频 URL
  Future<void> _switchVideo(EffectsModel effectsModel) async {
    // 停止当前视频
    await _controller.pause();

    // 释放资源
    await _controller.dispose();

    // 更新视频 URL
    widget.curEffectsModel = effectsModel;
    refreshRandomList();

    // 重新初始化控制器
    _initController();
    setState(() {});
  }

  void refreshRandomList() {
    randomList = List.from(widget.dataList); // 确保是一个副本，避免直接修改原列表
    randomList.remove(widget.curEffectsModel); // 移除当前的 effectsModel
    // 随机打乱 list
    randomList.shuffle(Random());
    // 获取前四条数据
    randomList = randomList.length > 4 ? randomList.sublist(0, 4) : randomList;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  AspectRatio(
                      aspectRatio: 408 / 389,
                      child: Stack(
                        children: [
                          if (_controller.value.isInitialized)
                            Positioned.fill(
                                child: CachedVideoPlayerPlus(_controller)),
                          if (!_controller.value.isInitialized ||
                              _controller.value.isBuffering)
                            const Positioned.fill(child: LoadingWidget()),
                          Positioned(
                              top: 180,
                              left: 0,
                              right: 0,
                              bottom: 0,
                              child: Container(
                                  decoration:
                                      BoxDecoration(gradient: commonGradient))),
                        ],
                      )),
                  Positioned(
                      child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                width: double.infinity,
                                height: 252.0,
                              ),
                              Row(
                                children: [
                                  Text(
                                    "prompt".tr,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _isExpand = !_isExpand;
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0, vertical: 5),
                                      child: Image.asset(
                                        _isExpand
                                            ? "assets/images/ic_up.png"
                                            : "assets/images/ic_down.png",
                                        width: 20,
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  GestureDetector(
                                    child: Image.asset(
                                      "assets/images/ic_copy_with_bg.png",
                                      width: 30,
                                    ),
                                    onTap: () {
                                      Clipboard.setData(ClipboardData(
                                          text:
                                              "${widget.curEffectsModel.tag}"));
                                      Fluttertoast.showToast(
                                          msg: 'copySucceed'.tr);
                                    },
                                  )
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 12.0),
                                child: Text(
                                  widget.curEffectsModel.tag ?? "",
                                  maxLines: _isExpand ? 50 : 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      color: UiColors.cDBFFFFFF, fontSize: 12),
                                ),
                              ),
                              CustomButton(
                                margin: const EdgeInsets.only(top: 24),
                                onTap: () {
                                  _createCtr.selectEffects(
                                      widget.curEffectsModel,
                                      index: 1);
                                  Get.back();
                                },
                                text: 'tryThisPrompt'.tr,
                                textColor: UiColors.cDBFFFFFF,
                                bgColors: const [
                                  UiColors.c7631EC,
                                  UiColors.cA359EF
                                ],
                                width: double.infinity,
                                height: 46,
                                textSize: 16,
                              ),
                              SafeArea(
                                top: false,
                                child: PromptListView(
                                  dataList: randomList,
                                  onItemClick: (model) {
                                    _switchVideo(model);
                                  },
                                  onClick: (model) {
                                    _createCtr.selectEffects(model, index: 1);
                                    Get.back();
                                  },
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              )
                            ],
                          )))
                ],
              ),
            ],
          ),
        ),
        SafeArea(
          child: GestureDetector(
            onTap: () => Get.back(),
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 12, bottom: 12),
              child: Image.asset(
                'assets/images/ic_close_with_bg.png',
                width: 32,
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
