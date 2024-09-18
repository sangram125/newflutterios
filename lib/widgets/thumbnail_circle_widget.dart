import 'package:dor_companion/data/constants/color.dart';
import 'package:dor_companion/data/models/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ThumbnailCircleWidget extends StatelessWidget {
  bool isSubTextPresent ;
  bool isTitlePresent ;
  String? imageUrl = "";
  ThumbnailCircleWidget({super.key, this.isSubTextPresent= false,this.isTitlePresent= false, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipOval(
          child: Image.network(
            "https://via.placeholder.com/132x132",
            fit: BoxFit.fill,
          ),
        ),
        SizedBox(height: 5,),
        isTitlePresent  ? Text("text",style: AppTypography.headingMed(8,AppColors.whiteColor300)): Text(""),
        SizedBox(height: 2,),
        isSubTextPresent ? Text("subtext",style: AppTypography.headingMed(10,AppColors.whiteColor300)): Text(""),
      ],
    );
  }
}

class StreamingTonWidget extends StatelessWidget {
  bool? isMorePresent = false;
  String? imageUrl = "";
  StreamingTonWidget({super.key, this.isMorePresent, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.all( Radius.circular(2),
        ),),
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Row(
          children: [
            ClipRRect(
                borderRadius: const BorderRadius.all(
                  Radius.circular(2),
                ),
                child: Image.network("https://via.placeholder.com/16x16",fit: BoxFit.cover,)),
            isMorePresent ?? false ? Text("+3 More") :Text("")
          ],
        ),
      ),
    );
  }
}
