
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../data/models/constants.dart';
import '../../../data/models/models.dart';
import 'media_item_view.dart';
import '../../../widgets/media_detail/media_rows_view.dart';

class MediaRowViewLiveTV extends StatelessWidget {
  const MediaRowViewLiveTV(this.mediaRow, {this.addRows, Key? key})
      : super(key: key);

  final MediaRow mediaRow;
  final AddRows? addRows;

  @override
  Widget build(BuildContext context) {
    ///* This is being used to show the Channel Logo, in case of Live-TV
    bool isChannelLogoAvailable = mediaRow.rowImage is String &&
        mediaRow.rowImage!.isNotEmpty &&
        mediaRow.contentType == 116;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            mediaRow.title,
            style: AppTypography.fontSizeValue(18),
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
        SizedBox(
          // People rows requires larger height to accommodate person names
          height:
              MediaRowContentTypes.peopleTypes.contains(mediaRow.contentType)
                  ? mediaRow.displayConfig.height + 32
                  : mediaRow.displayConfig.height * 1.1 + 32,
          child: ListView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.only(left: 16.0),
            itemBuilder: (context, index) {
              final MediaItem mediaItem;
              if (isChannelLogoAvailable) {
                if (index == 0) {
                  double height = mediaRow.displayConfig.height;
                  double width = mediaRow.displayConfig.width;
                  return ChannelLogo(
                      logo: mediaRow.rowImage!, height: height, width: width);
                }
                mediaItem = mediaRow.mediaItems[index - 1];
              } else {
                mediaItem = mediaRow.mediaItems[index];
              }

              return MediaItemView(mediaItem, mediaRow, addRows, index,);
            },
            itemCount: isChannelLogoAvailable
                ? mediaRow.mediaItems.length + 1
                : mediaRow.mediaItems.length,
            scrollDirection: Axis.horizontal,
          ),
        ),
      ],
    );
  }
}

class ChannelLogo extends StatelessWidget {
  final String logo;
  final double height;
  final double width;
  const ChannelLogo({
    super.key,
    required this.logo,
    required this.height,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: SizedBox(
        height: height / 3,
        width: width / 3,
        child: Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: CachedNetworkImage(
              placeholder: (context, url) => Container(
                height: height,
                width: width,
                color: Theme.of(context).colorScheme.primaryContainer,
              ),
              errorWidget: (_, __, ___) => Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.errorContainer,
                ),
              ),
              imageUrl: logo,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
