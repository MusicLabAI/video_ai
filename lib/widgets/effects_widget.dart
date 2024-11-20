import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_ai/controllers/create_controller.dart';
import 'package:video_ai/models/effects_model.dart';
import 'package:video_ai/widgets/custom_button.dart';

import '../common/ui_colors.dart';

class EffectsWidget extends StatefulWidget {
  const EffectsWidget(
      {super.key,
      required this.model,
      required this.onTap,
      this.padding,
      this.containerRadius,
      this.videoRadius,
      this.textSize,
      this.selectedColor,
      this.fromHome = true,
      this.unSelectedColor});

  final EffectsModel model;
  final Function(EffectsModel model) onTap;
  final double? padding;
  final double? containerRadius;
  final double? videoRadius;
  final double? textSize;
  final Color? selectedColor;
  final Color? unSelectedColor;
  final bool fromHome;

  @override
  State<EffectsWidget> createState() => _EffectsWidgetState();
}

class _EffectsWidgetState extends State<EffectsWidget>
    with WidgetsBindingObserver {
  CachedVideoPlayerPlusController? _controller;
  late String? videoUrl;
  final CreateController _createCtr = Get.find<CreateController>();

  bool _isPlaying = false;
  double? _lastVisibleFraction;
  Timer? _debounce;

  @override
  void initState() {
    videoUrl = widget.model.videoUrl;
    // WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  void _initializeVideo() {
    // _controller = CachedVideoPlayerPlusController.networkUrl(
    // Uri.parse(videoUrl ?? 'https://s.superinteractica.ai/lla/video/4d782f5e-33ae-4ed6-b320-688b9ffc6d58.mp4'),
    // videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true))
    _controller = CachedVideoPlayerPlusController.asset('videos/a.mp4',
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true))
      ..initialize().then((_) {
        setState(() {
          _controller!.play();
          _isPlaying = true;
          _controller!.setLooping(true);
          _controller!.setVolume(0.0);
        });
      });
  }

  void _disposeVideo() {
    _controller?.dispose();
    _controller = null;
    _isPlaying = false;
  }

  void _resumeVideo() {
    if (_isPlaying) {
      return;
    }
    _controller?.play();
    _isPlaying = true;
  }

  void _pauseVideo() {
    if (!_isPlaying) {
      return;
    }
    _controller?.pause();
    _isPlaying = false;
  }

  void _startDebounceWithCheck(double currentFraction) {
    Get.log("ffff 进入防抖任务: ${widget.model.id}", isError: true);
    if (_lastVisibleFraction == currentFraction) {
      return; // 如果比例没有变化，直接返回
    }

    _lastVisibleFraction = currentFraction;

    if (_debounce?.isActive ?? false) {
      Get.log("ffff 取消防抖任务: ${widget.model.id}", isError: true);
      _debounce!.cancel();
    }

    _debounce = Timer(const Duration(milliseconds: 50), () {
      Get.log("ffff 执行防抖任务: ${widget.model.id}", isError: true);
      if (currentFraction > 0.5) {
        Get.log("组件可见比例大于 0.5， 继续播放视频");
        if (_controller == null) {
          _initializeVideo();
        } else {
          _resumeVideo();
        }
      } else if (currentFraction < 0.1) {
        Get.log("组件可见比例小于 0.1， 释放视频");
        _disposeVideo();
      } else {
        Get.log("组件可见比例小于 0.5，大于0.1， 暂停视频");
        _pauseVideo();
      }
    });
  }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   super.didChangeAppLifecycleState(state);
  //   if (state == AppLifecycleState.inactive ||
  //       state == AppLifecycleState.paused) {
  //     Get.log("页面不可见");
  //     _disposeVideo();
  //   } else if (state == AppLifecycleState.resumed) {
  //     _initializeVideo();
  //     Get.log("页面重新可见");
  //   }
  // }

  // @override
  // void dispose() {
  //   print("aaaaaaa");
  //   WidgetsBinding.instance.removeObserver(this);
  //   _disposeVideo();
  //   _debounce?.cancel();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap.call(widget.model);
      },
      child: Obx(
        () => Container(
          decoration: BoxDecoration(
              color: widget.unSelectedColor ?? UiColors.c23242A,
              borderRadius: BorderRadius.circular(widget.containerRadius ?? 16),
              border: Border.all(
                  color: _createCtr.curEffects.value == widget.model
                      ? widget.selectedColor ?? Colors.transparent
                      : widget.unSelectedColor ?? Colors.transparent,
                  width: 1.5)),
          padding: EdgeInsets.all(widget.padding ?? 8.0),
          child: Column(
            children: [
              Expanded(
                  child: Stack(
                children: [
                  Positioned.fill(
                      child: ClipRRect(
                    borderRadius:
                        BorderRadius.circular(widget.videoRadius ?? 8),
                    child:
                        // _controller?.value.isInitialized == true
                        //     ? AspectRatio(
                        //         aspectRatio: _controller!.value.aspectRatio,
                        //         child: CachedVideoPlayerPlus(_controller!),
                        //       )
                        //     :
                        CachedNetworkImage(
                      imageUrl: videoUrl ?? "",
                      fit: BoxFit.cover,
                    ),
                  )),
                  if (widget.fromHome)
                    Positioned(
                      right: 4,
                      bottom: 6,
                      child: CustomButton(
                        borderRadius: BorderRadius.circular(8),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        bgColor: UiColors.cB8000000,
                        text: 'tryIt'.tr,
                        textColor: Colors.white,
                        textSize: 10,
                        leftIcon: Padding(
                            padding: const EdgeInsets.only(right: 4.0),
                            child: Image.asset(
                              'images/icon/ic_effects_unselected.png',
                              width: 16,
                            )),
                      ),
                    )
                ],
              )),
              SizedBox(
                height: widget.padding ?? 8,
              ),
              Text(
                widget.model.tag ?? '',
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: _createCtr.curEffects.value == widget.model
                        ? widget.selectedColor ?? Colors.white
                        : Colors.white,
                    fontSize: widget.textSize ?? 12,
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
      ),
    );
  }
}
