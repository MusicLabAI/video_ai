import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gallery_saver_plus/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_ai/common/file_utils.dart';
import 'package:video_ai/common/ui_colors.dart';
import 'package:video_ai/models/record_model.dart';
import 'package:video_ai/pages/full_screen_player.dart';
import 'package:video_ai/widgets/custom_button.dart';
import 'package:video_ai/widgets/dialogs.dart';
import 'package:video_ai/widgets/loading_dialog.dart';
import 'package:video_ai/common/firebase_util.dart';

import '../common/file_util.dart';

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
    FireBaseUtil.logEventPageView('video_play_page');
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
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Image.asset(
            'images/icon/ic_close.png',
            width: 24,
            height: 24,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              if (videoUrl?.isEmpty ?? true) {
                return;
              }
              FireBaseUtil.logEventButtonClick(
                  'video_play_page', 'download_video_button');
              try {
                if (GetPlatform.isIOS) {
                  final addOnlyStatus = await Permission.photosAddOnly
                      .request();
                  if (!addOnlyStatus.isGranted) {
                    final photoStatus = await Permission.photos.request();
                    if (!photoStatus.isGranted) {
                      Get.dialog(
                          getRequestPermissionDialog(
                              'photoLibrarySaveText'.tr));
                      return;
                    }
                  }
                }
                Get.dialog(const LoadingDialog());
                final result = await GallerySaver.saveVideo(videoUrl!);
                if (result ?? false) {
                  FireBaseUtil.logEvent(EventName.saveCreation, parameters: {'workId': '$widget.recordModel.id', 'video_url': widget.recordModel.outputVideoUrl ?? ''});
                }
                Get.back();
                Fluttertoast.showToast(
                    msg: result ?? false
                        ? 'saveVideoSuccess'.tr
                        : 'saveVideoFail'.tr);
              } catch (e) {
                Get.log(e.toString(), isError: true);
                if (Get.isDialogOpen ?? false) {
                  Get.back();
                }
                Fluttertoast.showToast(msg: 'saveVideoFail'.tr);
              }
            },
            icon: Image.asset(
              'images/icon/ic_download.png',
              width: 24,
              height: 24,
            ),
          ),
          IconButton(
            onPressed: () {
              if (videoUrl?.isNotEmpty ?? false) {
                Share.share(videoUrl!);
              }
              FireBaseUtil.logEventButtonClick(
                  'video_play_page', 'share_video_button');
              FireBaseUtil.logEvent(EventName.shareRequest);
            },
            icon: Image.asset(
              'images/icon/ic_share.png',
              width: 24,
              height: 24,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: _controller.value.isInitialized
                    ? AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: CachedVideoPlayerPlus(_controller),
                      )
                    : const CircularProgressIndicator(),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(
                  left: 20, right: 20, top: 28, bottom: 24),
              decoration: const BoxDecoration(
                  color: UiColors.c171C26,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.recordModel.prompt ?? "",
                    style: TextStyle(
                        fontSize: 10,
                        color: UiColors.cB3B3B3,
                        fontWeight: FontWeightExt.medium),
                  ),
                  const SizedBox(
                    height: 26,
                  ),
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            _controller.value.isPlaying
                                ? _controller.pause()
                                : _controller.play();
                          });
                        },
                        borderRadius: BorderRadius.circular(256),
                        child: Image.asset(
                          _controller.value.isPlaying
                              ? 'images/icon/ic_pause.png'
                              : 'images/icon/ic_play.png',
                          width: 32,
                          height: 32,
                        ),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(
                          child: SliderTheme(
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
                          max: _controller.value.duration.inSeconds.toDouble(),
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
                      )),
                      Text(
                        _formatDuration(_controller.value.duration) ?? "",
                        style: TextStyle(
                            fontSize: 10,
                            color: UiColors.cB3B3B3,
                            fontWeight: FontWeightExt.medium),
                      ),
                      const SizedBox(
                        width: 24,
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.to(() => FullScreenPlayer(videoUrl: videoUrl!));
                          FireBaseUtil.logEventButtonClick(
                              'video_play_page', 'full_screen_button');
                        },
                        child: Image.asset(
                          'images/icon/ic_enlarge.png',
                          width: 24,
                          height: 24,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  CustomButton(
                    width: double.infinity,
                    height: 46,
                    text: 'tryVideo'.tr,
                    textColor: Colors.white,
                    bgColors: const [UiColors.c7631EC, UiColors.cA359EF],
                    onTap: () {
                      Get.back(result: widget.recordModel);
                    },
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
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
