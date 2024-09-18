import 'package:dio/dio.dart';
import 'package:dor_companion/data/app_state.dart';
import 'package:dor_companion/data/models/models.dart';
import 'package:dor_companion/firebase_analytics/firebase_analytics.dart';
import 'package:dor_companion/firebase_analytics/firebase_performance.dart';
import 'package:dor_companion/mobile/help_and_support/widgets/custom_bottom_sheet.dart';
import 'package:dor_companion/mobile/help_and_support/widgets/help_support_header_widget.dart';
import 'package:dor_companion/mobile/profile/controller/profile_controller.dart';
import 'package:dor_companion/mobile/widgets/live_tv_view.dart';
import 'package:dor_companion/responsive.dart';
import 'package:dor_companion/widgets/appbar.dart';
import 'package:dor_companion/widgets/gradient_background_widget.dart';
import 'package:dor_companion/widgets/loader.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/models/constants.dart';
import '../../mobile/widgets/media_detail/media_row_view.dart' as mob_row_view;

class TVGuidePage extends StatefulWidget {


  const TVGuidePage(
      {super.key,});

  @override
  State<TVGuidePage> createState() => TVGuidePageState();
}

class TVGuidePageState extends State<TVGuidePage> {
  @override
  Widget build(BuildContext context) {
    AnalyticsEvent eventCall = AnalyticsEvent();

    _buildGenresChips( {required  Function() refreshCall}) {
      return Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Wrap(
            spacing: 8.0, // Space between chips horizontally
            runSpacing: 4.0, // Space between chips vertically
            children: appState.genres.value.list.map((genre) {
              return GenreChipWidget(
                onTap: () {
                  eventCall.filterEventLiveTv('live_tv_screen');
                  setState(() {
                    if (appState.genres.value.list.indexOf(genre) == 0) {
                      if (genre.isSelected) return;
                      genre.isSelected = !genre.isSelected;
                      if (genre.isSelected) {
                        appState.genres.value.list
                            .sublist(1)
                            .forEach((genre) => genre.isSelected = false);
                      }
                    } else {
                      genre.isSelected = !genre.isSelected;
                      if (appState.genres.value.list
                          .sublist(1)
                          .where((genre) => genre.isSelected)
                          .isNotEmpty) {
                        appState.genres.value.list.first.isSelected = false;
                      } else {
                        appState.genres.value.list.first.isSelected = true;
                      }
                    }
                  });
                  refreshCall();
                },
                title: genre.title,
                isSelected: genre.isSelected,
              );
            }).toList(),
          ),
          const SizedBox(
            height: 4,
          ),
          // const Divider(),
          // const SizedBox(
          //   height: 20,
          // ),
          // InkWell(
          //   onTap: () => context.push("/subscriptions"),
          //   child: const Padding(
          //     padding: EdgeInsets.symmetric(horizontal: 15),
          //     child: SizedBox(
          //       height: 150,
          //       child: Image(
          //           image: AssetImage('assets/images/home_images/Card.png')),
          //     ),
          //   ),
          // ),
          // const SizedBox(
          //   height: 20,
          // ),
          // const Divider(),
        ],
      );
    }
    Column _buildLanguageChips({required  Function() refreshCall}) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),
          Wrap(
            spacing: 8.0, // Space between chips horizontally
            runSpacing: 4.0, // Space between chips vertically
            children: appState.languages.value.list.map((languages) {
              return LanguageChipWidget(
                onTap: () {
                  eventCall.filterEventLiveTv('live_tv_screen');
                  setState(() {
                    if (appState.languages.value.list.indexOf(languages) == 0) {
                      if (languages.isSelected) return;
                      languages.isSelected = !languages.isSelected;
                      if (languages.isSelected) {
                        appState.languages.value.list
                            .sublist(1)
                            .forEach((languages) => languages.isSelected = false);
                      }
                    } else {
                      languages.isSelected = !languages.isSelected;
                      if (appState.languages.value.list
                          .sublist(1)
                          .where((languages) => languages.isSelected)
                          .isNotEmpty) {
                        appState.languages.value.list.first.isSelected = false;
                      } else {
                        appState.languages.value.list.first.isSelected = true;
                      }
                    }
                    refreshCall();
                  });
                },
                title: languages.title,
                isSelected: languages.isSelected,
              );
            }).toList(),
          ),
          const SizedBox(
            height: 20,
          ),
          // const Divider(),
          // const SizedBox(
          //   height: 20,
          // ),
          // InkWell(
          //   onTap: () => context.push("/subscriptions"),
          //   child: const Padding(
          //     padding: EdgeInsets.symmetric(horizontal: 15),
          //     child: SizedBox(
          //       height: 150,
          //       child: Image(
          //           image: AssetImage('assets/images/home_images/Card.png')),
          //     ),
          //   ),
          // ),
          // const SizedBox(
          //   height: 20,
          // ),
          // const Divider(),
        ],
      );
    }
    _applyFilters() {
      Navigator.of(context).pop();
      List<String> _selectedGenres = appState.genres.value.list
          .where((genre) => genre.isSelected)
          .map((genre) => genre.title)
          .toList();
      bool isAllGenreSelected = _selectedGenres.first == 'All';
      List<String> _selectedLanguages = appState.languages.value.list
          .where((language) => language.isSelected)
          .map((language) => language.title)
          .toList();
      bool isAllLanguageSelected = _selectedLanguages.first == 'All';
      appState.filteredChannels.value = appState.channels.value
          .where((channel) =>
      (isAllGenreSelected || _selectedGenres.contains(channel.genre)) &&
          (isAllLanguageSelected ||
              _selectedLanguages.contains(channel.language)))
          .toList();

      appState.totalPages.value =
          (appState.filteredChannels.value.length / 10).ceil();
      appState.currentPage.value = 1;
      final channelIdsToFetch = appState.filteredChannels.value
          .sublist((appState.currentPage.value - 1) * appState.filteredChannels.value.length,
          appState.currentPage.value * appState.filteredChannels.value.length)
          .map((channel) => channel.id)
          .join(',');
      List<String> channelIds = channelIdsToFetch.split(',');

      if(appState.selectedFilterList.value.isEmpty){
        appState.selectedFilterList.value =  appState.rows.value;
      }
      appState.rows.value = [];
      appState.selectedFilterList.value.asMap().forEach((index, value) {

        channelIds.asMap().forEach((index , e) {
          if(value.mediaItems.elementAt(0).schedule!.channelId == int.parse(e)){
            appState.rows.value.add(value);
          }
          else{
            print("not found");
          }

        });
      });
      appState.loadingMore.value = false;
      setState(() {

      });
      appState.loadingMore.value = false;
      //data.clear();
      // appState.rows.value = [];
      // fetchData(isLoadMore: true);
    }
    Widget _buildBanners() {
      final banners =
      ResponsiveWidget.isLargeScreen(context) ? appState.bannersWeb.value : appState.banners.value;
      final isBannersError = ResponsiveWidget.isLargeScreen(context)
          ? appState.isBannersWebError.value
          : appState.isBannersError.value;
      if (banners.isEmpty && !isBannersError) {
        if (kDebugMode) {
          print("returning banner loader");
        }
        return SizedBox(
            height: MediaQuery.of(context).size.width,
            child: const Center(child: Loader()));
      }

      // if (isBannersError) {
      //   return SizedBox(
      //     height: MediaQuery.of(context).size.width,
      //     child: Center(
      //       child: ElevatedButton(
      //         onPressed: fetchBanners,
      //         style: ElevatedButton.styleFrom(
      //           shape: const StadiumBorder(),
      //           backgroundColor: Theme.of(context).colorScheme.tertiary,
      //           textStyle: AppTypography.fontSizeChanges,
      //         ),
      //         child: const Text("Tap to retry", style: AppTypography.undefinedTextStyle,),
      //       ),
      //     ),
      //   );
      // }

      return  Column(
        children: [
          // if (widget.itemId == "home")
          // _buildGenresChips(),
          //  BannersCarousel(
          //    banners: banners,
          //  ),
          //_buildLanguageChips(),
        ],
      );
    }


    return  PerformanceTrackedWidget(
      widgetName: 'profile-selection-view',
      child: Scaffold(

        body: SafeArea(
          child: GradientBackground(
            child:  Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: HelpAndSupportHeaderWidget(title:""),
                ),
                ValueListenableBuilder(valueListenable: appState.rows, builder: (context, value, child) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 16.0,right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'Showing ',
                                style: GoogleFonts.roboto(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  height: 0.12,
                                  letterSpacing: 0.15,
                                ),
                              ),
                              TextSpan(
                                text: '(${appState.rows.value.length.toString()} Channels)',
                                style: GoogleFonts.roboto(
                                  color: Color(0xFFC7C7C7),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  height: 0.17,
                                  letterSpacing: 0.15,
                                ),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        GestureDetector(
                            onTap:(){
                              showModalBottomSheet(context: context, builder:
                                  (context) =>  StatefulBuilder(
                                  builder: (BuildContext context, StateSetter setState) {
                                    return CustomBottomSheet(
                                      content: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(left: 8.0),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text("Apply Filters",style: AppTypography.loginText.copyWith(color: Colors.white,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 17,fontFamily: "Roboto"),),
                                                IconButton(onPressed: (){Navigator.of(context).pop();}, icon: const Icon(Icons.close)),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 10,),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 8.0),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Text("Content Type",style: GoogleFonts.roboto(
                                                  color: Colors.white,
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w500,
                                                  letterSpacing: 0.15,
                                                ),),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 10,),
                                          _buildGenresChips(refreshCall:(){
                                            setState(() {});
                                          }),
                                          const SizedBox(height: 20,),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 8.0),
                                            child: Row(
                                              children: [
                                                Text("Language",style: GoogleFonts.roboto(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              letterSpacing: 0.15,
                                            ),),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 10,),
                                          _buildLanguageChips(refreshCall: (){setState((){});}),
                                          const SizedBox(height: 10,),
                                          Container(
                                            width: double.infinity,
                                            height: 35,
                                            child: ElevatedButton(
                                              onPressed: (){_applyFilters();
                                              },
                                              style: ButtonStyle(
                                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(12.0), // Set your desired border radius here
                                                  ),),
                                                backgroundColor: MaterialStateProperty
                                                    .all<Color>(Colors.white,), // Set desired color
                                              ),
                                              child: const Text("Done",style:TextStyle(
                                                  fontSize: 16,color: Colors.black
                                              ),),
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  }
                              ),
                                  backgroundColor: Colors.transparent,
                                  isScrollControlled: true,
                                  barrierColor:const Color(0xff00021f).withOpacity(.5) );

                            },
                            child: SvgPicture.asset("assets/images/home_images/filter_icon_live_tv.svg")
                        )
                      ],
                    ),
                  );
                },),
                const SizedBox(height: 5,),
                ValueListenableBuilder(
                  valueListenable: appState.channels,
                  builder: (BuildContext context, value, Widget? child) {
                    return ValueListenableBuilder(
                      valueListenable: appState.banners,
                      builder: (BuildContext context, value, Widget? child) {
                        return ValueListenableBuilder(
                          valueListenable: appState.rows,
                          builder: (BuildContext context, value, Widget? child) {
                            return Expanded(
                              child: ListView.builder(
                                controller: appState.scrollController.value,
                                itemCount: appState.rows.value.length + 2,
                                itemBuilder: (context, index) {
                                  if (kDebugMode) {
                                    print("${widget.key} building row $index");
                                  }
                                  if (index == 0) {
                                    return _buildBanners();
                                  }

                                  // if (index >= rows.length + 1) {
                                  //   return const SizedBox(
                                  //     height: 75,
                                  //     child: Center(child: Loader()),
                                  //   );
                                  // }

                                  if (index >= appState.rows.value.length + 1) {
                                    return Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        if (appState.loadingMore.value)
                                          const SizedBox(
                                            height: 75,
                                            child: Center(child: Loader()),
                                          ),
                                        //const SizedBox(height: 75),
                                      ],
                                    );
                                  }
                                  // return MediaRowViewLiveTV(
                                  //   appState.rows.value[index - 1],
                                  //            addRows: addRows
                                  // );
                                  return mob_row_view.MediaRowView(
                                      appState.rows.value[index - 1],
                                      addRows: addRows);
                                },
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ],
            ),

          ),
        ),
      ),
    );
  }
  Future<void> addRows(Future<MediaDetail> fetchRows, MediaRow afterRow) {
    return fetchRows.then((newRows) {
      setState(() {
        appState.rows.value.insertAll(
            appState.rows.value.indexOf(afterRow) + 1, newRows.mediaRows);
      });
    }).catchError((errorObj) {
      switch (errorObj.runtimeType) {
        case DioException:
          final response = (errorObj as DioException).response;
          print("Failed to fetch additional rows: "
              "${response?.statusCode}");
      }
      // TODO: Separate error state for additional row fetch failure
      /*setState(() {
        isError = true;
      });*/
      throw errorObj;
    });
  }
}

