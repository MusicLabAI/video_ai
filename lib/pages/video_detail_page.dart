import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gallery_saver_plus/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_ai/common/firebase_util.dart';
import 'package:video_ai/common/ui_colors.dart';
import 'package:video_ai/controllers/mine_controller.dart';
import 'package:video_ai/models/record_model.dart';
import 'package:video_ai/pages/full_screen_player.dart';
import 'package:video_ai/widgets/custom_button.dart';
import 'package:video_ai/widgets/dialogs.dart';
import 'package:video_ai/widgets/loading_widget.dart';

import 'effects_detail_page.dart';

class VideoDetailPage extends StatefulWidget {
  const VideoDetailPage({super.key, required this.recordModel});

  final RecordModel recordModel;

  @override
  State<VideoDetailPage> createState() => _VideoDetailPageState();
}

class _VideoDetailPageState extends State<VideoDetailPage> {
  late CachedVideoPlayerPlusController _controller;
  late String? videoUrl;
  double _sliderValue = 0;
  bool _isSeeking = false;

  @override
  void initState() {
    super.initState();
    FireBaseUtil.logEventPageView(PageName.videoPlayPage);
    videoUrl = widget.recordModel.outputVideoUrl;
    _controller =
        CachedVideoPlayerPlusController.networkUrl(Uri.parse(videoUrl ?? ''))
          ..addListener(() {
            // 当视频播放时，实时更新Slider的进度
            if (!_isSeeking) {
              setState(() {
                _sliderValue = _controller.value.position.inSeconds.toDouble();
              });
            }
          })
          ..initialize().then((_) {
            setState(() {
              _controller.play();
            });
          });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            height: 443,
            child: Stack(
              children: [
                if (_controller.value.isInitialized)
                  Center(
                    child: AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: CachedVideoPlayerPlus(_controller),
                    ),
                  ),
                if (!_controller.value.isInitialized) const LoadingWidget(),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 240),
            height: 203,
            decoration: BoxDecoration(gradient: commonGradient),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 276.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _controller.value.isPlaying
                              ? _controller.pause()
                              : _controller.play();
                        });
                      },
                      child: Image.asset(
                        _controller.value.isPlaying
                            ? 'assets/images/ic_pause.png'
                            : 'assets/images/ic_play.png',
                        width: 40,
                        height: 40,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            thumbColor: Colors.white,
                            trackHeight: 4,
                            inactiveTrackColor: UiColors.c33FFFFFF,
                            thumbShape: const RoundSliderThumbShape(
                                enabledThumbRadius: 5),
                            // 修改滑块的半径
                            overlayShape: const RoundSliderOverlayShape(
                                overlayRadius: 16), // 修改滑块点击时的圆圈大小
                          ),
                          child: Slider(
                            value: _sliderValue,
                            min: 0.0,
                            max:
                                _controller.value.duration.inSeconds.toDouble(),
                            onChanged: (value) {
                              setState(() {
                                _sliderValue = value;
                                _isSeeking = true;
                              });
                            },
                            onChangeEnd: (value) {
                              setState(() {
                                _isSeeking = false;
                                _controller
                                    .seekTo(Duration(seconds: value.toInt()));
                              });
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 12.0),
                          child: Text(
                            "${_formatDuration(_controller.value.position)} / ${_formatDuration(_controller.value.duration)}",
                            style: TextStyle(
                                fontSize: 10,
                                color: UiColors.cB3B3B3,
                                fontWeight: FontWeightExt.medium),
                          ),
                        ),
                      ],
                    )),
                    const SizedBox(
                      width: 4,
                    ),
                    if (widget.recordModel.inputImageUrl?.isNotEmpty ?? false)
                      Container(
                        width: 68,
                        height: 68,
                        decoration: BoxDecoration(
                            color: UiColors.c99000000,
                            borderRadius: BorderRadius.circular(12)),
                        child: Stack(
                          children: [
                            Positioned(
                              child: Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            widget.recordModel.inputImageUrl!,
                                        fit: BoxFit.fitWidth,
                                      ))),
                            ),
                            Positioned(
                                bottom: 0,
                                right: 0,
                                child: GestureDetector(
                                    onTap: () {
                                      //放大图片
                                      Get.dialog(
                                        GestureDetector(
                                            onTap: () {
                                              Get.back();
                                            },
                                            child: CachedNetworkImage(
                                                imageUrl: widget.recordModel
                                                    .inputImageUrl!)),
                                      );
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Image.asset(
                                        "assets/images/ic_image_enlarge.png",
                                        width: 18,
                                      ),
                                    ))),
                          ],
                        ),
                      )
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.recordModel.effect ?? 'prompt'.tr,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    GestureDetector(
                        onTap: () {},
                        child: Image.asset(
                          'assets/images/ic_copy_with_bg.png',
                          width: 30,
                        ))
                  ],
                ),
                if (widget.recordModel.prompt?.isNotEmpty ?? true)
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Text(
                      widget.recordModel.prompt!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: UiColors.cDBFFFFFF, fontSize: 12),
                    ),
                  ),
                CustomButton(
                  margin: const EdgeInsets.symmetric(vertical: 24),
                  onTap: () {
                    Get.back(result: widget.recordModel);
                  },
                  text: "generateAgain".tr,
                  textColor: Colors.white,
                  textSize: 14,
                  bgColors: const [UiColors.c7631EC, UiColors.cA359EF],
                  width: double.infinity,
                  height: 46,
                ),
                Text(
                  'saveAndShare'.tr,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeightExt.semiBold),
                ),
                const SizedBox(
                  height: 24,
                ),
                Row(
                  children: [
                    Expanded(
                        child: CustomButton(
                      onTap: () {
                        download();
                      },
                      bgColor: UiColors.c2C2A2B,
                      text: 'save'.tr,
                      textColor: UiColors.cB3B3B3,
                      textSize: 12,
                      height: 44,
                      leftIcon: Padding(
                        padding: const EdgeInsets.only(right: 12.0),
                        child: Image.asset(
                          'assets/images/ic_download.png',
                          width: 20,
                        ),
                      ),
                    )),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: CustomButton(
                      onTap: () {
                        if (videoUrl?.isNotEmpty ?? false) {
                          Share.share(videoUrl!);
                        }
                        FireBaseUtil.logEventButtonClick(
                            PageName.videoPlayPage, 'share_video_button');
                        FireBaseUtil.logEvent(EventName.shareRequest);
                      },
                      text: 'share'.tr,
                      bgColor: UiColors.c2C2A2B,
                      textColor: UiColors.cB3B3B3,
                      textSize: 12,
                      height: 44,
                      leftIcon: Padding(
                        padding: const EdgeInsets.only(right: 12.0),
                        child: Image.asset(
                          'assets/images/ic_share.png',
                          width: 20,
                        ),
                      ),
                    )),
                  ],
                )
              ],
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Row(
                children: [
                  const SizedBox(
                    width: 16,
                  ),
                  GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Image.asset(
                        'assets/images/ic_back_with_bg.png',
                        width: 32,
                      )),
                  const Spacer(),
                  GestureDetector(
                      onTap: () {
                        Get.dialog(deleteConfirmDialog(() async {
                          await Get.find<MineController>()
                              .delete(widget.recordModel.id);
                          Get.back();
                        }));
                      },
                      child: Image.asset(
                        'assets/images/ic_delete_with_bg.png',
                        width: 32,
                      )),
                  Padding(
                    padding: const EdgeInsets.only(left: 12, right: 16),
                    child: GestureDetector(
                        onTap: () {
                          FireBaseUtil.logEventButtonClick(
                              PageName.videoPlayPage, 'full_screen_button');
                          Get.to(() => FullScreenPlayer(videoUrl: videoUrl!));
                        },
                        child: Image.asset(
                          'assets/images/ic_enlarge.png',
                          width: 32,
                        )),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> download() async {
    if (videoUrl?.isEmpty ?? true) {
      return;
    }
    FireBaseUtil.logEventButtonClick(
        PageName.videoPlayPage, 'download_video_button');
    try {
      if (GetPlatform.isIOS) {
        final addOnlyStatus = await Permission.photosAddOnly.request();
        if (!addOnlyStatus.isGranted) {
          final photoStatus = await Permission.photos.request();
          if (!photoStatus.isGranted) {
            Get.dialog(getRequestPermissionDialog('photoLibrarySaveText'.tr));
            return;
          }
        }
      }
      Get.dialog(const LoadingWidget());
      final result = await GallerySaver.saveVideo(videoUrl!);
      if (result ?? false) {
        FireBaseUtil.logEvent(EventName.saveCreation, parameters: {
          'workId': '$widget.recordModel.id',
          'video_url': widget.recordModel.outputVideoUrl ?? ''
        });
      }
      Get.back();
      Fluttertoast.showToast(
          msg: result ?? false ? 'saveVideoSuccess'.tr : 'saveVideoFail'.tr);
    } catch (e) {
      Get.log(e.toString(), isError: true);
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
      Fluttertoast.showToast(msg: 'saveVideoFail'.tr);
    }
  }

  // 格式化时间显示
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return [if (duration.inHours > 0) hours, minutes, seconds].join(':');
  }
}
