import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NavBarItem extends StatelessWidget {
  final int index;
  final String title;
  final bool isSelected;
  final String selectedImage;
  final String unSelectedImage;
  final Function(int) onTap;

  const NavBarItem({
    super.key,
    required this.isSelected,
    required this.title,
    required this.selectedImage,
    required this.unSelectedImage,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: () => onTap(index),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              isSelected ? selectedImage : unSelectedImage,
              width: 26,
              height: 26,
              colorFilter: ColorFilter.mode(
                Theme.of(context).colorScheme.onPrimary,
                BlendMode.dstIn,
              ),
            ),
            Text(
              title,
              style: isSelected
                  ? TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                fontFamily: "Raleway",
                color: Theme.of(context).colorScheme.onPrimary,
              )
                  : TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                fontFamily: "Raleway",
                color: Theme.of(context)
                    .colorScheme
                    .onPrimary
                    .withOpacity(0.20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
