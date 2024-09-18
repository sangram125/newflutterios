import 'package:dio/dio.dart';
import 'package:dor_companion/data/api/sensy_api.dart';
import 'package:dor_companion/data/models/constants.dart';
import 'package:dor_companion/injection/injection.dart';
import 'package:dor_companion/widgets/loader.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../data/models/models.dart';
import '../../mobile/widgets/media_detail/media_row_view.dart' as mob_row_view;
import '../../responsive.dart';
import '../../utils.dart';
import '../../web/widgets/media_detail/media_row_view.dart' as web_row_view;
import 'mdp_loaders.dart';

const int _nextPageBuffer = 2;

typedef AddRows = Future<void> Function(
    Future<MediaDetail> fetchRows, MediaRow afterRow);
typedef FetchRows = Future<MediaDetail> Function();

class MediaRowsView extends StatefulWidget {
  const MediaRowsView({
    Key? key,
    required this.mediaDetailFuture,
    this.itemType,
    this.itemId, this.isTopicScreen,
  }) : super(key: key);

  final FetchRows mediaDetailFuture;
  final String? itemType;
  final String? itemId;
  final bool? isTopicScreen;

  @override
  State<MediaRowsView> createState() => _MediaRowsViewState();
}

class _MediaRowsViewState extends State<MediaRowsView>
    with AutomaticKeepAliveClientMixin {
  List<MediaRow> rows = [];
  bool isError = false;
  int currentPage = 1;
  int totalPages = 1;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  _fetchData() {
    if (mounted) {
      setState(() {
        isError = false;
        rows = [];
      });
    }

    currentPage = 1;
    final mediaDetailFetch = widget.mediaDetailFuture();
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
          if (kDebugMode) {
          //  showVanillaToast("Failed to fetch page: ${response?.statusCode}");
          }          break;
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
    super.build(context);
    if (rows.isEmpty && !isError) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.only(top: 50.0),
          child: MDPBodyLoader(),
        ),
      );
    }

    if (isError) {
      return const Expanded(
        child: Center(
          child: Text(
            "No Results Found",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 22,
                  fontFamily: "Roboto"),
          ),
        ),
      );
    }

    final isLargeScreen = ResponsiveWidget.isLargeScreen(context);

    return ListView.builder(
      itemCount: rows.length + (currentPage < totalPages ? 1 : 0),
      itemBuilder: (context, index) {
        if (widget.itemType != null &&
            widget.itemId != null &&
            currentPage < totalPages &&
            index > rows.length - _nextPageBuffer) {
          currentPage++;
          addRows(
            getIt<SensyApi>().fetchPaginatedMediaDetail(
                widget.itemType!, widget.itemId!, currentPage),
            rows.last,
          ).catchError((errorObj) {
            switch (errorObj.runtimeType) {
              case DioException:
                final response = (errorObj as DioException).response;
                showVanillaToast("Failed to fetch next page: "
                    "${response?.statusCode}");
            }
          });
        }

        if (index >= rows.length) {
          return const SizedBox(
            height: 75,
            child: Center(child: Loader()),
          );
        }

        return isLargeScreen
            ? web_row_view.MediaRowView(rows[index], addRows: addRows)
            : mob_row_view.MediaRowView(rows[index], addRows: addRows,
          isTopicScreen: widget.isTopicScreen,);
      },
    );
  }

  Future<void> addRows(Future<MediaDetail> fetchRows, MediaRow afterRow) {
    return fetchRows.then((newRows) {
      setState(() {
        rows.insertAll(rows.indexOf(afterRow) + 1, newRows.mediaRows);
      });
    }).catchError((errorObj) {
      switch (errorObj.runtimeType) {
        case DioException:
          final response = (errorObj as DioException).response;
          showVanillaToast("Failed to fetch additional rows: "
              "${response?.statusCode}");
      }
      // TODO: Separate error state for additional row fetch failure
      /*setState(() {
        isError = true;
      });*/
      throw errorObj;
    });
  }

  @override
  bool get wantKeepAlive => true;
}
