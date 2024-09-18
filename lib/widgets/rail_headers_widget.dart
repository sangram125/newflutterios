import 'package:dor_companion/data/constants/color.dart';
import 'package:dor_companion/data/models/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
class RailHeadersWidget extends StatelessWidget {
  String? title;
  String? subTitle;
  bool isPowerByRequired;
  bool isLogoAvailable ;
  bool isSubTitlePresent ;
  String? logoUrl = "";
  String? poweredByUrl = "";
  RailHeadersWidget({super.key, this.title,
    this.subTitle,
    this.isPowerByRequired  = false,
    this.isLogoAvailable= false,
    this.isSubTitlePresent= true,
  this.logoUrl,this.poweredByUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(top: 20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(24),
              child: ListTile(
                leading: isLogoAvailable ? Image.network(logoUrl??"") :SizedBox.shrink() ,
                title: Text(title ??"",maxLines: 2,overflow: TextOverflow.ellipsis,style: AppTypography.bodyLabel(16,AppColors.whiteColor400),),
                subtitle:isSubTitlePresent ?Text(subTitle ?? "subtext",style: AppTypography.bodyLabel(28,AppColors.whiteColor),):null,
                trailing:isPowerByRequired  ? Column(
                  children: [
                    Text("PoweredBy",style: AppTypography.headingMed(8,AppColors.whiteColor400),),
                    Expanded(child: Image.network(poweredByUrl ?? "",)),
                  ],
                ):null,
              ))
        ]));
  }
}