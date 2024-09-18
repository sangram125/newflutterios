import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dor_companion/firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';

import '../data/models/models.dart';
import '../responsive.dart';
import 'loader.dart';

class BannersCarousel extends StatefulWidget {
  const BannersCarousel({Key? key, required this.banners}) : super(key: key);
  final List<StandardPromotion> banners;

  @override
  State<StatefulWidget> createState() {
    return _BannersCarouselState();
  }
}

class _BannersCarouselState extends State<BannersCarousel> {
  int _current = 0;
  Timer? _timer;
  bool isHovering = false;
  AnalyticsEvent eventCall = AnalyticsEvent();
  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (mounted) {
        setState(() {
          _current = (_current + 1) % widget.banners.length;
        });
      }
    });
  }

  _getTimer() {
    return Timer.periodic(const Duration(seconds: 3), (timer) {
      if (mounted) {
        setState(() {
          _current = (_current + 1) % widget.banners.length;
        });
      }
    });
  }

  _resumeTimer() {
    _timer ??= _getTimer();
  }

  _clearTimer() {
    if (_timer != null) {
      _timer?.cancel();
      _timer = null;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget.isLargeScreen(context)
        ? _getWebCarousel()
        : _getMobileCarousel();
  }

  _getMobileCarousel() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onHorizontalDragStart: (details) => _clearTimer(),
          onHorizontalDragCancel: () => _resumeTimer(),
          onHorizontalDragEnd: (details) {
            final direction = details.primaryVelocity;
            if (direction == null) return;
            if (direction < 0) {
              setState(() {
                _current = (_current + 1) % widget.banners.length;
              });
            } else if (direction > 0) {
              setState(() {
                _current = (_current - 1) % widget.banners.length;
              });
            }
            _resumeTimer();
          },
          onTap: () {
            widget.banners[_current].action.executeAction(context);
            eventCall.bannerClickEvent('home_screen');
            },
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            transitionBuilder: (child, animation) =>
                FadeTransition(opacity: animation, child: child),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width,
              child: Stack(
                alignment: Alignment.bottomCenter,
                key: ValueKey(_current),
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    alignment: Alignment.bottomRight,
                    fit: BoxFit.fitHeight,
                    placeholder: (context, url) =>
                        const Center(child: Loader()),
                    imageUrl: widget.banners[_current].image,
                  ),
                  Container(
                    foregroundDecoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).colorScheme.background,
                          Theme.of(context)
                              .colorScheme
                              .background
                              .withOpacity(0.0),
                        ],
                        stops: const [
                          0,
                          0.01,
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                  ),
                  Positioned.fill(
                    left: 12,
                    top: 6,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: AspectRatio(
                          aspectRatio: 32 / 9,
                          child: widget.banners[_current].imageTitle.isNotEmpty
                              ? CachedNetworkImage(
                                  alignment: Alignment.center,
                                  fit: BoxFit.fitHeight,
                                  placeholder: (context, url) => Container(),
                                  errorWidget: (context, url, error) =>
                                      Container(),
                                  imageUrl: widget.banners[_current].imageTitle,
                                )
                              : Container(),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.banners.asMap().entries.map((entry) {
            return Container(
              width: _current == entry.key ? 7.0 : 5.0,
              height: _current == entry.key ? 7.0 : 5.0,
              margin: const EdgeInsets.only(left: 4, right: 4, top: 8),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: (_current == entry.key
                          ? Theme.of(context).textSelectionTheme.cursorColor
                          : Theme.of(context).colorScheme.onBackground)
                      ?.withOpacity(_current == entry.key ? 0.9 : 0.7)),
            );
          }).toList(),
        ),
      ],
    );
  }

  _getWebCarousel() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onHover: (value) {
            setState(() {
              isHovering = value;
            });
          },
          highlightColor: Colors.transparent,
          onTap: () => widget.banners[_current].action.executeAction(context),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) =>
                FadeTransition(opacity: animation, child: child),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width / 3,
              child: Stack(
                alignment: Alignment.bottomCenter,
                key: ValueKey(_current),
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    alignment: Alignment.bottomRight,
                    fit: BoxFit.fitWidth,
                    placeholder: (context, url) =>
                        const Center(child: Loader()),
                    imageUrl: widget.banners[_current].image,
                  ),
                  Container(
                    foregroundDecoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).colorScheme.background,
                          Theme.of(context)
                              .colorScheme
                              .background
                              .withOpacity(0.0),
                        ],
                        stops: const [
                          0,
                          0.35,
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 100, top: 150),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width / 3,
                        child: AspectRatio(
                          aspectRatio: 8 / 3,
                          child: widget.banners[_current].imageTitle.isNotEmpty
                              ? CachedNetworkImage(
                                  alignment: Alignment.center,
                                  fit: BoxFit.fitWidth,
                                  placeholder: (context, url) => Container(),
                                  errorWidget: (context, url, error) =>
                                      Container(),
                                  imageUrl: widget.banners[_current].imageTitle,
                                )
                              : Container(),
                        ),
                      ),
                    ),
                  ),
                  if (isHovering)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          setState(() {
                            _current = (_current - 1) % widget.banners.length;
                            _clearTimer();
                            _resumeTimer();
                          });
                        },
                      ),
                    ),
                  if (isHovering)
                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_forward),
                        onPressed: () {
                          setState(() {
                            _current = (_current + 1) % widget.banners.length;
                            _clearTimer();
                            _resumeTimer();
                          });
                        },
                      ),
                    )
                ],
              ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.banners.asMap().entries.map((entry) {
            return MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _current = entry.key;
                  });
                },
                child: Container(
                  width: _current == entry.key ? 12.0 : 10.0,
                  height: _current == entry.key ? 12.0 : 10.0,
                  margin: const EdgeInsets.symmetric(
                      /*vertical: 8.0,*/
                      horizontal: 4.0),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: (_current == entry.key
                              ? Theme.of(context).textSelectionTheme.cursorColor
                              : Theme.of(context).colorScheme.onBackground)
                          ?.withOpacity(_current == entry.key ? 0.9 : 0.7)),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
