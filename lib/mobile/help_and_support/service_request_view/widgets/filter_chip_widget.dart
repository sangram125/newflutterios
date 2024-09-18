import 'package:flutter/material.dart';

class FilterChipWidget extends StatelessWidget {
  final int index;
  final String label;
  final bool isSelected;
  final ValueChanged<int> onSelected;

  FilterChipWidget(
      {required this.index,
      required this.label,
      required this.isSelected,
      required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onSelected(index);
      },
      child: Container(
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFC7C7C7)
              : Colors.white.withOpacity(.10),
          borderRadius: const BorderRadius.all(Radius.circular(24)),
          border: Border.all(
            width: 1,
            color: isSelected
                ? const Color(0xFFC7C7C7)
                : Colors.white.withOpacity(.20),
          ),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(24)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
            child: Text(
              label,
              style: TextStyle(
                  color: isSelected
                      ? const Color(0xFF1E1E1E)
                      : const Color(0xFFC7C7C7),
                  fontFamily: 'Roboto'),
            ),
          ),
        ),
      ),
    );
  }
}
