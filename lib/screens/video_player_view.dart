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

class VideoPlayerView extends StatefulWidget {
  const VideoPlayerView({super.key, required this.videoAction,this.mediaItem});

  final ChatAction videoAction;
  final MediaItem? mediaItem;


  @override
  State<StatefulWidget> createState() => _VideoPlayerViewState();
}

class _VideoPlayerViewState extends State<VideoPlayerView> {
  late VideoPlayerController _videoPlayerController;
  DistroApiProvider apiProvider = DistroApiProvider();
  List<Channel> _channels = const [];
  List<Channel> _filteredChannels = [];
  bool _isChannelsError = false;
  int position=0;
  late Timer timer;
  late Timer min;

  int counterOfChannels=0;

  final MethodChannel _channel = MethodChannel('flutter_with_evoplayer');
  void initializePlayer(Map<String,dynamic> data) async {
    try {
      await _channel.invokeMethod('initializePlayer', data);
    } catch (e) {
      print('Error calling initializePlayer: $e');
    }
  }
  String? actionID;



  @override
  void initState() {
    super.initState();
    actionID = widget.mediaItem?.video ?? widget.videoAction.actionID;
    if( widget.mediaItem !=null){
      actionID =  widget.videoAction.actionID;
    }
    if(actionID != null && Platform.isAndroid && widget.mediaItem != null
        && widget.mediaItem!.source !="" && widget.mediaItem!.source !=null){
      initializeMethod(actionID);
    }else {}
    _videoPlayerController =
        VideoPlayerController.network(actionID ?? '');
             SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
    ]);
  }

  initializeMethod(String? actionID) async {
    Map<String,dynamic> data = await apiProvider.trackingPixel(eventName: 'vplay',durl:actionID.toString());
    initializePlayer(data);
  }

  bool isCall = false;


  trackingAPI(){
    setState(() {
      isCall = true;
    });
    // Call the method every second for the first 10 seconds
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (timer.tick <= 10) {
        // Call your method here
        apiProvider.trackingPixel(eventName: 'vs${timer.tick}');
      } else {
        timer.cancel();
        // Start a new timer to call the method every 60 seconds
        min = Timer.periodic(Duration(seconds: 60), (min) {
          // Call your method here
          apiProvider.trackingPixel(eventName: 'vs${timer.tick*60}');
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

  @override
  Widget build(BuildContext context) {
    return actionID != null && Platform.isAndroid && widget.mediaItem != null &&widget.mediaItem!.source !="" ? const SizedBox(): Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            GestureDetector(
              onHorizontalDragEnd: (dragDetail) {

                if (dragDetail.velocity.pixelsPerSecond.dx < 1) {
                  counterOfChannels++;
                  setState(() {
                    position=position+1;
                    for(int i=position;i<_channels.length;_channels[i].feedHLS!="")
                    {

                      i++;

                      if(_channels[i].feedHLS!="")
                      {
                        // _videoPlayerController.dispose();
                        _videoPlayerController.pause();
                        HomePageProvider.action_id=_channels[i].feedHLS;
                        HomePageProvider.title=_channels[i].name;
                        _videoPlayerController =
                            VideoPlayerController.network(_channels[i].feedHLS);
                        _videoPlayerController.initialize();
                        _videoPlayerController.play();
                        position=i;
                        // Navigator.of(context).pop();
                        context.push('/video', extra: widget.videoAction);
                        break;
                      }
                    }
                  });


                } else {
                  counterOfChannels--;
                  if(counterOfChannels==0)
                  {
                    HomePageProvider.title="";
                    HomePageProvider.action_id="";
                    SystemChrome.setPreferredOrientations([
                      DeviceOrientation.portraitUp,
                    ]);
                  }
                  Navigator.of(context).pop();
                  print("left");
                }
                //  }

              },
              child: ThemedVideoPlayer(
                videoPlayerController: _videoPlayerController,

                showControlsOnInitialize: true,
                allowFullscreen: true,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {

                counterOfChannels--;
                if(counterOfChannels==-1)
                {
                  HomePageProvider.title="";
                  HomePageProvider.action_id="";
                  SystemChrome.setPreferredOrientations([
                    DeviceOrientation.portraitUp,
                  ]);
                }
                if(counterOfChannels==0)
                {
                  HomePageProvider.title="";
                  HomePageProvider.action_id="";
                  SystemChrome.setPreferredOrientations([
                    DeviceOrientation.portraitUp,
                  ]);
                }
                Navigator.of(context).pop();
                // SystemChrome.setPreferredOrientations([
                //     DeviceOrientation.portraitUp,
                //   ]);
                // This will navigate back to the previous screen
              },
            )
          ],
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

        ///* Sorting the channel by keys as per given documentation
        _filteredChannels.sort((p, n) => p.key.compareTo(n.key));
        // totalPages = (_filteredChannels.length / 10).ceil();
        _isChannelsError = false;

        for(int i=0;i<_channels.length;i++)
        {
          if(_channels[i].feedHLS==HomePageProvider.action_id)
          {
            position=i;
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