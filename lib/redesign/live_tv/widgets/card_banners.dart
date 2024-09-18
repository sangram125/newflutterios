import 'package:carousel_slider/carousel_slider.dart';
import 'package:dor_companion/assets.dart';
import 'package:dor_companion/data/models/models.dart';
import 'package:dor_companion/redesign/live_tv/widgets/curve_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CommonBanner extends StatefulWidget {
  final bool isShowPlayButton;
  final bool isShowNotifyButton;
  final bool isShowPlayWithWatchListButton;
  final bool? isShowBannerDetail;
  final List<StandardPromotion> bannerList;
  final void Function(int index)? onNotifyMePressed;
  final void Function(int index)? onPlayButtonPressed;
  final void Function(int index)? onAddWatchListPressed;
  final void Function(int index)? onCardPressed;
  final bool isHomeScreen;
  const CommonBanner(
      {Key? key,
      required this.bannerList,
      required this.isShowPlayButton,
      required this.isShowNotifyButton,
      required this.isShowPlayWithWatchListButton,
      this.onNotifyMePressed,
      this.onPlayButtonPressed,
      this.onAddWatchListPressed,
      this.isShowBannerDetail = false,
      this.onCardPressed,this.isHomeScreen =false})
      : super(key: key);

  @override
  State<CommonBanner> createState() => _CommonBannerState();
}

class _CommonBannerState extends State<CommonBanner> {
  int _current = 0;
  final CarouselSliderController _controller = CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.6,
        width: MediaQuery.sizeOf(context).width,
        child: Stack(children: [
          ClipPath(
              clipper: CurveImage(),
              child: Opacity(
                  opacity: 0.6,
                  child: Container(
                      height: MediaQuery.sizeOf(context).height * 0.565,
                      width: MediaQuery.sizeOf(context).width,
                      decoration:  BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.black,widget.isHomeScreen? const Color(0x69696966): Color(0x33E50910)]))))),
          Column(children: [
            Stack(children: [
              SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.5,
                  width: MediaQuery.sizeOf(context).width,
                  child: CarouselSlider(
                      items: widget.bannerList
                          .map((item) => InkWell(
                                onTap: () => widget.onCardPressed?.call(_current),
                                borderRadius: const BorderRadius.all(Radius.circular(32)),
                                child: Container(
                                    padding: const EdgeInsets.only(left: 6, right: 6, top: 6, bottom: 55),
                                    margin: const EdgeInsets.symmetric(horizontal: 8),
                                    decoration: BoxDecoration(
                                        color: Colors.black,
                                        border: Border.all(color: const Color(0xFF1F1F1F)),
                                        borderRadius: const BorderRadius.all(Radius.circular(32)),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.black.withOpacity(0.3),
                                              spreadRadius: 2,
                                              blurRadius: 5,
                                              offset: const Offset(0, 3))
                                        ]),
                                    child: ClipRRect(
                                        borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(32), topRight: Radius.circular(32)),
                                        child: Image.network(item.image, fit: BoxFit.fill))),
                              ))
                          .toList(),
                      carouselController: _controller,
                      options: CarouselOptions(
                          height: MediaQuery.sizeOf(context).height * 0.52,
                          viewportFraction: 0.83,
                          autoPlay: false,
                          aspectRatio: 16 / 14,
                          onPageChanged: (index, reason) => setState(() => _current = index)))),
              Positioned(
                  bottom: 2,
                  left: 0,
                  right: 0,
                  child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                    Visibility(
                        visible: widget.isShowBannerDetail ?? false,
                        child: const Padding(
                            padding: EdgeInsets.only(bottom: 8.0),
                            child: Text('Movie . Action . Tamil',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500)))),
                    widget.isShowNotifyButton
                        ? IconButton(
                            onPressed: () => widget.onNotifyMePressed?.call(_current),
                            icon: SvgPicture.asset(Assets.assets_images_notify_me_button_svg))
                        : widget.isShowPlayButton
                            ? IconButton(
                                onPressed: () => widget.onPlayButtonPressed?.call(_current),
                                icon: SvgPicture.asset(Assets.assets_images_play_button_svg))
                            : widget.isShowPlayWithWatchListButton
                                ? Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                    IconButton(
                                        onPressed: () => widget.onAddWatchListPressed?.call(_current),
                                        icon: SvgPicture.asset(Assets.assets_images_add_to_watchlist_svg)),
                                    IconButton(
                                        onPressed: () => widget.onPlayButtonPressed?.call(_current),
                                        icon: SvgPicture.asset(Assets.assets_images_play_button_svg))
                                  ])
                                : const SizedBox()
                  ]))
            ]),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: widget.bannerList.asMap().entries.map((entry) {
                  return GestureDetector(
                      onTap: () => _controller.animateToPage(entry.key),
                      child: Container(
                          height: 14.0,
                          width: 14.0,
                          margin: const EdgeInsets.only(top: 8),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.transparent,
                              border: Border.all(
                                  width: 1.0,
                                  color: _current == entry.key ? Colors.white : Colors.transparent)),
                          child: const Padding(
                              padding: EdgeInsets.all(3.8),
                              child: CircleAvatar(radius: 2, backgroundColor: Color(0xFFE5E5E5)))));
                }).toList())
          ])
        ]));
  }
}
