import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class VideoWidget extends StatefulWidget {
  final String url;
  final bool isLopper;
  final double volume;
  final String? fromPosition;

  const VideoWidget(
      {super.key,
      required this.url,
      this.isLopper = true,
      this.volume = 0,
      this.fromPosition});

  @override
  State<VideoWidget> createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  late CachedVideoPlayerPlusController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    _controller =
        CachedVideoPlayerPlusController.networkUrl(Uri.parse(widget.url));
    _initializeVideoPlayerFuture = _controller.initialize().then((_) {
      setState(() {});
    });

    _controller.play();
    _controller.setVolume(widget.volume);
    _controller.setLooping(widget.isLopper);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(VideoWidget oldWidget) {
    _controller.play();
    _controller.setLooping(true);
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      onVisibilityChanged: (visibilityInfo) {
        if (mounted) {
          var visiblePercentage = visibilityInfo.visibleFraction * 100;
          if (visiblePercentage >= 10) {
            if (!_controller.value.isPlaying) {
              _controller.play();
            }
          } else {
            if (_controller.value.isPlaying) {
              _controller.pause();
            }
          }
        }
      },
      key: (Key("${widget.url} -- ${widget.fromPosition}")),
      child: FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CachedVideoPlayerPlus(_controller);
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
