import 'package:dor_companion/data/constants/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TvChannelWidget extends StatefulWidget {
  bool? isSubTextPresent = false;
  bool? isTitlePresent = false;
  String? imageUrl = "";
  TvChannelWidget({super.key, this.isSubTextPresent,this.isTitlePresent, this.imageUrl});

  @override
  State<TvChannelWidget> createState() => _TvChannelWidgetState();
}
bool _isSelected = false;
class _TvChannelWidgetState extends State<TvChannelWidget> {
  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: () {
        // setState(() {
        //   _isSelected = !_isSelected;
        // });
      },
      child: Stack(
        alignment: Alignment.center, // Aligns the checkbox in the center
        children: [
          ClipOval(
            child: Image.network(
              "https://via.placeholder.com/16x16",
              width: 132,
              height: 132,
              fit: BoxFit.fill,
            ),
          ),
          Positioned(
            child: Checkbox(
                checkColor: AppColors.black,
                activeColor: AppColors.successColor300,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                value: _isSelected,
                onChanged: (value) {

                  _isSelected = value!;
                  setState(() {

                  });
                 // map[index]["isSelected"] = !(map[index]["isSelected"] ?? true);
                }),
          ),
        ],
      ),
    );
  }
}

