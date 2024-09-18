import 'package:dor_companion/data/models/models.dart';
import 'package:flutter/material.dart';

class LanguageItemView extends StatefulWidget {
  final String languageName;
  final bool isExpandMode;
    final Function(BuildContext context) onTap;
  final MediaItem? mediaItem;

  const LanguageItemView(this.languageName, this.isExpandMode, this.onTap,
      {required this.mediaItem, super.key});

  @override
  State<LanguageItemView> createState() => _LanguageItemViewState();
}

class _LanguageItemViewState extends State<LanguageItemView> {


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:(){ widget.onTap(context);},
      child: Container(
        margin: const EdgeInsets.only(top: 8.0, right: 8.0, bottom: 8.0),
        padding: EdgeInsets.only(
            right: 8.0,
            left: 8.0,
            top: widget.isExpandMode ? 4.0 : 0.0,
            bottom: widget.isExpandMode ? 4.0 : 0.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withOpacity(0.5),
              width: 1,
            ),
            color:
            widget.isExpandMode ? const Color(0xFF3158CE) : Colors.transparent),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(widget.languageName,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                )),
            if (!widget.isExpandMode)
              const Icon(
                Icons.trending_up,
                color: Colors.white,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
}