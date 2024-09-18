import 'package:cached_network_image/cached_network_image.dart';
import 'package:dor_companion/data/models/user_interests.dart';
import 'package:dor_companion/sdk_action_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/api/sensy_api.dart';
import '../../../data/models/constants.dart';
import '../../../data/models/models.dart';
import '../../../injection/injection.dart';
import '../../../widgets/loader.dart';
import '../../../widgets/media_detail/media_rows_view.dart';

class MediaItemView extends StatefulWidget {
  const MediaItemView(this.mediaItem, this.mediaRow, this.addRows, {Key? key})
      : super(key: key);
  final MediaItem mediaItem;
  final MediaRow mediaRow;
  final AddRows? addRows;

  @override
  State<MediaItemView> createState() => _MediaItemViewState();
}

class _MediaItemViewState extends State<MediaItemView> {
  bool isLoading = false;
  bool favoritedThisSession = false;
  bool isHovering = false;

  @override
  Widget build(BuildContext context) {
    if (widget.mediaRow.displayConfig.rowType !=
        DisplayConfig.rowTypePersonalize) {
      return getMediaItemWidget(context);
    }

    return Stack(children: [
      getMediaItemWidget(context),
      Positioned.fill(
        top: 8,
        right: 8,
        child: Consumer<UserInterestsChangeNotifier>(
          builder: ((context, interests, _) {
            return Align(
              alignment: Alignment.topRight,
              child: Container(
                margin: EdgeInsets.only(
                    top: widget.mediaRow.displayConfig.height >
                            widget.mediaRow.displayConfig.width
                        ? 25
                        : 16,
                    right: 15),
                child: isLoading
                    ? const Loader()
                    : interests.isFavorite(
                        widget.mediaItem.itemType,
                        ChatAction.getActionFormattedItemId(
                          widget.mediaItem.itemType,
                          widget.mediaItem.itemID,
                        ),
                      )
                        ? const Icon(
                            Icons.favorite,
                            color: Colors.red,
                            size: 28,
                          )
                        : Icon(
                            Icons.favorite_border,
                            color: Theme.of(context).colorScheme.onSecondary,
                            size: 28,
                          ),
              ),
            );
          }),
        ),
      ),
    ]);
  }

  Widget getMediaItemWidget(BuildContext context) {
    final width =
        MediaRowContentTypes.peopleTypes.contains(widget.mediaRow.contentType)
            ? widget.mediaRow.displayConfig.width
            : widget.mediaRow.displayConfig.width * 1.3;
    final height =
        MediaRowContentTypes.peopleTypes.contains(widget.mediaRow.contentType)
            ? widget.mediaRow.displayConfig.height
            : widget.mediaRow.displayConfig.height * 1.3;
    final watchOnAction = getFirstWatchOnActionOrNull(widget.mediaItem.actions);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      margin: const EdgeInsets.only(right: 20),
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: () async {
              if (widget.mediaRow.displayConfig.rowType !=
                  DisplayConfig.rowTypePersonalize) {
                if (widget.mediaItem.actions.isNotEmpty) {
                  widget.mediaItem.actions[0].chatAction.executeAction(
                    context,
                    mediaItem: widget.mediaItem,
                  );
                }
                return;
              }

              if (widget.mediaItem.actions.isEmpty) {
                return;
              }

              setState(() {
                isLoading = true;
              });

              List<String> typeAndID = ChatAction.getItemTypeAndItemID(
                  widget.mediaItem.actions[0].chatAction);
              String itemType = typeAndID[0];
              String itemId = typeAndID[1];
              await widget.mediaItem.actions[0].chatAction
                  .executeAction(context);

              final AddRows? addRows = widget.addRows;
              if (addRows == null ||
                  !getIt<UserInterestsChangeNotifier>()
                      .isFavorite(itemType, itemId) ||
                  favoritedThisSession) {
                setState(() => isLoading = false);
                return;
              }

              addRows(getIt<SensyApi>().fetchSuggestedRows(itemType, itemId),
                      widget.mediaRow)
                  .then((value) {
                    favoritedThisSession = true;
                  })
                  .catchError((_) => null)
                  .whenComplete(() => setState(() => isLoading = false));
            },
            onHover: (value) {
              setState(() {
                isHovering = value;
              });
            },
            child: Center(
                child: SizedBox(
              height: height,
              width: width,
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                child: Container(
                  decoration: isHovering
                      ? BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5.0)),
                          border: Border.all(
                            color: Colors.white,
                            width: 4.0,
                          ),
                        )
                      : null,
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
                    imageUrl: widget.mediaItem.image,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            )),
          ),
          if (MediaRowContentTypes.peopleTypes
                  .contains(widget.mediaRow.contentType) ||
              MediaRowContentTypes.youtube ==
                  widget.mediaRow.contentType) ...<Widget>[
            const SizedBox(
              height: 10,
            ),
            Text(
              widget.mediaItem.title,
              style: const TextStyle(
                fontSize: 16.0,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ] else if (watchOnAction != null &&
              watchOnAction.icon.isNotEmpty) ...<Widget>[
            const SizedBox(
              height: 8,
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: CachedNetworkImage(
                placeholder: (context, url) => Container(
                  color: Theme.of(context).highlightColor,
                ),
                imageUrl: watchOnAction.icon,
                fit: BoxFit.contain,
                height: 30,
                width: 30,
              ),
            )
          ] else
            const SizedBox(
              height: 38,
            )
        ],
      ),
    );
  }

  static MediaAction? getFirstWatchOnActionOrNull(List<MediaAction> actions) {
    if (actions.isEmpty) return null;
    for (MediaAction action in actions) {
      if (ActionTypes.watchOnActionTypes
          .contains(action.chatAction.actionType)) {
        return action;
      }
    }

    return null;
  }
}
