import 'package:dor_companion/assets.dart';
import 'package:dor_companion/data/app_state.dart';
import 'package:dor_companion/data/models/models.dart';
import 'package:dor_companion/redesign/live_tv/widgets/no_channel_found_screen.dart';
import 'package:dor_companion/redesign/view_model/tv_guide_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class TvGuideScreen extends StatefulWidget {
  final String? genre;
  final String? language;
  final String? channelId;

  const TvGuideScreen({super.key, this.genre, this.language, this.channelId});

  @override
  State<TvGuideScreen> createState() => _TvGuideScreenState();
}

class _TvGuideScreenState extends State<TvGuideScreen> {
  late TvGuideVm tvGuideVm;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      tvGuideVm = Provider.of<TvGuideVm>(context, listen: false);
      tvGuideVm.setData(genre: widget.genre, language: widget.language, channelId: widget.channelId);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: true,
        onPopInvoked: (didPop) async {
          if (didPop) {
            tvGuideVm.clearData();
            if (context.mounted) {
              WidgetsBinding.instance.addPostFrameCallback((_) => Navigator.of(context).maybePop());
            }
          }
        },
        child: Scaffold(
            backgroundColor: Colors.black,
            body: Consumer<TvGuideVm>(
                builder: (context, value, child) => SafeArea(
                        child: Column(children: [
                      const SizedBox(height: 20),
                      const AppBar(),
                      Container(height: 1, width: double.infinity, color: const Color(0xFF171717)),
                      Expanded(
                          child: value.isLoading
                              ? const Center(
                                  child: CircularProgressIndicator(
                                      backgroundColor: Colors.white,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.purple)))
                              : (value.rightPanelData.isEmpty || value.leftPanelList.isEmpty)
                                  ? const NoChannelFoundView()
                                  : const Row(children: [
                                      Expanded(flex: 3, child: LeftPanel()),
                                      Expanded(flex: 9, child: RightPanel())
                                    ]))
                    ])))));
  }
}

