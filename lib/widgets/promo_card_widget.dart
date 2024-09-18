import 'package:dor_companion/assets.dart';
import 'package:dor_companion/data/constants/color.dart';
import 'package:dor_companion/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
class PromoCardWidget extends StatelessWidget {
  bool? isPlayButton = false;
  String? imageUrl = "";
  PromoCardWidget({super.key, this.isPlayButton,
    this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.black,
        borderRadius: BorderRadius.all( Radius.circular(24),

      ),),
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Column(
          children: [
            ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                child: Image.network("https://via.placeholder.com/300x390",fit: BoxFit.fill,)),
            Row(
            mainAxisSize: MainAxisSize.min,
              children: [
                ImgButton(text: 'Play', onPressed: () {  },leftImage: Assets.assets_icons_play_icon_2_svg,),
                //TextButton(onPressed: (){}, child: IconButton(icon: const Icon(Icons.add),onPressed: (){},)),
              ],
            )
          ],
        ),
      ),
    );
  }
}