import 'package:dor_companion/data/app_state.dart';
import 'package:dor_companion/data/models/models.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FavoriteRecommendedChannel extends StatefulWidget {
  const FavoriteRecommendedChannel({super.key});

  @override
  State<FavoriteRecommendedChannel> createState() => _FavoriteRecommendedChannelState();
}

class _FavoriteRecommendedChannelState extends State<FavoriteRecommendedChannel> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: appState.favChannelData,
        builder: (context, value, child) {
          debugPrint('length of favChannelData: ${appState.favChannelData.value.length}');
          if (appState.favChannelData.value.isNotEmpty) {
            return ListView.builder(
                itemCount: appState.favChannelData.value.length,
                padding: const EdgeInsets.only(left: 16, top: 24),
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final mediaDetail = appState.favChannelData.value[index];
                  final scheduleMediaItems =
                      mediaDetail.mediaRows.firstWhere((element) => element.title == "Schedule").mediaItems;
                  if (scheduleMediaItems.isEmpty) {
                    return const SizedBox();
                  }
                  return Padding(
                      padding: const EdgeInsets.only(bottom: 32),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Row(children: [
                          Container(
                              width: 90,
                              height: 60,
                              clipBehavior: Clip.antiAlias,
                              decoration: ShapeDecoration(
                                  image: DecorationImage(
                                      image: NetworkImage(mediaDetail.mediaHeader!.mediaItem!.imageHD),
                                      fit: BoxFit.cover),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)))),
                          const SizedBox(width: 12),
                          const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text('Based on your favorite channel',
                                style: TextStyle(
                                    color: Color(0xFF999999),
                                    fontSize: 14,
                                    fontFamily: 'DMSans',
                                    fontWeight: FontWeight.w400,
                                    letterSpacing: 0.20)),
                            Text('Recommended',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 28,
                                    fontFamily: 'DMSerifDisplay',
                                    fontWeight: FontWeight.w400,
                                    letterSpacing: 0.20))
                          ])
                        ]),
                        const SizedBox(height: 20),
                        SizedBox(
                            height: 146,
                            width: double.infinity,
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: mediaDetail.mediaRows
                                    .firstWhere((element) => element.title == "Schedule")
                                    .mediaItems
                                    .length,
                                itemBuilder: (context, itemIndex) {
                                  final mediaItem = mediaDetail.mediaRows
                                      .firstWhere((element) => element.title == "Schedule")
                                      .mediaItems[itemIndex];
                                  return GestureDetector(
                                    onTap: () async =>
                                        await mediaItem.actions[0].chatAction.executeAction(context),
                                    child: Container(
                                        width: 198,
                                        height: 146,
                                        margin: const EdgeInsets.only(right: 16),
                                        child: Stack(children: [
                                          Container(
                                              width: 198,
                                              height: 138,
                                              clipBehavior: Clip.antiAlias,
                                              decoration: ShapeDecoration(
                                                  image: DecorationImage(
                                                      image: NetworkImage(mediaItem.imageHD),
                                                      fit: BoxFit.fill),
                                                  shape: RoundedRectangleBorder(
                                                      side: const BorderSide(
                                                          width: 1, color: Color(0xFF1F1F1F)),
                                                      borderRadius: BorderRadius.circular(24)))),
                                          Container(
                                              width: 198,
                                              height: 146,
                                              decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                      begin: const Alignment(-0.13, -0.99),
                                                      end: const Alignment(0.13, 0.99),
                                                      colors: [
                                                    Colors.black.withOpacity(0),
                                                    const Color(0xFF000000)
                                                  ]))),
                                          Align(
                                              alignment: Alignment.bottomCenter,
                                              child: Container(
                                                  width: 16,
                                                  height: 16,
                                                  clipBehavior: Clip.antiAlias,
                                                  decoration: ShapeDecoration(
                                                      image: DecorationImage(
                                                          image: NetworkImage(mediaItem.image),
                                                          fit: BoxFit.fill),
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(4))))),
                                          Align(
                                              alignment: Alignment.bottomLeft,
                                              child: Padding(
                                                padding: const EdgeInsets.only(bottom: 24, left: 16),
                                                child: Text(_getTimeInfo(mediaItem.schedule),
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 10,
                                                        fontFamily: 'DMSans',
                                                        fontWeight: FontWeight.w700,
                                                        letterSpacing: 2)),
                                              ))
                                        ])),
                                  );
                                }))
                      ]));
                });
          } else {
            return const SizedBox();
          }
        });
  }
}

String _getTimeInfo(Schedule? schedule) {
  final showStartTime = DateTime.parse(schedule!.start).toLocal();
  final showEndTime = showStartTime.add(Duration(minutes: schedule.duration));
  return '${DateFormat.jm().format(showStartTime).replaceAll('AM', '').replaceAll('PM', '')} - ${DateFormat.jm().format(showEndTime)}';
}
