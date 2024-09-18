

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:dor_companion/data/api/sensy_api.dart';
import 'package:dor_companion/data/models/constants.dart';
import 'package:dor_companion/data/models/models.dart';
import 'package:dor_companion/injection/injection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../data/models/user_interests.dart';
import '../../utils.dart';
import '../../widgets/media_detail/mdp_loaders.dart';

typedef FetchRows = Future<MediaDetail> Function();

class AddWatchListView extends StatefulWidget {
  final FetchRows mediaDetailFuture;

  const AddWatchListView({
    super.key,
    required this.mediaDetailFuture,
  });

  @override
  State<AddWatchListView> createState() => _AddWatchListViewState();
}

class _AddWatchListViewState extends State<AddWatchListView> {
  List<String> filters = ["Filter by", "Movie", "TV Shows", "Documentaries","Sports","Genre & Moods"];

  Map<String, MediaItem?> watchListFilter = <String, MediaItem?>{};

  List<MediaRow> rows = [];
  bool isError = false;
  int currentPage = 1;
  int totalPages = 1;

  @override
  void initState() {
    super.initState();
    _fetchData(widget.mediaDetailFuture);
  }

  _fetchData(FetchRows mediaDetailFuture) {
    watchListFilter.clear();
    if (mounted) {
      setState(() {
        isError = false;
        rows = [];
      });
    }

    currentPage = 1;
    final mediaDetailFetch = mediaDetailFuture();
    return mediaDetailFetch.then((mediaDetail) {
      if (mediaDetail.mediaRows.isEmpty) {
        if (mounted) {
          setState(() {
            isError = true;
          });
        }
        return;
      }

      if (mounted) {
        setState(() {
          isError = false;
          for (MediaRow row in mediaDetail.mediaRows) {
            if (row.mediaItems.isNotEmpty) {
              rows.add(row);
            }
          }
          totalPages = mediaDetail.mediaHeader?.meta.totalPages??0;
        });
      }
    }).catchError((errorObj) {
      switch (errorObj.runtimeType) {
        case DioException:
          final response = (errorObj as DioException).response;
          print("Failed to fetch page: ${response?.statusCode}");
          break;
        default:
          if (kDebugMode) {
            print("Encountered unknown error of type "
                "${errorObj.runtimeType} while fetching media detail");
            print("$errorObj");
          }
      }
      if (mounted) {
        setState(() {
          isError = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (rows.isEmpty && !isError) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.only(top: 50.0),
          child: MDPBodyLoader(),
        ),
      );
    }

    return Stack(
      children: [
        Column(
          children: [
            SizedBox(
              height: 30.h,
              width: MediaQuery.of(context).size.width,
            ),
            SizedBox(
              height: 40.h,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: EdgeInsets.only(left: 10.w),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: filters.length,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return SizedBox(
                        height: 31.h,
                        width: 55.w,
                        child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            filters[index],
                            style: AppTypography.addToWatchListFilters,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    }
                    return InkWell(
                      onTap: () {
                        _fetchData( () => getIt<SensyApi>()
                            .fetchSearchResult(filters[index]));
                      },
                      child: Padding(
                        padding: EdgeInsets.only(left: 10.w),
                        child: Container(
                          alignment: Alignment.center,
                          // /height: 31.h,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white,
                              width: 1.sp,
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(24.sp)),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: 10.w, top: 5.h, right: 10.w, bottom: 5.h),
                            child: Text(
                              filters[index],
                              style: AppTypography.addToWatchListFilterIndex,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            SizedBox(
              height: 30.h,
              width: MediaQuery.of(context).size.width,
            ),
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: rows.isNotEmpty ? rows[0].mediaItems.length : 0,
                itemBuilder: (context, index) {
                  final mediaItem = rows[0].mediaItems[index];
                  return InkWell(
                    onTap: () {
                      setState(() {
                        if (watchListFilter[mediaItem.itemID] == null) {
                          watchListFilter[mediaItem.itemID] = mediaItem;
                        } else {
                          watchListFilter.remove(mediaItem.itemID);
                        }
                      });
                    },
                    child: WatchListItem(
                      mediaItem: mediaItem,
                      isSelected: watchListFilter[mediaItem.itemID] == null,
                    ),
                  );
                },
              ),
            )
          ],
        ),
        Positioned(
          bottom: 50,
          child: AddTOWatchListButton(
            isAddedToWatchList: watchListFilter.isEmpty,
            onTap: () async {
              for(MediaItem? item in watchListFilter.values) {
                if (item != null) {
                  final itemType = item.itemType;
                  final itemId = item.itemID;
                   await context.read<UserInterestsChangeNotifier>().addToWatchlist(itemId, itemType,);
                }
              }
              //Navigator.pop(context);
            },
          ),
        ),
      ],
    );
  }
}

class AddTOWatchListButton extends StatelessWidget {
  final bool isAddedToWatchList;
  final VoidCallback onTap;

  const AddTOWatchListButton({
    super.key,
    required this.isAddedToWatchList,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color =
        isAddedToWatchList ? const Color(0xFF808080) : const Color(0xFF3C61D0);
    return SizedBox(
      height: 50.h,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 45.w),
        child: TextButton(
          onPressed: !isAddedToWatchList ? onTap : null,
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(color),
              foregroundColor: MaterialStateProperty.all(Colors.white)),
          child: Text(
            "ADD TO WATCHLIST",
            style: AppTypography.addToWatchListButton,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

class WatchListItem extends StatelessWidget {
  final MediaItem mediaItem;
  final bool isSelected;

  const WatchListItem({
    super.key,
    required this.mediaItem,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 20.sp, right: 20.sp),
      child: Column(
        children: [
          SizedBox(
            height: 80.h,
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: [
                Stack(
                  children: [
                    CachedNetworkImage(
                      height: 80.sp,
                      width: 80.sp,
                      fit: BoxFit.fill,
                      imageUrl: mediaItem.image,
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) =>
                              CircularProgressIndicator(
                                  value: downloadProgress.progress),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                    isSelected
                        ? Container()
                        : Container(
                            color: Colors.black.withOpacity(0.80),
                            height: 80.sp,
                            width: 80.sp,
                            child: SvgPicture.asset(
                              "assets/icons/check_circle.svg",
                              width: 10.sp,
                              height: 10.sp,
                              alignment: Alignment.center,
                              fit: BoxFit.scaleDown,
                            ),
                          ),
                  ],
                ),
                SizedBox(
                  width: 20.sp,
                ),
                SizedBox(
                  width: 250.sp,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        mediaItem.title,
                        overflow: TextOverflow.fade,
                        style:  AppTypography.mediaItemTitle,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        softWrap: false,
                      ),
                      Text(
                        mediaItem.subtitle,
                        overflow: TextOverflow.fade,
                        style: AppTypography.mediaItemSubTitle,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 10.h,
            width: MediaQuery.of(context).size.width,
          )
        ],
      ),
    );
  }
}