class AppBar extends StatelessWidget {
  const AppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: appState.genreWithImages,
        builder: (context, genresVal, child) {
          return Container(
              width: MediaQuery.sizeOf(context).width,
              height: kTextTabBarHeight,
              decoration: const BoxDecoration(color: Colors.black),
              child: Row(children: [
                Row(children: [
                  const SizedBox(width: 10),
                  Consumer<TvGuideVm>(
                      builder: (context, value, child) => IconButton(
                          onPressed: () {
                            value.clearData();
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.arrow_back_ios),
                          color: Colors.white)),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Live TV Type',
                            style: TextStyle(
                                color: Color(0xFF999999),
                                fontSize: 11,
                                fontFamily: 'DMSans',
                                fontWeight: FontWeight.w400,
                                height: 0.14,
                                letterSpacing: 0.20)),
                        const SizedBox(height: 8),
                        InkWell(
                            onTap: () {
                              showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  barrierColor: Colors.black.withOpacity(0.800000011920929),
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(32), topRight: Radius.circular(32))),
                                  constraints:
                                      BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.6),
                                  builder: (BuildContext context) {
                                    return Builder(builder: (BuildContext context) {
                                      return Container(
                                          decoration: const ShapeDecoration(
                                              color: Color(0xFF171717),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.only(
                                                      topLeft: Radius.circular(32),
                                                      topRight: Radius.circular(32)))),
                                          child: Column(mainAxisSize: MainAxisSize.min, children: [
                                            const SizedBox(height: 12),
                                            Container(
                                                width: 55,
                                                height: 4,
                                                decoration: ShapeDecoration(
                                                    color: const Color(0xFF4D4D4D),
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(200)))),
                                            const SizedBox(height: 32),
                                            const Text('SELECT LIVE TV TYPE',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                    fontFamily: 'DMSans',
                                                    fontWeight: FontWeight.w500,
                                                    letterSpacing: 2)),
                                            const SizedBox(height: 24),
                                            Expanded(
                                                child: Consumer<TvGuideVm>(
                                                    builder: (context, tvGuideProvider, child) =>
                                                        ListView.builder(
                                                            itemCount: tvGuideProvider.genreList.length,
                                                            shrinkWrap: true,
                                                            padding:
                                                                const EdgeInsets.symmetric(horizontal: 16)
                                                                    .copyWith(bottom: 16),
                                                            itemBuilder: (context, index) {
                                                              final data = tvGuideProvider.genreList[index];
                                                              return InkWell(
                                                                onTap: () {
                                                                  tvGuideProvider
                                                                      .changeLiveTvType(data.title);
                                                                  Navigator.pop(context);
                                                                },
                                                                child: Container(
                                                                    padding: const EdgeInsets.symmetric(
                                                                        horizontal: 24, vertical: 12),
                                                                    margin: const EdgeInsets.only(bottom: 10),
                                                                    decoration: ShapeDecoration(
                                                                        color: const Color(0xFF0E0E0E),
                                                                        shape: RoundedRectangleBorder(
                                                                            side: BorderSide(
                                                                                width: 1,
                                                                                color: data.isSelected
                                                                                    ? const Color(0xFF666666)
                                                                                    : Colors.transparent),
                                                                            borderRadius:
                                                                                BorderRadius.circular(12))),
                                                                    child: Row(children: [
                                                                      CircleAvatar(
                                                                          radius: 18,
                                                                          backgroundImage:
                                                                              (data.image != null &&
                                                                                      data.image!.isNotEmpty)
                                                                                  ? AssetImage(data.image!)
                                                                                  : null,
                                                                          child: data.image == null ||
                                                                                  data.image!.isEmpty
                                                                              ? const Icon(Icons.error)
                                                                              : null),
                                                                      const SizedBox(width: 12),
                                                                      Text(data.title,
                                                                          textAlign: TextAlign.center,
                                                                          style: const TextStyle(
                                                                              color: Color(0xFFE5E5E5),
                                                                              fontSize: 13,
                                                                              fontFamily: 'DMSans',
                                                                              fontWeight: FontWeight.w500,
                                                                              letterSpacing: 0.20)),
                                                                      const Spacer(),
                                                                      Visibility(
                                                                          visible: data.isSelected,
                                                                          child: const Icon(Icons.done,
                                                                              size: 16))
                                                                    ])),
                                                              );
                                                            })))
                                          ]));
                                    });
                                  });
                            },
                            child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Consumer<TvGuideVm>(
                                      builder: (context, value, child) => Text(
                                          (value.selectedType ?? '').toUpperCase(),
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontFamily: 'DMSans',
                                              fontWeight: FontWeight.w500,
                                              height: 0.10,
                                              letterSpacing: 2))),
                                  const SizedBox(width: 4),
                                  SvgPicture.asset(Assets.assets_images_live_tv_type_drodown_svg)
                                ]))
                      ])
                ]),
                const Spacer(),
                Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Consumer<TvGuideVm>(
                          builder: (context, value, child) => Text(
                              value.selectedLanguage == 'All'
                                  ? "All languages"
                                  : value.selectedLanguage ?? '',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontFamily: 'DMSans',
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.20))),
                      const SizedBox(height: 2),
                      InkWell(
                        onTap: () {
                          showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              barrierColor: Colors.black.withOpacity(0.800000011920929),
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(32), topRight: Radius.circular(32))),
                              constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.6),
                              builder: (BuildContext context) {
                                return Builder(builder: (BuildContext context) {
                                  return Container(
                                      decoration: const ShapeDecoration(
                                          color: Color(0xFF171717),
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(32),
                                                  topRight: Radius.circular(32)))),
                                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                                        const SizedBox(height: 12),
                                        Container(
                                            width: 55,
                                            height: 4,
                                            decoration: ShapeDecoration(
                                                color: const Color(0xFF4D4D4D),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(200)))),
                                        const SizedBox(height: 32),
                                        const Text('CHANGE LANGUAGE',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontFamily: 'DMSans',
                                                fontWeight: FontWeight.w500,
                                                letterSpacing: 2)),
                                        const SizedBox(height: 24),
                                        Expanded(
                                            child: Consumer<TvGuideVm>(
                                                builder: (context, tvGuideProvider, child) =>
                                                    ListView.builder(
                                                        itemCount: tvGuideProvider.languageList.length,
                                                        shrinkWrap: true,
                                                        padding: const EdgeInsets.symmetric(horizontal: 16)
                                                            .copyWith(bottom: 16),
                                                        itemBuilder: (context, index) {
                                                          final data = tvGuideProvider.languageList[index];
                                                          return InkWell(
                                                            onTap: () {
                                                              Navigator.pop(context);
                                                              tvGuideProvider.updateLanguages(data.title);
                                                            },
                                                            child: Container(
                                                                padding: const EdgeInsets.symmetric(
                                                                    horizontal: 24, vertical: 20),
                                                                margin: const EdgeInsets.only(bottom: 10),
                                                                decoration: ShapeDecoration(
                                                                    color: const Color(0xFF0E0E0E),
                                                                    shape: RoundedRectangleBorder(
                                                                        side: BorderSide(
                                                                            width: 1,
                                                                            color: data.isSelected
                                                                                ? const Color(0xFF666666)
                                                                                : Colors.transparent),
                                                                        borderRadius:
                                                                            BorderRadius.circular(12))),
                                                                child: Row(children: [
                                                                  Text(data.title,
                                                                      textAlign: TextAlign.center,
                                                                      style: const TextStyle(
                                                                          color: Color(0xFFE5E5E5),
                                                                          fontSize: 13,
                                                                          fontFamily: 'DMSans',
                                                                          fontWeight: FontWeight.w500,
                                                                          letterSpacing: 0.20)),
                                                                  const Spacer(),
                                                                  Visibility(
                                                                      visible: data.isSelected,
                                                                      child: const Icon(Icons.done, size: 16))
                                                                ])),
                                                          );
                                                        })))
                                      ]));
                                });
                              });
                        },
                        child: const Text('Change',
                            style: TextStyle(
                                color: Color(0xFF7399F4),
                                fontSize: 13,
                                fontFamily: 'DMSans',
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0.20)),
                      )
                    ]),
                const SizedBox(width: 24)
              ]));
        });
  }
}

