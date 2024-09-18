import 'package:dor_companion/data/models/constants.dart';
import 'package:flutter/material.dart';

class MediaItemGroups extends StatefulWidget {
  const MediaItemGroups({Key? key}) : super(key: key);

  @override
  State<MediaItemGroups> createState() => _MediaItemGroupsState();
}

class _MediaItemGroupsState extends State<MediaItemGroups> {
  @override
  Widget build(BuildContext context) {
    return const Text("Media Item Groups", style: AppTypography.undefinedTextStyle,);
  }
}
