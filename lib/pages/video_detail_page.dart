import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_ai/common/download_utils.dart';
import 'package:video_ai/common/file_utils.dart';
import 'package:video_ai/common/global_data.dart';
import 'package:video_ai/common/ui_colors.dart';
import 'package:video_ai/models/record_model.dart';
import 'package:video_ai/pages/full_screen_player.dart';
import 'package:video_ai/widgets/custom_button.dart';
import 'package:video_ai/widgets/loading_dialog.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

import '../common/file_util.dart';

class VideoDetailPage extends StatefulWidget {
  const VideoDetailPage({super.key, required this.recordModel});

  final RecordModel recordModel;

  @override
  State<VideoDetailPage> createState() => _VideoDetailPageState();
}

class _VideoDetailPageState extends State<VideoDetailPage> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  late String? videoUrl;
  double _sliderValue = 0;
  bool _isSeeking = false;

  @override
  void initState() {
    super.initState();
    videoUrl = widget.recordModel.outputVideoUrl;
    _controller = VideoPlayerController.networkUrl(Uri.parse(videoUrl ?? ''))
      ..addListener(() {
        // 当视频播放时，实时更新Slider的进度
        if (!_isSeeking) {
          setState(() {
            _sliderValue = _controller.value.position.inSeconds.toDouble();
          });
        }
      });
    _initializeVideoPlayerFuture = _controller.initialize().then((_) {
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
              if (videoUrl?.isNotEmpty ?? false) {
                Get.dialog(const LoadingDialog());
                await FileUtil.saveFile(fileName: FileUtils.getFileNameFromUrl(videoUrl!), url: videoUrl!);
                // String? savePath = await DownloadUtils.downloadVideo(
                //     videoUrl!, FileUtils.getFileNameFromUrl(videoUrl!));
                // if (savePath?.isNotEmpty ?? false) {
                //   Fluttertoast.showToast(msg: 'downloadComplete'.tr);
                //   // Uri fileUri;
                //   // if (Platform.isAndroid) {
                //   //   // 使用 FileProvider 获取 content URI
                //   //   fileUri = Uri.parse("content://${GlobalData.packageName}.fileprovider" + savePath!);
                //   // } else {
                //   //   fileUri = Uri.file(savePath!);
                //   // }
                //   // if (await canLaunchUrl(fileUri)) {
                //   //   await launchUrl(fileUri);
                //   // } else {
                //   //   Get.log("无法打开该视频");
                //   // }
                // }
                if (Get.isDialogOpen ?? false) {
                  Get.back();
                }
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
              child: FutureBuilder(
                  future: _initializeVideoPlayerFuture,
                  builder: (context, snapshot) {
                    return Stack(alignment: Alignment.center, children: [
                      Visibility(
                        visible: snapshot.connectionState == ConnectionState.done,
                        child: AspectRatio(
                          aspectRatio: _controller.value.aspectRatio,
                          child: VideoPlayer(_controller),
                        ),
                      ),
                      Visibility(
                        visible: snapshot.connectionState != ConnectionState.done,
                        child: const CircularProgressIndicator(),
                      ),
                    ]);
                  }),
            ),
            Container(
              padding:
                  const EdgeInsets.only(left: 20, right: 20, top: 28, bottom: 24),
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
                          thumbShape:
                              const RoundSliderThumbShape(enabledThumbRadius: 5),
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
                      InkWell(
                        onTap: () {
                          Get.to(() => FullScreenPlayer(videoUrl: videoUrl!));
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