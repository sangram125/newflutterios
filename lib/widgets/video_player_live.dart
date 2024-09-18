import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dor_companion/data/models/home_page_provider.dart';
import 'package:dor_companion/widgets/themed_video_player.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';

import '../data/api/distro_api.dart';
import '../data/api/sensy_api.dart';
import '../data/models/models.dart';
import '../injection/injection.dart';
import '../utils.dart';

class VideoPlayerLiveNewsView extends StatefulWidget {
  VideoPlayerLiveNewsView({super.key, required this.url, required this.title});
  String url;
  String title;

  @override
  State<StatefulWidget> createState() => _VideoPlayerLiveNewsViewState();
}

class _VideoPlayerLiveNewsViewState extends State<VideoPlayerLiveNewsView> {
  late VideoPlayerController _videoPlayerController;
  DistroApiProvider apiProvider = DistroApiProvider();
  List<Channel> _channels = const [];
  List<Channel> _filteredChannels = [];
  bool _isChannelsError = false;
  int position = 0;
  late Timer timer;
  late Timer min;

  int counterOfChannels = 0;

  final MethodChannel _channel = MethodChannel('flutter_with_evoplayer');

  void initializePlayer(Map<String, dynamic> data) async {
    try {
      await _channel.invokeMethod('initializePlayer', data);
    } catch (e) {
      print('Error calling initializePlayer: $e');
    }
  }

  bool isCall = false;

  @override
  void initState() {
    super.initState();

    apiProvider.trackingPixel(eventName: 'vplay');
    _videoPlayerController = VideoPlayerController.network(widget.url);
    _videoPlayerController.addListener(() {
      if (_videoPlayerController.value.isPlaying && !isCall) {
        trackingAPI();
      }
    });

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
    ]);
  }

  void trackingAPI() {
    setState(() {
      isCall = true;
    });
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (timer.tick <= 10) {
        apiProvider.trackingPixel(eventName: 'vs${timer.tick}');
      } else {
        timer.cancel();
        min = Timer.periodic(Duration(seconds: 60), (min) {
          apiProvider.trackingPixel(eventName: 'vs${timer.tick * 60}');
        });
      }
    });
  }

  @override
  void dispose() {
    timer.cancel();
    min.cancel();
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    counterOfChannels--;
    if (counterOfChannels == -1) {
      widget.title = "";
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
    }
    if (counterOfChannels == 0) {
      widget.title = "";
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
    }
    Navigator.of(context).pop();
    return false; // Prevent default behavior
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => _onWillPop(),
          ),
          title: Text(
            widget.title,
            style: const TextStyle(color: Colors.white),
          ),
        ),
        body: SafeArea(
          child: GestureDetector(
            onHorizontalDragEnd: (dragDetail) {
              if (dragDetail.velocity.pixelsPerSecond.dx < 1) {
                counterOfChannels++;
                setState(() {
                  position = position + 1;
                  for (int i = position; i < _channels.length; _channels[i].feedHLS != "") {
                    i++;
                    if (_channels[i].feedHLS != "") {
                      _videoPlayerController.pause();
                      HomePageProvider.action_id = _channels[i].feedHLS;
                      HomePageProvider.title = _channels[i].name;
                      _videoPlayerController = VideoPlayerController.network(_channels[i].feedHLS);
                      _videoPlayerController.initialize();
                      _videoPlayerController.play();
                      position = i;
                      context.push('/video');
                      break;
                    }
                  }
                });
              } else {
                counterOfChannels--;
                if (counterOfChannels == 0) {
                  HomePageProvider.title = "";
                  HomePageProvider.action_id = "";
                  SystemChrome.setPreferredOrientations([
                    DeviceOrientation.portraitUp,
                  ]);
                }
                Navigator.of(context).pop();
              }
            },
            child: ThemedVideoPlayer(
              videoPlayerController: _videoPlayerController,
              showControlsOnInitialize: true,
              allowFullscreen: true,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _fetchChannels() async {
    setState(() {
      _isChannelsError = false;
      _channels = [];
    });

    await getIt<SensyApi>().fetchChannels().then((channels) {
      if (channels.isEmpty) {
        setState(() {
          _isChannelsError = true;
        });
        return;
      }

      setState(() {
        _channels = channels;
        _filteredChannels = _channels;
        _filteredChannels.sort((p, n) => p.key.compareTo(n.key));

        _isChannelsError = false;

        for (int i = 0; i < _channels.length; i++) {
          if (_channels[i].feedHLS == HomePageProvider.action_id) {
            position = i;
            print("position: $i");
          }
        }
      });
    }).catchError((errorObj) {
      switch (errorObj.runtimeType) {
        case DioException:
          final response = (errorObj as DioException).response;
          showVanillaToast("Failed to fetch Channels: ${response?.statusCode}");
          break;
        default:
          if (kDebugMode) {
            print("Encountered unknown error of type ${errorObj.runtimeType}");
          }
      }
      if (mounted) {
        setState(() {
          _isChannelsError = true;
        });
      }
    });
  }
}
