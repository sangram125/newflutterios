import 'package:dor_companion/data/constants/color.dart';
import 'package:dor_companion/data/models/constants.dart';
import 'package:dor_companion/widgets/thumbnail_protrait_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
class ThumbnailLandscapeWidget extends StatelessWidget {
  bool isSourcePresent ;
  String? imageUrl = "";
  ThumbnailLandscapeWidget({super.key, this.isSourcePresent= false,
    this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
      isSourcePresent  ? Row(
        mainAxisSize: MainAxisSize.min,
        children: [
           Text("VIA",style: AppTypography.headingMed(10,AppColors.whiteColor),),
          StreamingTonWidget(),
           Text("SOURCE NAME",style: AppTypography.headingMed(10,AppColors.whiteColor),),
        ],
      ): const SizedBox.shrink(),
      Container(
        decoration: const BoxDecoration(

          borderRadius: BorderRadius.all( Radius.circular(24),

          ),),
        child: Padding(
          padding: const EdgeInsets.all(3.0),
          child: Column(
            children: [
              ClipRRect(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(24),
                  ),
                  child: Image.network("https://via.placeholder.com/286x159",fit: BoxFit.fill,)),
               FractionallySizedBox(
                widthFactor: 0.7,
                child: Text(
                  "This will be a short title of the n This will be a short title of the n",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.bodyLabel(13,AppColors.whiteColor100),
                ),
              ),
            ],
          ),
        ),
      ),
    ]);
  }
}