import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FullScreenPlayer extends StatefulWidget {
  final String videoUrl;

  const FullScreenPlayer({super.key, required this.videoUrl});

  @override
  State<FullScreenPlayer> createState() => _FullScreenPlayerState();
}

class _FullScreenPlayerState extends State<FullScreenPlayer> {
  late CachedVideoPlayerPlusController _controller;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();

    // 初始化 VideoPlayerController
    _controller = CachedVideoPlayerPlusController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {
          _isPlaying = true;
          _controller.play();
        });
      });

    // 隐藏状态栏和系统 UI 控件
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  @override
  void dispose() {
    _controller.dispose();

    // 恢复状态栏和系统 UI 控件
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.portraitUp,
    // ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        back();
        return false;
      },
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            alignment: Alignment.center,
            children: [
              _controller.value.isInitialized
                  ? GestureDetector(
                      onTap: () {
                        setState(() {
                          if (_controller.value.isPlaying) {
                            _controller.pause();
                            _isPlaying = false;
                          } else {
                            _controller.play();
                            _isPlaying = true;
                          }
                        });
                      },
                      child: Center(
                        child: AspectRatio(
                          aspectRatio: _controller.value.aspectRatio,
                          child: CachedVideoPlayerPlus(_controller),
                        ),
                      ),
                    )
                  : const Center(child: CircularProgressIndicator()),
              Positioned(
                top: 16,
                left: 0,
                child: IconButton(
                  icon: Image.asset(
                    'images/icon/ic_back.png',
                    width: 32,
                    height: 32,
                  ),
                  onPressed: back,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void back() {
    // 恢复状态栏和系统 UI 控件
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    // 确保 widget 仍然在树上后再进行返回
    if (mounted) {
      Navigator.pop(context);
    }
  }

// Future<void> initVideoController() async {
//   final file = await DefaultCacheManager().getSingleFile(widget.videoUrl);
//   // 初始化 VideoPlayerController
//   _controller = VideoPlayerController.file(file)
//     ..initialize().then((_) {
//       setState(() {
//         _isPlaying = true;
//         _controller!.play();
//       });
//     });
// }
}
