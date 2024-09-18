import 'package:cached_network_image/cached_network_image.dart';
import 'package:dor_companion/data/models/constants.dart';
import 'package:dor_companion/data/models/models.dart';
import 'package:flutter/material.dart';

import '../../widgets/loader.dart';

class MovieDetailView extends StatelessWidget {
  final StandardPromotion standardPromotion;

  const MovieDetailView({super.key, required this.standardPromotion});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(context),
    );
  }

  _buildBody(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          _videoPlayer(context),
          _getDetailView(),
        ],
      ),
    );
  }

  _videoPlayer(BuildContext context) {
    return Stack(
      children: [
        CachedNetworkImage(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.width * 0.625,
          fit: BoxFit.fitWidth,
          placeholder: (context, url) => const Center(child: Loader()),
          imageUrl: standardPromotion.image,
        ),
        /*Positioned(
          top: 10,
          left: 10,
          child: IconButton(
            onPressed: () {
              context.pop();
            },
            icon: SvgPicture.asset(
              "assets/images/home_images/arrow_right_alt.svg",
              width: 32,
              height: 32,
              alignment: Alignment.center,
            ),
          ),
        ),*/
      ],
    );
  }

  _getDetailView() {
    return const Column(
      children: [
        Text(
          "Oppenheimer",
          style: AppTypography.mediaDetailViewErrorMsg,
        ),
      ],
    );
  }
}
