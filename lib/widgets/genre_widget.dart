import 'package:dor_companion/data/constants/color.dart';
import 'package:dor_companion/data/models/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
class GenreCardsWidget extends StatefulWidget {
  bool? isPlayButton = false;
  String? imageUrl = "";
  GenreCardsWidget({super.key, this.isPlayButton,
    this.imageUrl});

  @override
  State<GenreCardsWidget> createState() => _GenreCardsWidgetState();
}

class _GenreCardsWidgetState extends State<GenreCardsWidget> {
  List<Map<String, dynamic>> map = [
    {
      "name": "Genre1",
      "isSelected": false,
    },
    {
      "name": "Genre2",
      "isSelected": true,
    },
    {
      "name": "Genre3",
      "isSelected": false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, crossAxisSpacing: 20, mainAxisSpacing: 20, childAspectRatio: 2.2),
          itemCount:map.length,
          itemBuilder: (context, index) {
            //String key = map.keys.elementAt(index);
            // isChecked = map[key] ?? false;
            return GestureDetector(
                onTap: () {
                  map[index]["isSelected"] = !map[index]["isSelected"];
                  setState((){});
                },
                child: Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: map.elementAt(index)["isSelected"] == false
                        ? ShapeDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              const Color(0x235E5E5E).withOpacity(0.07),
                              const Color(0x235E5E5E).withOpacity(0.07),
                              const Color(0x005E5E5E).withOpacity(0.14)
                            ]),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              // Add border side
                                color: map[index]["isSelected"] == true ? Colors.white : Colors.transparent,
                                // Set border color
                                width: 1)))
                        : BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                    child: Stack(children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Text(map[index]["name"],style: AppTypography.headingBold(10,AppColors.whiteColor),),),
                      ),
                      Align(
                          alignment: Alignment.topRight,
                          child: Checkbox(
                              checkColor: AppColors.black,
                              activeColor: AppColors.successColor300,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              value: map[index]["isSelected"],
                              onChanged: (value) {
                                map[index]["isSelected"] = !(map[index]["isSelected"] ?? true);
                              }))
                    ])));
          })
    ]);
  }
}