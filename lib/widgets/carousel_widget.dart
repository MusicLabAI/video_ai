import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_ai/common/common_util.dart';
import 'package:video_ai/controllers/create_controller.dart';
import 'package:video_ai/controllers/main_controller.dart';
import 'package:video_ai/models/jump_config_model.dart';
import 'package:video_ai/pages/effects_detail_page.dart';
import 'package:video_ai/pages/point_purchase_page.dart';
import 'package:video_ai/pages/pro_purchase_page.dart';
import 'package:video_ai/pages/prompt_detail_page.dart';
import 'package:video_ai/widgets/custom_button.dart';
import 'package:video_ai/widgets/loading_widget.dart';

class CarouselWidget extends StatefulWidget {
  final List<JumpConfigModel> data; // 轮播图数据
  final double height; // 轮播图高度
  final Duration autoPlayInterval; // 自动播放间隔
  final bool showIndicator; // 是否显示指示器

  const CarouselWidget({
    super.key,
    required this.data,
    this.height = 360.0,
    this.autoPlayInterval = const Duration(seconds: 3),
    this.showIndicator = true,
  });

  @override
  _CarouselWidgetState createState() => _CarouselWidgetState();
}

class _CarouselWidgetState extends State<CarouselWidget> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startAutoPlay();
  }

  void _startAutoPlay() {
    if (widget.autoPlayInterval > Duration.zero) {
      _timer?.cancel();
      _timer = Timer.periodic(widget.autoPlayInterval, (_) {
        int nextPage = (_currentPage + 1) % widget.data.length;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      });
    }
  }

  void _stopAutoPlay() {
    _timer?.cancel();
  }

  void _handlePageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
    _resumeVideoForPage(index);
    _startAutoPlay();
  }

  void _resumeVideoForPage(int index) {
    // 暂停其他页面的视频，仅播放当前页面的视频
    for (var i = 0; i < widget.data.length; i++) {
      if (i == index) {
        // 通知 VideoWidget 播放
        VideoWidgetState.notifyPlay(i);
      } else {
        // 通知 VideoWidget 暂停
        VideoWidgetState.notifyPause(i);
      }
    }
  }

  @override
  void dispose() {
    _stopAutoPlay();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onPanDown: (_) => _stopAutoPlay(),
          onPanEnd: (_) => _startAutoPlay(),
          child: SizedBox(
            height: widget.height,
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.data.length,
              onPageChanged: _handlePageChanged,
              itemBuilder: (context, index) {
                return CarouselPage(
                  data: widget.data[index],
                  pageIndex: index,
                );
              },
            ),
          ),
        ),
        if (widget.showIndicator)
          Positioned(
            bottom: 24,
            left: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                widget.data.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage == index ? 20 : 12,
                  height: 4,
                  decoration: BoxDecoration(
                    color: _currentPage == index ? Colors.white : Colors.grey,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class CarouselPage extends StatelessWidget {
  final JumpConfigModel data;
  final int pageIndex;
  final CreateController _createCtr = Get.find<CreateController>();

  CarouselPage({
    super.key,
    required this.data,
    required this.pageIndex,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (data.targetType == 3 || data.targetType == 4) {
          if (data.effectId == null) {
            return;
          }
          if (data.targetType == 3) {
            final list = _createCtr.promptItems.value;
            if (list.isEmpty) {
              return;
            }
            final item =
                list.firstWhereOrNull((item) => item.id == data.effectId);
            if (item != null) {
              list.remove(item);
              list.insert(0, item);
            }
            Get.to(() => PromptDetailPage(dataList: list));
          } else {
            final list = _createCtr.effectsList.value;
            if (list.isEmpty) {
              return;
            }
            final item =
                list.firstWhereOrNull((item) => item.id == data.effectId);
            if (item != null) {
              list.remove(item);
              list.insert(0, item);
            }
            Get.to(() => EffectsDetailPage(dataList: list));
          }
        } else if (data.targetType == 5) {
          Get.find<MainController>().tabController.index == 1;
        } else if (data.targetType == 6) {
          Get.to(() => const ProPurchasePage());
        } else if (data.targetType == 7) {
          Get.to(() => const PointPurchasePage());
        } else {
          CommonUtil.openUrl(data.target);
        }
      },
      child: Stack(children: [
        if (data.coverType == 1 || data.coverType == 2)
          Positioned.fill(
            child: CachedNetworkImage(
                imageUrl: data.coverUrl ?? '', fit: BoxFit.cover),
          ),
        if (data.coverType == 3)
          Positioned.fill(
            child: VideoWidget(
              videoUrl: "https://s.superinteractica.ai/lla/tag/Crumble+it.mp4",
              pageIndex: pageIndex,
            ),
          ),
        // 渐变覆盖层
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              // 使用 LinearGradient 创建垂直渐变
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent, // 顶部透明
                  Colors.black.withOpacity(1), // 底部渐变至黑色，透明度为50%
                ],
              ),
            ),
          ),
        ),
        Positioned(
            left: 20,
            right: 20,
            bottom: 40,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.title ?? '',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: Row(
                    children: [
                      Expanded(
                          child: Text(
                        data.description ?? '',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      )),
                      const SizedBox(
                        width: 12,
                      ),
                      if (data.enTry ?? false)
                        CustomButton(
                          text: 'tryNow'.tr,
                          textSize: 12,
                          textColor: Colors.black,
                          bgColor: Colors.white,
                          borderRadius: BorderRadius.circular(256),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 8),
                        ),
                    ],
                  ),
                ),
              ],
            ))
      ]),
    );
  }
}

class VideoWidget extends StatefulWidget {
  final String videoUrl;
  final int pageIndex;

  const VideoWidget({
    super.key,
    required this.videoUrl,
    required this.pageIndex,
  });

  @override
  VideoWidgetState createState() => VideoWidgetState();
}

class VideoWidgetState extends State<VideoWidget> {
  static final Map<int, VideoWidgetState> _instances = {};

  late CachedVideoPlayerPlusController _controller;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _controller = CachedVideoPlayerPlusController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {
          _controller.setLooping(true);
          _controller.setVolume(0);
        });
      });
    _instances[widget.pageIndex] = this;
  }

  static void notifyPlay(int pageIndex) {
    _instances.forEach((index, state) {
      if (index == pageIndex) {
        state._play();
      } else {
        state._pause();
      }
    });
  }

  static void notifyPause(int pageIndex) {
    _instances[pageIndex]?._pause();
  }

  void _play() {
    if (!_isPlaying && mounted) {
      _controller.play();
      _isPlaying = true;
    }
  }

  void _pause() {
    if (_isPlaying && mounted) {
      _controller.pause();
      _isPlaying = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(child: CachedVideoPlayerPlus(_controller)),
        if (!_controller.value.isInitialized)
          const Positioned.fill(child: LoadingWidget())
      ],
    );
  }

  @override
  void dispose() {
    _instances.remove(widget.pageIndex);
    _controller.dispose();
    super.dispose();
  }
}