class LeftPanel extends StatelessWidget {
  const LeftPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: const Color(0xFF171717),
        child: Consumer<TvGuideVm>(
            builder: (context, value, child) => ListView.builder(
                itemCount: value.leftPanelList.length,
                padding: const EdgeInsets.only(top: 24),
                itemBuilder: (context, index) {
                  final data = value.leftPanelList[index];
                  return InkWell(
                      onTap: () => value.selectChannel(data),
                      child: Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Row(children: [
                            Visibility(
                                visible: value.selectedChannel?.id == data.id,
                                maintainSize: true,
                                maintainAnimation: true,
                                maintainState: true,
                                child: Padding(
                                    padding: const EdgeInsets.only(right: 5),
                                    child:
                                        SvgPicture.asset(Assets.assets_images_live_tv_selection_icon_svg))),
                            Container(
                                width: 72,
                                height: 48,
                                clipBehavior: Clip.antiAlias,
                                decoration: ShapeDecoration(
                                    image: DecorationImage(image: NetworkImage(data.image), fit: BoxFit.fill),
                                    shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                            width: value.selectedChannel?.id == data.id ? 2 : 1,
                                            color: value.selectedChannel?.id == data.id
                                                ? const Color(0xFFFF323B)
                                                : const Color(0xFF333333)),
                                        borderRadius: BorderRadius.circular(16))))
                          ])));
                })));
  }
}

