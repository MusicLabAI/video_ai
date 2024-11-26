import 'dart:async';
import 'package:flutter/material.dart';

class CarouselWidget extends StatefulWidget {
  final List<Map<String, String>> data; // 轮播图数据
  final double height; // 轮播图高度
  final Duration autoPlayInterval; // 自动播放间隔
  final bool showIndicator; // 是否显示指示器

  const CarouselWidget({
    super.key,
    required this.data,
    this.height = 200.0,
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
    _startAutoPlay(); // 启动自动播放
  }

  void _startAutoPlay() {
    if (widget.autoPlayInterval > Duration.zero) {
      _timer?.cancel();
      _timer = Timer.periodic(widget.autoPlayInterval, (timer) {
        int nextPage = (_currentPage + 1) % widget.data.length;
        if (nextPage > widget.data.length - 1) {
          nextPage = 0;
        }
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
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemBuilder: (context, index) {
                return Center(
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Image.network(
                          widget.data[index]["image"] ?? '',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            color: Colors.grey,
                            child: const Center(child: Text('Image not found')),
                          ),
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
                                Colors.transparent,  // 顶部透明
                                Colors.black.withOpacity(1),  // 底部渐变至黑色，透明度为50%
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 20,
                        right: 20,
                        bottom: 123,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.data[index]['title'] ?? '',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.only(right: 12),
                                    child: Text(
                                      widget.data[index]['text'] ?? '',
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                  ),
                                  )
                                ),
                                // const Spacer(),
                                ElevatedButton(
                                  onPressed: () {
                                    // 按钮点击逻辑
                                  },
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.black, backgroundColor: Colors.white,
                                    padding: const EdgeInsets.only(left: 14, right: 14, top: 8, bottom: 8),
                                    textStyle: const TextStyle(
                                      fontSize: 12, // 字号
                                      fontWeight: FontWeight.w600, // 字体加粗
                                    )
                                  ),
                                  child: const Text('Try Now'),
                                ),
                              ],
                            )
                          ],
                        )
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
        if (widget.showIndicator)
        Positioned(
          left: 20,
          bottom: 107,
          height: 4,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
            child: Row(        
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                widget.data.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 20,
                  height: 4,
                  decoration: BoxDecoration(
                    color: _currentPage == index ? Colors.white : Colors.transparent,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
          )
        ),
      ],
    );
  }
}

