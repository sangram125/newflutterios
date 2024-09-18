import 'package:dio/dio.dart';
import 'package:dor_companion/data/models/constants.dart';
import 'package:dor_companion/firebase_analytics/firebase_performance.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../data/api/sensy_api.dart';
import '../../data/models/models.dart';
import '../../injection/injection.dart';
import '../../utils.dart';
import '../../widgets/appbar.dart';
import '../../widgets/loader.dart';
import '../widgets/media_detail/media_header_view.dart';
import '../widgets/media_detail/media_row_view.dart';

class MediaDetailView extends StatefulWidget {
  const MediaDetailView({
    Key? key,
    required this.itemType,
    required this.itemId,
    this.header,
  }) : super(key: key);

  final String itemType;
  final String itemId;
  final MediaHeader? header;

  @override
  State createState() => _MediaDetailViewState();
}

class _MediaDetailViewState extends State<MediaDetailView> {
  MediaHeader? header;
  List<MediaRow> _rows = [];
  bool _isRowsError = false;
  ScaffoldMessengerState? snackbar;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final tempHeader = widget.header;
    bool existingHeader = tempHeader != null;

    setState(() {
      _isRowsError = false;
      _rows = [];
      header = existingHeader ? tempHeader : null;
    });

    snackbar?.removeCurrentSnackBar(reason: SnackBarClosedReason.action);
    print("fetch media detail");
    final Trace trace = FirebasePerformance.instance.newTrace('fetch-media-detail');
    trace.start();
    getIt<SensyApi>()
        .fetchMediaDetail(widget.itemType, widget.itemId)
        .then((mediaDetail) {
      if (mounted) {
        setState(() {
          _isRowsError = mediaDetail.mediaRows.isEmpty;
          for (MediaRow row in mediaDetail.mediaRows) {
            if (row.mediaItems.isNotEmpty) {
              _rows.add(row);
                for (var mediaItem in row.mediaItems) {
                  mediaItem.isHomeScreen = true;
                }
            }
          }
          if (!existingHeader) {
             print("testing header ${ mediaDetail.mediaHeader} ");
            header = mediaDetail.mediaHeader;
          }
        });
      }
    }).catchError((errorObj) {
      switch (errorObj.runtimeType) {
        case DioException:
          final error = (errorObj as DioException);
          final response = error.response;
          print("Failed to fetch page: ${response?.statusCode}");
          if (kDebugMode) {
            print("Failed to fetch page "
                "${widget.itemType}:${widget.itemId}: ${error.type}: ${error.response}: ${error.message}");
          }
      }
      if (mounted) {
        setState(() {
          _isRowsError = true;
          _rows = [];
          header = existingHeader ? tempHeader : null;
        });
        // showRetrySnackbar();
      }
    });
    trace.stop();
  }

  void showRetrySnackbar() {
    final retrySnackBar = SnackBar(
      content: Text(
        "Failed to fetch page",
        style: TextStyle(color: Theme.of(context).colorScheme.onError),
      ),
      action: SnackBarAction(
        label: "RETRY",
        onPressed: fetchData,
        textColor: Theme.of(context).colorScheme.onError,
      ),
      backgroundColor: Theme.of(context).colorScheme.error,
      duration: const Duration(days: 1),
    );
    ScaffoldMessenger.of(context).showSnackBar(retrySnackBar);
  }

  @override
  Widget build(BuildContext context) {
    snackbar = ScaffoldMessenger.of(context);

    return WillPopScope(
      onWillPop: () {
        snackbar?.removeCurrentSnackBar();
        return Future.value(true);
      },
      child: PerformanceTrackedWidget(
        widgetName: 'media-detail-view',
        child: Scaffold(
          appBar: const CustomAppBar(),
          body: SafeArea(
            child: RefreshIndicator(
              onRefresh: fetchData,
              child:
              // _isRowsError==true?SizedBox(
              //   height: MediaQuery.of(context).size.width,
              //   child: Center(
              //     child: ElevatedButton(
              //       onPressed: fetchData,
              //       style: ElevatedButton.styleFrom(
              //         shape: const StadiumBorder(),
              //         backgroundColor: Theme.of(context).colorScheme.tertiary,
              //         textStyle: const TextStyle(fontSize: 16),
              //       ),
              //       child: const Text("Tap to retry",style: AppTypography.undefinedTextStyle, ),
              //     ),
              //   ),
              // ):
              CustomScrollView(slivers: _buildBody()),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildBody() {
    final tempHeader = header;
    if (_rows.isEmpty && !_isRowsError) {
      return [
        if (tempHeader != null)
          MediaHeaderView(
            mediaHeader: tempHeader,
            row: [],
          ),
        const SliverToBoxAdapter(
          child: SizedBox(
            height: 300,
            child: Center(child: Loader()),
          ),
        ),
      ];
    }

    if (_isRowsError) {
      return [
        if (tempHeader != null)
          MediaHeaderView(
            mediaHeader: tempHeader,
            row: [],
          ),
        const SliverToBoxAdapter(
          child: SizedBox(height: 250),
        )
      ];
    }

    return [
      if (tempHeader != null)
      
        MediaHeaderView(
          mediaHeader: tempHeader,
          row:  _rows.where((element) {
            return element.title == "People";
          }).toList(),

        ),

      SliverList(
        delegate: SliverChildBuilderDelegate(
              (context, index) {
            final row = _rows[index];
            if (row.title == "People") {
              return Container();

            } else {
              return MediaRowView(
               //isToShowIcon: true,
                isTopicScreen: true,
                row,
              );
            }
          },
          childCount: _rows.length,
        ),
      )
    ];
  }
}
