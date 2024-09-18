import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../../../../data/models/get_ticket_item_model.dart';

class DropdownListPage extends StatelessWidget {
  final List<Name> categories;
  final String? selectedCategory;
  final String? categoryName;
  final ValueChanged<String?> onCategoryChanged;

  const DropdownListPage({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategoryChanged,required this.categoryName,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selectedCategory,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: Color(0x66A8C7FA), width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: Color(0x66A8C7FA), width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: Color(0x66A8C7FA), width: 1.5),
        ),
        filled: true,
        fillColor: Colors.transparent,
      ),
      icon: const Icon(Icons.keyboard_arrow_down_sharp, size: 24, color: Colors.white),
      dropdownColor: const Color(0xFF0E1466),
      items: categories.map((Name category) {
        return DropdownMenuItem<String>(

          value: category.name,
          child:Text(
            category.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.white,),
          ),
        );
      }).toList(),
      onChanged: onCategoryChanged,
      isExpanded: true,
      validator: (value) => value == null ? 'Please select a category' : null,
      hint: Text(
        categoryName!,overflow: TextOverflow.visible,

        style: const TextStyle(color: Colors.white),
      ),
      style: const TextStyle(color: Colors.white,overflow: TextOverflow.ellipsis),
    );
  }
}
