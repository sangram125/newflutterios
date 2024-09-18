import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dor_companion/data/app_state.dart';
import 'package:dor_companion/data/models/live_news_model.dart';
import 'package:dor_companion/widgets/video_player_live.dart';
import 'package:flutter/material.dart';
import '../../data/models/constants.dart';

class LiveNewsRowView extends StatefulWidget {

Cluster channel;
int clusterIndex;
final void Function() channelSelectedCall;
   LiveNewsRowView({required this.channel, required this.clusterIndex, required this.channelSelectedCall,super.key,});

  @override
  State<LiveNewsRowView> createState() => LiveNewsRowViewState();
}

class LiveNewsRowViewState extends State<LiveNewsRowView> {
  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.only(left: 10,top: 10),
      child: Column(
        children: [
           SizedBox(
             width:MediaQuery.of(context).size.width * 0.90 ,
               child: AutoSizeText( widget.channel.topic,
                 overflow: TextOverflow.ellipsis,
                 style: AppTypography.loginText.copyWith(color: Colors.white,
                   fontWeight: FontWeight.w500,
                   fontSize: 17,
                     fontFamily: "Roboto"),)),
          const SizedBox(height: 10,),
          Container(
            height: MediaQuery.of(context).size.height * 0.180, // Adjust height as needed
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.channel.channels.length,
              itemBuilder: (context, index) {
                return Container(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: GestureDetector(
                          onTap: () async {
                             appState.lastSelectedChannel.value = index;
                              appState.lastSelected.value = widget.clusterIndex;
                            widget.channelSelectedCall();
                            print("cluster index ${appState.lastSelected.value}");
                            print("channel index ${appState.lastSelectedChannel.value}");
                            // if(widget.channel.channels[index].process_stream == "" || widget.channel.channels[index].process_stream == null){
                            //   showVanillaToast("Video Not Available");
                            // }else {
                            //   Map data = {
                            //     "url": widget.channel.channels[index]
                            //         .process_stream,
                            //     'title': widget.channel.channels[index].topic
                            //   };
                            //   context.push('/videoLiveNews', extra: data);
                            // }
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16.0),
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.12,
                              width: MediaQuery.of(context).size.width * 0.43,
                              child: FittedBox(
                                fit: BoxFit.cover,
                                child: Image.network(widget.channel.channels[index].channel_logo),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 5,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ChannelLogo(logo: widget.channel.channels[index].channel_logo,
                            height: 100, width: 100, ),
                          SizedBox(width: 5,),
                          SizedBox(
                              width:MediaQuery.of(context).size.width * 0.30,
                              child:
                              Text(widget.channel.channels[index].topic,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: AppTypography.loginText.copyWith(
                                    color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                    fontFamily: "Roboto"),
                              ),
                          ),
                        ],
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
class ChannelLogo extends StatelessWidget {
  final String logo;
  final double height;
  final double width;
  const ChannelLogo({
    super.key,
    required this.logo,
    required this.height,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height / 3,
      width: width / 3,
      child: Center(
        child: CachedNetworkImage(
          placeholder: (context, url) => Container(
            height: height,
            width: width,
            color: Theme.of(context).colorScheme.primaryContainer,
          ),
          errorWidget: (_, __, ___) => Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.errorContainer,
            ),
          ),
          imageUrl: logo,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}


