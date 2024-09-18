import 'package:cached_network_image/cached_network_image.dart';
import 'package:dor_companion/sdk_action_manager.dart';
import 'package:flutter/material.dart';
import '../../../data/models/models.dart';

class DetailView extends StatelessWidget {
  final List<MediaItem> items;
  bool isIconPresent;

  DetailView({Key? key, required this.items, this.isIconPresent = false}) : super(key: key);
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

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final watchOnAction = getFirstWatchOnActionOrNull(items.elementAt(index).actions);
        final item = items[index];
        return Padding(
          padding: const EdgeInsets.only(right: 20),
          child: GestureDetector(
            onTap: () => item.actions[0].chatAction.executeAction(context, mediaItem: item),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 198,
                  height: 132,
                  clipBehavior: Clip.antiAlias,
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 1, color: Color(0xFF1F1F1F)),
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: CachedNetworkImage(
                      imageUrl: item.image,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                if (isIconPresent)
                  Positioned(
                    bottom: 25,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: Colors.black,
                          ),
                          padding: const EdgeInsets.all(2.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: Image.network(
                              watchOnAction!.icon ?? '',
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}