class RightPanel extends StatelessWidget {
  const RightPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TvGuideVm>(builder: (context, value, child) {
      final viewModel = Provider.of<TvGuideVm>(context);
      if (viewModel.rightPanelData.isEmpty) {
        return const Center(child: Text('No data available', style: TextStyle(color: Colors.white)));
      }
      final selectedChannelData = viewModel.rightPanelData.first;
      return Container(
          color: Colors.black,
          alignment: Alignment.topLeft,
          child: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                _buildChannelInfo(selectedChannelData),
                _buildNowPlaying(selectedChannelData.mediaItems.first, context),
                _buildComingUpNext(selectedChannelData.mediaItems.skip(1).toList())
              ])));
    });
  }

  Widget _buildChannelInfo(MediaRow channelData) {
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 10).copyWith(top: 12),
        color: Colors.black.withOpacity(0.800000011920929),
        child: Row(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.center, children: [
          Container(
              width: 81,
              height: 54,
              clipBehavior: Clip.antiAlias,
              decoration: ShapeDecoration(
                  image: DecorationImage(image: NetworkImage(channelData.rowImage ?? ''), fit: BoxFit.fill),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)))),
          const SizedBox(width: 12),
          Expanded(
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(channelData.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontFamily: 'DMSans',
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.20)),
                const SizedBox(height: 6),
                Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: ShapeDecoration(
                        color: const Color(0xFF171717),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6))),
                    child: Consumer<TvGuideVm>(
                        builder: (context, value, child) => Text(
                            '${value.selectedLanguage} • ${value.selectedType}',
                            style: const TextStyle(
                                color: Color(0xFF999999),
                                fontSize: 12,
                                fontFamily: 'DMSans',
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0.20))))
              ])),
          IconButton(onPressed: () {}, icon: const Icon(Icons.favorite))
        ]));
  }

  Widget _buildNowPlaying(MediaItem nowPlaying, BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16).copyWith(top: 24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Now playing',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontFamily: 'DMSerifDisplay',
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.20)),
          const SizedBox(height: 16),
          Container(
              padding: const EdgeInsets.all(12),
              clipBehavior: Clip.antiAlias,
              decoration: ShapeDecoration(
                  color: const Color(0xFF0E0E0E),
                  shape: RoundedRectangleBorder(
                      side: const BorderSide(width: 1, color: Color(0xFF1F1F1F)),
                      borderRadius: BorderRadius.circular(24))),
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                        width: double.infinity,
                        height: 135,
                        child: Stack(children: [
                          Container(
                              width: double.infinity,
                              height: 135,
                              clipBehavior: Clip.antiAlias,
                              decoration: ShapeDecoration(
                                  image: DecorationImage(
                                      image: NetworkImage(nowPlaying.imageHD), fit: BoxFit.fill),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)))),
                          Align(
                              alignment: Alignment.center,
                              child: InkWell(
                                  onTap: () {
                                    if (nowPlaying.schedule != null &&
                                        !nowPlaying.isShowPlayingLive() &&
                                        nowPlaying.actions.length > 1) {
                                      debugPrint('Video Link : ${nowPlaying.video}');
                                      nowPlaying.actions[1].chatAction
                                          .executeAction(context, mediaItem: nowPlaying);
                                      return;
                                    }
                                    if (nowPlaying.actions.isNotEmpty) {
                                      nowPlaying.actions[0].chatAction
                                          .executeAction(context, mediaItem: nowPlaying);
                                    }
                                  },
                                  child: SvgPicture.asset(Assets.assets_images_live_tv_play_icon_svg))),
                          if (nowPlaying.isLiveTVItem)
                            Positioned(
                                top: 6,
                                right: 6,
                                child: SvgPicture.asset(Assets.assets_images_live_tv_live_icon_svg))
                        ])),
                    const SizedBox(height: 8),
                    Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(nowPlaying.showDuration(),
                              style: const TextStyle(
                                  color: Color(0xFF999999),
                                  fontSize: 12,
                                  fontFamily: 'DMSans',
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 0.20)),
                          const SizedBox(height: 4),
                          SizedBox(
                              width: double.infinity,
                              child: Text(nowPlaying.description,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      color: Color(0xFFE5E5E5),
                                      fontSize: 14,
                                      fontFamily: 'DMSans',
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 0.20)))
                        ])
                  ]))
        ]));
  }

  Widget _buildComingUpNext(List<MediaItem> upcomingPrograms) {
    return upcomingPrograms.isEmpty
        ? const SizedBox()
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(height: 26),
              const Text('Coming up next',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontFamily: 'DMSerifDisplay',
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.20)),
              const SizedBox(height: 16),
              ListView.builder(
                  itemCount: upcomingPrograms.length,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final program = upcomingPrograms[index];
                    return Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(12),
                        clipBehavior: Clip.antiAlias,
                        decoration: ShapeDecoration(
                            color: const Color(0xFF0E0E0E),
                            shape: RoundedRectangleBorder(
                                side: const BorderSide(width: 1, color: Color(0xFF1F1F1F)),
                                borderRadius: BorderRadius.circular(16))),
                        child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(program.showDuration(),
                                  style: const TextStyle(
                                      color: Color(0xFF999999),
                                      fontSize: 12,
                                      fontFamily: 'DMSans',
                                      fontWeight: FontWeight.w400,
                                      letterSpacing: 0.20)),
                              const SizedBox(height: 4),
                              SizedBox(
                                  width: double.infinity,
                                  child: Text(program.title,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          color: Color(0xFFE5E5E5),
                                          fontSize: 14,
                                          fontFamily: 'DMSans',
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: 0.20)))
                            ]));
                  })
            ]));
  }
}
