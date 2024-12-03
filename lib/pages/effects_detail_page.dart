import 'dart:io';

import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_ai/common/common_util.dart';
import 'package:video_ai/common/ui_colors.dart';
import 'package:video_ai/controllers/create_controller.dart';
import 'package:video_ai/models/effects_model.dart';
import 'package:video_ai/widgets/dialogs.dart';
import 'package:video_ai/widgets/effects_widget.dart';
import 'package:video_ai/widgets/loading_widget.dart';

import '../widgets/custom_button.dart';

class EffectsDetailPage extends StatefulWidget {
  EffectsDetailPage({super.key, required this.dataList});

  late EffectsModel curEffectsModel;
  final List<EffectsModel> dataList;

  @override
  State<EffectsDetailPage> createState() => _EffectsDetailPageState();
}

class _EffectsDetailPageState extends State<EffectsDetailPage> {
  late CachedVideoPlayerPlusController _controller;
  String? _pickImagePath;

  @override
  void initState() {
    super.initState();
    widget.curEffectsModel = widget.dataList[0];
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
  Future<void> _switchEffects(EffectsModel effectsModel) async {
    // 停止当前视频
    await _controller.pause();

    // 释放资源
    await _controller.dispose();

    // 更新视频 URL
    widget.curEffectsModel = effectsModel;

    // 重新初始化控制器
    _initController();

    setState(() {}); // 更新界面
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _selectImage(ImageSource source) async {
    String? path = await CommonUtil.pickUpImage(source);
    if (path != null) {
      setState(() {
        _pickImagePath = path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
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
                                      child:
                                          CachedVideoPlayerPlus(_controller)),
                                if (!_controller.value.isInitialized ||
                                    _controller.value.isBuffering)
                                  const Positioned.fill(child: LoadingWidget())
                              ],
                            )),
                        Container(
                          margin: const EdgeInsets.only(top: 180),
                          height: 180,
                          decoration: BoxDecoration(gradient: commonGradient),
                        ),
                        Positioned(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 20.0, right: 20.0, top: 252.0),
                              child: Text(
                                widget.curEffectsModel.tag ?? "",
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 20.0, right: 20.0, top: 12.0),
                              child: Text(
                                widget.curEffectsModel.value ?? "",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    color: UiColors.cDBFFFFFF, fontSize: 12),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 24),
                              child: SizedBox(
                                width: double.infinity,
                                height: 160,
                                child: ListView.builder(
                                    itemCount: widget.dataList.length,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      return Container(
                                          width: 116,
                                          height: 160,
                                          margin: EdgeInsets.only(
                                              left: index == 0 ? 20 : 8,
                                              right: index ==
                                                      widget.dataList.length - 1
                                                  ? 20
                                                  : 0),
                                          child: EffectsWidget(
                                              isSelected:
                                                  widget.curEffectsModel ==
                                                      widget.dataList[index],
                                              isShowTry: false,
                                              selectedColor: UiColors.cA754FC,
                                              model: widget.dataList[index],
                                              containerRadius: 12,
                                              innerRadius: 6,
                                              padding: 6,
                                              onItemClick: (model) {
                                                _switchEffects(model);
                                              }));
                                    }),
                              ),
                            ),
                            // Spacer(),
                            GestureDetector(
                              onTap: () {
                                Get.bottomSheet(uploadImageDialog(() {
                                  _selectImage(ImageSource.camera);
                                }, () {
                                  _selectImage(ImageSource.gallery);
                                }));
                              },
                              child: Container(
                                  width: double.infinity,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  decoration: BoxDecoration(
                                      color: UiColors.c1B1B1F,
                                      borderRadius: BorderRadius.circular(8)),
                                  height: 180,
                                  child: _pickImagePath == null
                                      ? Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              'assets/images/img_pick_up.png',
                                              width: 46,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8.0,
                                                  left: 20,
                                                  right: 20),
                                              child: Text(
                                                'uploadImageTips'.tr,
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                    color: UiColors.c61FFFFFF,
                                                    fontSize: 12),
                                              ),
                                            ),
                                          ],
                                        )
                                      : Stack(
                                          children: [
                                            Positioned.fill(
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                child: Image(
                                                  image: FileImage(
                                                      File(_pickImagePath!)),
                                                  fit: BoxFit.fitWidth,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                  color: UiColors.black_20,
                                                  borderRadius:
                                                      BorderRadius.circular(8)),
                                            ),
                                            Positioned(
                                                right: 8,
                                                top: 8,
                                                child: GestureDetector(
                                                  onTap: () => setState(() {
                                                    _pickImagePath = null;
                                                  }),
                                                  child: Image.asset(
                                                    "assets/images/ic_close_with_bg.png",
                                                    width: 24,
                                                  ),
                                                )),
                                          ],
                                        )),
                            ),
                          ],
                        ))
                      ],
                    ),
                  ],
                ),
              ),
            ),
            CustomButton(
              margin: const EdgeInsets.only(
                  top: 20, left: 20, right: 20, bottom: 18),
              onTap: () async {
                if (widget.curEffectsModel.isRepaired) {
                  Fluttertoast.showToast(msg: 'repairedTips'.tr);
                  return;
                }
                if (_pickImagePath?.isEmpty ?? true) {
                  Fluttertoast.showToast(msg: 'uploadImageEmptyTips'.tr);
                  return;
                }
                bool result = await Get.find<CreateController>()
                    .aiGenerate("", _pickImagePath!, widget.curEffectsModel.id);
                if (result) {
                  Get.back();
                }
              },
              text: 'createTheSameEffect'.tr,
              textColor: UiColors.cDBFFFFFF,
              bgColors: widget.curEffectsModel.isRepaired
                  ? const [UiColors.c4DA754FC, UiColors.c4DA754FC]
                  : const [UiColors.c7631EC, UiColors.cA359EF],
              width: double.infinity,
              height: 46,
              textSize: 16,
            )
          ],
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

LinearGradient get commonGradient {
  return const LinearGradient(
      colors: [Colors.transparent, Colors.black],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter);
}
