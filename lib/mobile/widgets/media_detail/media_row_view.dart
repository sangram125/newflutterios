import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dor_companion/data/app_state.dart';
import 'package:dor_companion/firebase_analytics/firebase_analytics.dart';
import 'package:dor_companion/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:shimmer/shimmer.dart';

import '../../../data/api/sensy_api.dart';
import '../../../data/models/constants.dart';
import '../../../data/models/models.dart';
import '../../../injection/injection.dart';
import 'media_item_view.dart';
import '../../../widgets/media_detail/media_rows_view.dart';

class MediaRowView extends StatefulWidget {
   MediaRowView(this.mediaRow, {this.addRows,this.set, Key? key,
     this.isTopicScreen,
     // this.isToShowIcon
   }) : super(key: key);

   MediaRow mediaRow;
   AddRows? addRows;
   final bool? isTopicScreen;
   final void Function(List<MediaRow>)? set;
  @override
  State<MediaRowView> createState() => _MediaRowViewState();
}

class _MediaRowViewState extends State<MediaRowView> {
  ///* Used for [Apps for you section]

  final ScrollController _scrollController = ScrollController();

  List<MediaItem> selectedAppMediaItems = [];
  bool isAppForLoading = false;
  bool showLeftArrow = false;
  bool showRightArrow = true;
  double heightG = 0;
  double widthG = 0;
  bool isEdit = false;
  AnalyticsEvent eventCall = AnalyticsEvent();
  @override
  void initState() {
    // TODO: implement initState

    if (widget.mediaRow.contentType == 116) {

      selectedAppMediaItems = widget.mediaRow.mediaItems;
      {
        appState.indexOfFetchingData.value = widget.mediaRow.mediaItems.indexWhere((element) => element.itemID == "74");
        appState.currentView.value = appState.indexOfFetchingData.value;
        appState.currentView.notifyListeners();
        fetchDataR("app_lite", widget.mediaRow.mediaItems[ appState.indexOfFetchingData.value].package);
      }
    }
    _scrollController.addListener(() {
      setState(() {
        showLeftArrow = _scrollController.position.pixels > 0;
        showRightArrow = _scrollController.position.pixels <
            _scrollController.position.maxScrollExtent;
      });
    });

    super.initState();
  }
  int selectVal = 90;
  bool isLive = false;

