import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'loader.dart';

class ThemedVideoPlayer extends StatelessWidget {
  const ThemedVideoPlayer({
    Key? key,
    required this.videoPlayerController,
    this.showControlsOnInitialize = false,
    this.allowFullscreen = false,
  }) : super(key: key);

  final VideoPlayerController videoPlayerController;
  final bool showControlsOnInitialize;
  final bool allowFullscreen;

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final color = Theme.of(context).colorScheme.primary;
    final style = TextStyle(color: color);
    return Theme(
        data: themeData.copyWith(
          textTheme: themeData.textTheme.copyWith(titleMedium: style),
        ),
        child: VideoPlayer(
          videoPlayerController: videoPlayerController,
          showControlsOnInitialize: showControlsOnInitialize,
          allowFullscreen: allowFullscreen,
        
        ));
  }
}

class VideoPlayer extends StatefulWidget {
  const VideoPlayer({
    Key? key,
    required this.videoPlayerController,
    this.showControlsOnInitialize = false,
    this.allowFullscreen = false,
  }) : super(key: key);
  final VideoPlayerController videoPlayerController;
  final bool showControlsOnInitialize;
  final bool allowFullscreen;

  @override
  State<VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  ChewieController? _chewieController;
  bool _disposed = false;

  @override
  void initState() {
    super.initState();
    initializePlayer();
 
  }

  @override
  void dispose() {
    _disposed = true;
    widget.videoPlayerController.dispose();
    _chewieController?.dispose();
   
    super.dispose();
  }

  Future<void> initializePlayer() async {
    await widget.videoPlayerController.initialize();
    
    _chewieController = ChewieController(
      videoPlayerController: widget.videoPlayerController,
      autoPlay: true,
      showControlsOnInitialize: widget.showControlsOnInitialize,
      allowFullScreen: widget.allowFullscreen,
      allowMuting: true,
      allowPlaybackSpeedChanging: false,
      showOptions: false,
    
    );
    // _chewieController!.fullScreenByDefault;
    // _chewieController!.enterFullScreen();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: const Key("Video Player"),
      onVisibilityChanged: (VisibilityInfo info) {
        if (_disposed) return;

        if (info.visibleFraction < 1 && !_chewieController!.isFullScreen) {
          widget.videoPlayerController.pause();
        } else {
          widget.videoPlayerController.play();
        }
      },
      child: Center(
        child: _chewieController != null &&
                _chewieController!.videoPlayerController.value.isInitialized
            ? Chewie(
                controller: _chewieController!,
              )
            : const Loader(),
      ),
    );
  }
}
