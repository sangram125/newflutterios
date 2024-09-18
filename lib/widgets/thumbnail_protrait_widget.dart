import 'package:dor_companion/assets.dart';
import 'package:dor_companion/data/constants/color.dart';
import 'package:dor_companion/data/models/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class ThumbnailProtraitWidget extends StatelessWidget {
  bool isTopPresent;
  bool isIconPresent;
  String? imageUrl = "";
  String logoUrl;
  ThumbnailProtraitWidget({super.key, this.isTopPresent = true, this.imageUrl, this.isIconPresent = true,this.logoUrl =''});

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        clipBehavior: Clip.none, // Allow elements to overflow
        children: [
          // Positioned(
          //     left: -100, // Start from the left side
          //     top: 0, // Align to the top
          //     bottom: 10,
          //     child:SvgPicture.asset(Assets.eplips)
          // ),
          ClipRRect(
            borderRadius: const BorderRadius.all(
               Radius.circular(24),
            ),
            child: Image.network(
              imageUrl ?? "",
              fit: BoxFit.fill,
            ),
          ),

            Positioned(
            top: -20, // Position at the top of the Stack
            left: -40, // Center horizontally
            right: 0, // Center horizontally
            child: Align(
              alignment: Alignment.topLeft,
              child: isTopPresent ? Text("10",
                    style: GoogleFonts.dmSerifDisplay(fontSize: 60)
                  ):Text(""),
            ),
          ) ,
          Positioned(
            bottom: -13, // Align to the bottom of the Stack
            left: 0, // Align to the left of the Stack
            right: 0, // Align to the right of the Stack
            child: Align(
              alignment: Alignment.bottomCenter, // Center horizontally
              child: isIconPresent ? StreamingTonWidget(isMorePresent: false,imageUrl: logoUrl,) :Text(""),
            ),
          ),
        ],
      ),
    );
  }
}

class StreamingTonWidget extends StatelessWidget {
  bool? isMorePresent ;
  String? imageUrl = "";
  StreamingTonWidget({super.key, this.isMorePresent= true, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.black,
        borderRadius: BorderRadius.all( Radius.circular(2),
        ),),
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
                borderRadius: const BorderRadius.all(
                  Radius.circular(2),
                ),
                child: imageUrl != null ?Image.network(imageUrl ?? '', fit: BoxFit.cover,width: 20,height: 20,):SizedBox.shrink()),
            isMorePresent ?? false ?  Text(" +3 More", style: AppTypography.bodyLabel(10,AppColors.whiteColor400),) :const Text("")
          ],
        ),
      ),
    );
  }
}
