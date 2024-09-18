import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../data/models/constants.dart';
import '../../../data/models/models.dart';
import '../../../data/models/user_interests.dart';
import '../../../sdk_action_manager.dart';

class MediaActionView extends StatefulWidget {
  const MediaActionView({Key? key, required this.mediaAction})
      : super(key: key);

  final MediaAction mediaAction;

  @override
  State<MediaActionView> createState() => _MediaActionViewState();
}

class _MediaActionViewState extends State<MediaActionView> {
  static const actionHeight = 60.0;
  bool isLoading = false;
  bool ishovering = false;

  @override
  Widget build(BuildContext context) {
    final actionType = widget.mediaAction.chatAction.actionType;

    if (ActionTypes.iconTypes.contains(actionType)) {
      return _getIconButton();
    } else if (ActionTypes.watchOnActionTypes.contains(actionType)) {
      return _getWatchOnButton();
    }

    return _getVanillaButton();
  }

  Widget _getIconButton() {
    return Container(
      margin: EdgeInsets.only(right: MediaQuery.of(context).size.width / 40),
      child: InkWell(
        onTap: () => executeAction(context),
        overlayColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.hovered)) {
              return Colors.white.withOpacity(0.2);
            }
            return Colors.transparent;
          },
        ),
        child: SizedBox(
          height: actionHeight,
          width: actionHeight,
          child: _getIconButtonContents(),
        ),
      ),
    );
  }

  Widget _getIconButtonContents() {
    return Consumer<UserInterestsChangeNotifier>(
      builder: (_, interests, __) => SvgPicture.asset(
        "assets/icons/${_getIconButtonAsset(interests)}",
        width: actionHeight,
        height: actionHeight,
      ),
    );
  }

  String _getIconButtonAsset(UserInterestsChangeNotifier interests) {
    String asset;
    List<String> typeAndID =
        ChatAction.getItemTypeAndItemID(widget.mediaAction.chatAction);
    String itemType = typeAndID[0];
    String itemID = typeAndID[1];
    switch (widget.mediaAction.chatAction.actionType) {
      case ActionTypes.callServer:
        asset = "icon_report.svg";
        break;
      case ActionTypes.setMediaItemNotInterested:
        asset = interests.isInNotInterestedList(itemType, itemID)
            ? "icon_disliked.svg"
            : "icon_dislike.svg";
        break;
      case ActionTypes.setMediaItemSeen:
        asset = interests.isSeen(itemType, itemID)
            ? "icon_seen.svg"
            : "icon_not_seen.svg";
        break;
      case ActionTypes.setMediaItemWatchlist:
        asset = interests.isInWatchlist(itemType, itemID)
            ? "icon_bookmarked.svg"
            : "icon_bookmark.svg";
        break;
      case ActionTypes.setMediaItemFavorite:
      default:
        asset = interests.isFavorite(itemType, itemID)
            ? "icon_favorite.svg"
            : "icon_not_favorite.svg";
        break;
    }
    return asset;
  }

  Widget _getWatchOnButton() {
    return Container(
      margin: EdgeInsets.only(right: MediaQuery.of(context).size.width / 40),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: const StadiumBorder(),
          fixedSize: const Size(180, 60),
          backgroundColor: Theme.of(context).colorScheme.secondary,
          textStyle: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
        ),
        onPressed: () => executeAction(context),
        child: _getWatchOnButtonContent(),
      ),
    );
  }

  _getWatchOnButtonContent() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(Constants.watchOnActionLabelPrefix),
        const SizedBox(
          width: 14,
        ),
        CachedNetworkImage(
          placeholder: (context, url) => Container(
            color: Theme.of(context).highlightColor,
          ),
          imageUrl: widget.mediaAction.icon,
          fit: BoxFit.contain,
          height: 36,
          width: 36,
        )
      ],
    );
  }

  Widget _getVanillaButton() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      child: OutlinedButton(
        onHover: (hover) {
          setState(() {
            ishovering = hover;
          });
        },
        onPressed: () => executeAction(context),
        style: OutlinedButton.styleFrom(
          shape: const StadiumBorder(),
          side: const BorderSide(
            width: 1.0,
            color: Colors.white,
          ),
          fixedSize: const Size(140, 60),
          backgroundColor:
              ishovering ? Colors.white.withOpacity(0.6) : Colors.transparent,
        ),
        child: Center(
            child: Text(
          widget.mediaAction.title,
          style: TextStyle(
            fontSize: 18,
            color: ishovering ? Colors.black : Colors.white,
          ),
          maxLines: 2,
        )),
      ),
    );
  }

  executeAction(BuildContext context) async {
    await widget.mediaAction.chatAction.executeAction(context);
  }
}
