import 'package:flutter/material.dart';

import '../../../data/models/constants.dart';
import '../../../data/models/models.dart';
import '../../../widgets/media_detail/media_rows_view.dart';
import 'media_item_view.dart';

class MediaRowView extends StatefulWidget {
  const MediaRowView(this.mediaRow, {this.addRows, Key? key}) : super(key: key);

  final MediaRow mediaRow;
  final AddRows? addRows;

  @override
  State<MediaRowView> createState() => _MediaRowViewState();
}

class _MediaRowViewState extends State<MediaRowView> {
  final CustomScrollController _scrollController = CustomScrollController();
  bool canScrollLeft = false;
  bool canScrollRight = false;
  bool isInitialized = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      setState(() {
        canScrollLeft = _scrollController.offset > 0;
        canScrollRight = _scrollController.offset <
            _scrollController.position.maxScrollExtent;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!isInitialized) {
      canScrollRight = (widget.mediaRow.displayConfig.width * 1.3 + 20) *
              widget.mediaRow.mediaItems.length >
          MediaQuery.of(context).size.width;
      isInitialized = true;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 30),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            widget.mediaRow.title,
            style: const TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ),
        // Disable MediaItemGroup row
        /*if (mediaRow.mediaItemGroups.isNotEmpty)
          const SizedBox(
            height: 15,
          ),
        SizedBox(
          height: 20,
          child: ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.only(left: 10.0),
            itemBuilder: (context, index) {
              return MediaItemView(mediaRow.mediaItemGroups[index], mediaRow);
            },
            itemCount: mediaRow.mediaItemGroups.length,
            scrollDirection: Axis.horizontal,
          ),
        ),*/
        const SizedBox(height: 15),
        Stack(
          children: [
            SizedBox(
              // People rows requires larger height to accommodate person names
              height: MediaRowContentTypes.peopleTypes
                      .contains(widget.mediaRow.contentType)
                  ? widget.mediaRow.displayConfig.height * 1.2 + 32
                  : (widget.mediaRow.displayConfig.height + 35) * 1.2 * 1.3,
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                controller: _scrollController,
                shrinkWrap: true,
                padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                itemBuilder: (context, index) {
                  final mediaItem = widget.mediaRow.mediaItems[index];
                  return MediaItemView(
                    mediaItem,
                    widget.mediaRow,
                    widget.addRows,
                  );
                },
                itemCount: widget.mediaRow.mediaItems.length,
                scrollDirection: Axis.horizontal,
              ),
            ),
            if (canScrollLeft)
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                child: Container(
                  width: 60,
                  color: Colors.black.withOpacity(0.4),
                  alignment: Alignment.center,
                  child: IconButton(
                    onPressed: () {
                      _scrollController.scrollToPrevious(context);
                    },
                    icon: const Icon(Icons.arrow_back),
                  ),
                ),
              ),
            if (canScrollRight)
              Positioned(
                right: 0,
                top: 0,
                bottom: 0,
                child: Container(
                  width: 60,
                  color: Colors.black.withOpacity(0.4),
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    onPressed: () {
                      _scrollController.scrollToNext(context);
                    },
                    icon: const Icon(Icons.arrow_forward),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class CustomScrollController extends ScrollController {
  void scrollToNext(BuildContext context) {
    final double maxScrollExtent = position.maxScrollExtent;
    final double currentScrollPosition = position.pixels;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double scrollDistance = screenWidth * 0.8;

    if (currentScrollPosition < maxScrollExtent) {
      animateTo(currentScrollPosition + scrollDistance,
          duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
    }
  }

  void scrollToPrevious(BuildContext context) {
    final double currentScrollPosition = position.pixels;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double scrollDistance = screenWidth * 0.8;

    if (currentScrollPosition > 0) {
      animateTo(currentScrollPosition - scrollDistance,
          duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
    }
  }
}
