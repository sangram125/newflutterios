import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'Model/Item.dart';

class HorizontalListWrap extends StatefulWidget {
  List<Item> items;

  HorizontalListWrap(this.items, {super.key});

  @override
  State<HorizontalListWrap> createState() => _HorizontalListWrapState();
}

class _HorizontalListWrapState extends State<HorizontalListWrap> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: widget.items.map((item) {
        return GestureDetector(
          onTap: () {
            setState(() {
              item.isSelected = !item.isSelected;
            });
          },
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: item.isSelected ? Colors.blue : const Color(0xFF040523),
              borderRadius: BorderRadius.circular(24.0),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (item.isSelected)
                  SvgPicture.asset(
                    "assets/icons/icon_dor.svg",
                    color: const Color(0xFF040523),
                  ),
                if (item.isSelected) const SizedBox(width: 8.0),
                Text(
                  item.name,
                  style: TextStyle(
                    color: item.isSelected ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