  @override
  Widget build(BuildContext context) {
    ///* This is being used to show the Channel Logo, in case of Live-TV
    bool isChannelLogoAvailable = widget.mediaRow.rowImage is String &&
        widget.mediaRow.rowImage!.isNotEmpty;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height:  widget.mediaRow.mediaItems[0].isLiveTVItem ? 0:
        widget.isTopicScreen==true?10:5),
        if(widget.mediaRow.title != "Explore the OTT World")
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              widget.mediaRow.mediaItems[0].isLiveTVItem!=true ? Expanded(
                child: Padding(
                  padding: EdgeInsets.only(bottom: widget.mediaRow.title=="Watch by apps"||widget.mediaRow.title=="Top Genres"||widget.mediaRow.title=="The News People"?15.0:0.0),
                  child: Text(
                    widget.mediaRow.title,
                    style:widget.isTopicScreen==true?AppTypography.loginText.copyWith(color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 17,fontFamily: "Roboto")
                        : AppTypography.mediaRowTitle,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ): Container(),
              widget.mediaRow.title == "Explore the OTT World"
                  ? const SizedBox()
                  : widget.mediaRow.title == "Your favourite movies" ||
                  widget.mediaRow.title == "Your favourite shows" ||
                  widget.mediaRow.title == "Your movies watchlist"  ||
                  widget.mediaRow.title == "Your shows watchlist" ||
                  widget.mediaRow.title == "Your favourite people"  ||
                  widget.mediaRow.title == "Your favourite genres"? IconButton(
                onPressed: () {
                  isEdit = !isEdit;
                  setState(() {});
                },
                icon: isEdit == false ? const Icon(Icons.edit) : const Icon(Icons.close),
              )  : const SizedBox()
            ],
          ),
        ),
         if(widget.mediaRow.title == "Explore the OTT World")
           Container(
             decoration: const BoxDecoration(
               gradient: LinearGradient(
                 begin: Alignment(1.00, -0.05),
                 end: Alignment(-1, 0.10),
                 colors: [Color(0xFF0F1A4D), Color(0xFF141A4C)],
               ),
               boxShadow: [
                 BoxShadow(
                   color: Color(0x3F000000),
                   blurRadius: 4,
                   offset: Offset(0, 4),
                   spreadRadius: 0,
                 )
               ],
             ),
             padding: EdgeInsets.symmetric(vertical: 13),
             child: Row(children: [
               const SizedBox(width: 15,),
               SvgPicture.asset(
                 "assets/icons/solar_reel-broken.svg", // Top image
                 fit: BoxFit.fill,
               ),
               const SizedBox(width: 10,),
               const Column(
                 mainAxisSize: MainAxisSize.min,
                 mainAxisAlignment: MainAxisAlignment.center,
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Text(
                     'Explore all channels and apps',
                     textAlign: TextAlign.center,
                     style: TextStyle(
                       color: Colors.white,
                       fontSize: 16,
                       fontFamily: 'Roboto',
                       fontWeight: FontWeight.w600,
                       height: 0,
                     ),
                   ),
                   SizedBox(height: 4),
                   Text(
                     'See what’s trending on 20 OTTs',
                     style: TextStyle(
                       color: Color(0xFFABABAB),
                       fontSize: 12,
                       fontFamily: 'Roboto',
                       fontWeight: FontWeight.w400,
                       height: 0,
                     ),
                   ),
                 ],
               )
             ],),
           ),
         const SizedBox(height: 0),
        SizedBox(
          // People rows requires larger height to accommodate person names
          height: widget.mediaRow.mediaItems[0].isLiveTVItem ?
           63: (widget.isTopicScreen==true &&
              MediaRowContentTypes.peopleTypes.contains(widget.mediaRow.contentType))
              ?145:widget.mediaRow.title== "Top Genres"?widget.mediaRow.displayConfig.height*1.1:
          widget.mediaRow.title== "Watch by apps"?widget.mediaRow.displayConfig.height*1.1:widget.mediaRow.title== "The News People"?widget.mediaRow.displayConfig.height*1.1:widget.mediaRow.contentType == 116
               ?  MediaQuery.of(context).size.height * 0.49
               : MediaRowContentTypes.peopleTypes
               .contains(widget.mediaRow.contentType)
               ? (widget.mediaRow.mediaItems[0].isLiveTVItem ||
               !widget.mediaRow.mediaItems[0].isHomeScreen
               ? widget.mediaRow.displayConfig.height
               : widget.mediaRow.displayConfig.height + 32)
               : (!widget.mediaRow.mediaItems[0].isHomeScreen
               ? widget.mediaRow.displayConfig.height*1.1 + 36
               : widget.isTopicScreen==true?widget.mediaRow.displayConfig.height+45
              :widget.mediaRow.displayConfig.height* 1.1 + 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Flexible(
                child: widget.mediaRow.contentType == 116
                    ? exploreSection(isChannelLogoAvailable)
                    : ListView.builder(
                  shrinkWrap: true,
                  controller: _scrollController,
                  padding: const EdgeInsets.only(left: 16.0),
                  itemBuilder: (context, index) {
                     MediaItem mediaItem;
                    if (isChannelLogoAvailable) {
                      if (index == 0) {
                        double height = widget.mediaRow.displayConfig.height;
                        double width = widget.mediaRow.displayConfig.width;
                        return ChannelLogo(
                          channelName: widget.mediaRow.title,
                            logo: widget.mediaRow.rowImage!,
                            height: height,
                            width: width);
                      }
                      mediaItem = widget.mediaRow.mediaItems[index - 1];
                    } else {
                      mediaItem = widget.mediaRow.mediaItems[index];
                    }

                    return Padding(
                      padding: EdgeInsets.only(right:
                      widget.mediaRow.mediaItems[0].isLiveTVItem ? 0:
                      widget.isTopicScreen==true?16:16),
                      child: Stack(
                        children: [
                          MediaItemView(
                            isTopicScreen: widget.isTopicScreen??false,
                            mediaItem,
                            widget.mediaRow,
                            widget.addRows,
                            index,
                            unSelected: (unselected) {
                              for (var i = 1;
                                  i < widget.mediaRow.mediaItems.length;
                                  i++) {
                                isLive = widget
                                    .mediaRow.mediaItems[unselected].isLiveTVItem;
                                if (widget.mediaRow.mediaItems[unselected].selected ==
                                    true) {
                                  widget.mediaRow.mediaItems[i].selected = false;
                                  selectVal = unselected;
                                } else {
                                  widget.mediaRow.mediaItems[i].selected = false;
                                  selectVal = unselected;
                                }
                              }

                              setState(() {});
                            },
                            onAppSeriesLoaded: (mediaItems) {
                              setState(() {
                                selectedAppMediaItems = mediaItems;
                              });
                            },
                            isLoading: (isLoading) {
                              setState(() {
                                isAppForLoading = isLoading;
                              });
                            },
                            isEdit: isEdit,
                            set: (data){

                               // widget.mediaRow = data;
                                widget.set!.call(data);
                                // widget.mediaRow!.mediaItems.first = data.mediaItems.first;
                                // setState(() {});
                                print("media roow ${widget.mediaRow.toJson()}");

                             // widget.mediaRow = data;
                            },
                          ),
                          if(widget.mediaRow.mediaItems[0].isLiveTVItem)
                          if(isChannelLogoAvailable && index == 1 || !isChannelLogoAvailable && index == 0)
                          Container(decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.2),
                            border: const Border(
                              right: BorderSide(width: 2, color: Colors.red),
                            ),
                          ),width: MediaQuery.of(context).size.width * 0.20,),
                        ],
                      ),
                    );
                  },
                  itemCount: isChannelLogoAvailable
                      ? widget.mediaRow.mediaItems.length + 1
                      : widget.mediaRow.mediaItems.length,
                  scrollDirection: Axis.horizontal,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget exploreSection(bool isChannelLogoAvailable){
    int selectedIndex =  appState.indexOfFetchingData.value;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(-0.56, -0.83),
          end: Alignment(0.56, 0.83),
          colors: [Color(0xFF0E1348), Color(0x77183369)],
        ),
      ),
      child: Row(
        children: [
          // Container(width: MediaQuery.of(context).size.width * 0.25,
          //   child: ListView.builder(
          //     shrinkWrap: true,
          //     controller: _scrollController,
          //     padding: const EdgeInsets.only(left: 16.0),
          //     itemBuilder: (context, index) {
          //       MediaItem mediaItem;
          //       if (isChannelLogoAvailable) {
          //         if (index == 0) {
          //           double height = widget.mediaRow.displayConfig.height;
          //           double width = widget.mediaRow.displayConfig.width;
          //           return ChannelLogo(
          //               channelName: widget.mediaRow.title,
          //               logo: widget.mediaRow.rowImage!,
          //               height: height,
          //               width: width);
          //         }
          //         mediaItem = widget.mediaRow.mediaItems[index - 1];
          //       } else {
          //         mediaItem = widget.mediaRow.mediaItems[index];
          //       }
          //       return Padding(
          //         padding: EdgeInsets.only(right:
          //         widget.isTopicScreen==true?16:0),
          //         child: MediaItemView(
          //           isTopicScreen: widget.isTopicScreen??false,
          //           mediaItem,
          //           widget.mediaRow,
          //           widget.addRows,
          //           index,
          //           unSelected: (unselected) {
          //             for (var i = 1;
          //             i < widget.mediaRow.mediaItems.length;
          //             i++) {
          //               isLive = widget
          //                   .mediaRow.mediaItems[unselected].isLiveTVItem;
          //               if (widget.mediaRow.mediaItems[unselected].selected ==
          //                   true) {
          //                 widget.mediaRow.mediaItems[i].selected = false;
          //                 selectVal = unselected;
          //               } else {
          //                 widget.mediaRow.mediaItems[i].selected = false;
          //                 selectVal = unselected;
          //               }
          //             }
          //
          //             setState(() {});
          //           },
          //           onAppSeriesLoaded: (mediaItems) {
          //             setState(() {
          //               selectedAppMediaItems = mediaItems;
          //             });
          //           },
          //           isLoading: (isLoading) {
          //             setState(() {
          //               isAppForLoading = isLoading;
          //             });
          //           },
          //           isEdit: isEdit,
          //           set: (data){
          //
          //             // widget.mediaRow = data;
          //             widget.set!.call(data);
          //             // widget.mediaRow!.mediaItems.first = data.mediaItems.first;
          //             // setState(() {});
          //             print("media roow ${widget.mediaRow.toJson()}");
          //
          //             // widget.mediaRow = data;
          //           },
          //         ),
          //       );
          //     },
          //     itemCount: isChannelLogoAvailable
          //         ? widget.mediaRow.mediaItems.length + 1
          //         : widget.mediaRow.mediaItems.length,
          //     scrollDirection: Axis.vertical,
          //   ),
          // ),
          ValueListenableBuilder(
            valueListenable: appState.buttonCarouselController,
            builder: (context, value, child) {
              return Container(width: MediaQuery.of(context).size.width * 0.22,
                child: CarouselSlider.builder(
                  carouselController: appState.buttonCarouselController.value,
                  options: CarouselOptions(
                    height: double.infinity,
                    initialPage: selectedIndex,
                    viewportFraction: 0.25,
                    enableInfiniteScroll: true,
                    scrollDirection: Axis.vertical,
                    autoPlay: false,
                    autoPlayCurve: Curves.ease,
                    enlargeStrategy: CenterPageEnlargeStrategy.zoom,
                    enlargeCenterPage: true,
                    onPageChanged: (index, reason) {
                      appState.currentView.value = index;
                      String selectedItemid = "";

                      for (var i = 1;
                      i < widget.mediaRow.mediaItems.length;
                      i++) {
                        isLive = widget
                            .mediaRow.mediaItems[index].isLiveTVItem;
                        if (widget.mediaRow.mediaItems[index].selected ==
                            true) {
                          widget.mediaRow.mediaItems[i].selected = false;
                          selectVal = index;
                        } else {
                          widget.mediaRow.mediaItems[i].selected = false;
                          selectVal = index;
                        }
                      }

                      setState(() {});


                      selectedItemid = widget.mediaRow.mediaItems[index].package;

                      isAppForLoading = false;
                      setState(() {});

                      getIt<SensyApi>().fetchMediaDetail("app_lite", selectedItemid).then((mediaDetail) {
                        List<MediaRow> _rows = [];
                        List<MediaItem> mediaItems = [];

                        _rows = mediaDetail.mediaRows;

                        for (var element in _rows) {
                          mediaItems.addAll(element.mediaItems);
                        }
                        selectedAppMediaItems = mediaItems;
                        isAppForLoading = true;
                        setState(() {});
                        // if (!existingHeader) {
                        //   header = mediaDetail.mediaHeader;
                        // }
                      }).catchError((errorObj) {
                        switch (errorObj.runtimeType) {
                        // case DioException:
                        //   final error = (errorObj as DioException);
                        //   final response = error.response;
                        //   showVanillaToast("Failed to fetch page: ${response?.statusCode}");
                        //   if (kDebugMode) {
                        //     print("Failed to fetch page "
                        //         "${widget.itemType}:${widget.itemId}: ${error.type}: ${error.response}: ${error.message}");
                        //   }
                        }
                      });

                      setState(() {});
                    },
                  ),
                  itemCount: isChannelLogoAvailable
                      ? widget.mediaRow.mediaItems.length + 1
                      : widget.mediaRow.mediaItems.length,
                  itemBuilder: (BuildContext context, int index, int pageViewIndex) {
                    print("----------size.width------------");
                    print(MediaQuery.of(context).size.width/1400);
                    print("----------size.width------------");
                    MediaItem mediaItem;
                    if (isChannelLogoAvailable) {
                      if (index == 0) {
                        double height = widget.mediaRow.displayConfig.height;
                        double width = widget.mediaRow.displayConfig.width;
                        return ChannelLogo(
                            channelName: widget.mediaRow.title,
                            logo: widget.mediaRow.rowImage!,
                            height: height,
                            width: width);
                      }
                      mediaItem = widget.mediaRow.mediaItems[index - 1];
                    } else {
                      mediaItem = widget.mediaRow.mediaItems[index];
                    }
                    return ValueListenableBuilder(valueListenable: appState.currentView, builder: (context, value, child) {
                      return Opacity(
                        opacity: appState.currentView.value != index
                            ?(appState.currentView.value - 1) == index || (appState.currentView.value + 1) == index ? 0.4 : 0.3
                            : 1,
                        child: MediaItemView(
                          isTopicScreen: widget.isTopicScreen??false,
                          mediaItem,
                          widget.mediaRow,
                          widget.addRows,
                          index,
                          unSelected: (unselected) {
                            for (var i = 1;
                            i < widget.mediaRow.mediaItems.length;
                            i++) {
                              isLive = widget
                                  .mediaRow.mediaItems[unselected].isLiveTVItem;
                              if (widget.mediaRow.mediaItems[unselected].selected ==
                                  true) {
                                widget.mediaRow.mediaItems[i].selected = false;
                                selectVal = unselected;
                              } else {
                                widget.mediaRow.mediaItems[i].selected = false;
                                selectVal = unselected;
                              }
                            }

                            setState(() {});
                          },
                          onAppSeriesLoaded: (mediaItems) {
                            setState(() {
                              selectedAppMediaItems = mediaItems;
                            });
                          },
                          isLoading: (isLoading) {
                            setState(() {
                              isAppForLoading = isLoading;
                            });
                          },
                          isEdit: isEdit,
                          set: (data){

                            // widget.mediaRow = data;
                            widget.set!.call(data);
                            // widget.mediaRow!.mediaItems.first = data.mediaItems.first;
                            // setState(() {});
                            print("media roow ${widget.mediaRow.toJson()}");

                            // widget.mediaRow = data;
                          },
                        ),
                      );
                    },);
                  },
                ),
              );
            },
          ),

          if (selectedAppMediaItems.isNotEmpty)
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(left: 0,top: 15,bottom: 15),
                height: double.infinity,
                width: double.infinity,
                child: !isAppForLoading
                    ? GridView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 6,
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 4/3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      crossAxisCount: 2),
                  itemBuilder: (context, index) {
                      return Shimmer.fromColors(
                        baseColor: Color(0x77183369),
                        highlightColor: Color(0x77112449),
                        child: Container(width: double.infinity,height: double.infinity,decoration: BoxDecoration(color: Colors.red,borderRadius: BorderRadius.circular(10)),),
                      );
                  },
                )
                    : GridView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: selectedAppMediaItems.length > 7
                      ? 8
                      : selectedAppMediaItems.length + 1,
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 3/2.2,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 2,
                      crossAxisCount: 2),
                  itemBuilder: (context, index) {
                    int totalItem = selectedAppMediaItems.length > 7
                        ? 8
                        : selectedAppMediaItems.length + 1;
                    if((totalItem - 1) == index){
                      return GestureDetector(
                        onTap: () {
                          if (selectVal != 90) {
                            widget.mediaRow.mediaItems[selectVal]
                                .isAppForYou = true;
                            // fetchData("pr_app", widget.mediaRow.mediaItems[selectVal].itemID);
                            widget.mediaRow.mediaItems[selectVal].actions[0]
                                .chatAction
                                .executeAction(
                              context,
                              mediaItem:
                              widget.mediaRow.mediaItems[selectVal],
                            );
                          } else {
                            widget.mediaRow.mediaItems[0].isAppForYou = true;
                            // fetchData("pr_app", widget.mediaRow.mediaItems[selectVal].itemID);
                            widget
                                .mediaRow.mediaItems[0].actions[0].chatAction
                                .executeAction(
                              context,
                              mediaItem: widget.mediaRow.mediaItems[0],
                            );
                          }
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 7,vertical: 15),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment(-0.41, -0.91),
                              end: Alignment(0.41, 0.91),
                              colors: [Color(0xFF162096), Color(0xFF030730)],
                            ),
                            borderRadius: BorderRadius.circular(7),
                            border: Border.all(
                              color: Color(0xFF5E5CE6),
                              width: 0.50,
                            ),
                          ),
                          child: Column(mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "View more",
                                style: AppTypography.mediaRowViewAllText,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 15),
                                child: Container(
                                  decoration: ShapeDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment(-0.41, -0.91),
                                      end: Alignment(0.41, 0.91),
                                      colors: [Color(0x235E5E5E), Color(0x005E5E5E)],
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(7.29),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Icon(Icons.arrow_forward),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    }
                    return InkWell(
                      onTap: () {
                        selectedAppMediaItems[index]
                            .actions[0]
                            .chatAction
                            .executeAction(
                          context,
                          mediaItem:
                          selectedAppMediaItems[index],
                        );
                      },
                      child: Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: SizedBox(
                              height: heightG,
                              width: widthG,
                              child: FittedBox(
                                fit: BoxFit.fill,
                                child: Image.network(
                                  selectedAppMediaItems[index].image,
                                ),
                              ),
                            ),
                          )),
                    );
                  },
                ),
              ),
            ),
          if (selectedAppMediaItems.isEmpty && isAppForLoading)
            Column(
              children: [
                GestureDetector(
                  onTap: () {
                    if (selectVal != 90) {
                      widget.mediaRow.mediaItems[selectVal]
                          .isAppForYou = true;
                      // fetchData("pr_app", widget.mediaRow.mediaItems[selectVal].itemID);
                      widget.mediaRow.mediaItems[selectVal].actions[0]
                          .chatAction
                          .executeAction(
                        context,
                        mediaItem:
                        widget.mediaRow.mediaItems[selectVal],
                      );
                    } else {
                      widget.mediaRow.mediaItems[2].isAppForYou = true;
                      // fetchData("pr_app", widget.mediaRow.mediaItems[selectVal].itemID);
                      widget
                          .mediaRow.mediaItems[2].actions[0].chatAction
                          .executeAction(
                        context,
                        mediaItem: widget.mediaRow.mediaItems[2],
                      );
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 7,vertical: 15),
                    width: MediaQuery.of(context).size.width * 0.34,
                    height: MediaQuery.of(context).size.height * 0.22,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment(-0.41, -0.91),
                        end: Alignment(0.41, 0.91),
                        colors: [Color(0xFF162096), Color(0xFF030730)],
                      ),
                      borderRadius: BorderRadius.circular(7),
                      border: Border.all(
                        color: Color(0xFF5E5CE6),
                        width: 0.50,
                      ),
                    ),
                    child: Column(mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "View more",
                          style: AppTypography.mediaRowViewAllText,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: Container(
                            decoration: ShapeDecoration(
                              gradient: LinearGradient(
                                begin: Alignment(-0.41, -0.91),
                                end: Alignment(0.41, 0.91),
                                colors: [Color(0x235E5E5E), Color(0x005E5E5E)],
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(7.29),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Icon(Icons.arrow_forward),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            )
        ],
      ),
    );
  }

  Future<void> fetchDataR(String itemType, String itemId) async {
    getIt<SensyApi>().fetchMediaDetail("app_lite", itemId).then((mediaDetail) {
      print(mediaDetail.mediaRows);

      setState(() {
        isAppForLoading = true;
        selectedAppMediaItems = mediaDetail.mediaRows[0].mediaItems;

        heightG = mediaDetail.mediaRows[0].displayConfig.height;
        widthG = mediaDetail.mediaRows[0].displayConfig.width;
      });
    }).catchError((errorObj) {
      switch (errorObj.runtimeType) {
      }
    });
  }
}

class ChannelLogo extends StatelessWidget {
  final String logo;
  final double height;
  final double width;
  final String channelName;
  const ChannelLogo({
    super.key,
    required this.logo,
    required this.height,
    required this.width, required this.channelName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width/2.3,
      decoration: BoxDecoration(
        border: Border.all(
          color: Color(0xFF445492), // Specify your border color here

        ),
      ),
      child: Row(
        children: [
          CachedNetworkImage(
            placeholder: (context, url) => Container(

              color: Theme.of(context).colorScheme.primaryContainer,
            ),
            errorWidget: (_, __, ___) => Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.errorContainer,
              ),
            ),
            height: double.infinity,
            imageUrl: logo,
            fit: BoxFit.fill,
          ),
          // Expanded(child: IconButton(onPressed: (){}, icon: Icon(Icons.favorite_border))),
          // const SizedBox(width: 5,),
        ],
      ),
    );
  }
}
