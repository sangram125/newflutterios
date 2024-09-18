import 'package:dor_companion/data/models/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BrowseAllListItem extends StatelessWidget {
  final String text;
  final String image;
  final String backgroundImage;
  final String title;

  const BrowseAllListItem(this.text, this.image, this.backgroundImage, {Key? key, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Card(
            child: Stack(
              children: [
                // The image should fill the entire space and be rounded
                ClipRRect(
                  borderRadius: BorderRadius.circular(16.0), // Adjust border radius as needed
                  child: Image.network(
                    image, // Replace with your image URL
                    fit: BoxFit.cover,
                  ),
                ),
                // Black overlay to darken the image
                Positioned.fill(
                  child: Container(
                    color: Colors.black.withOpacity(0.1), // Adjust the opacity as needed
                  ),
                ),
                // Text in the bottom left corner
                Positioned(
                  left: 16, // Adjust left position as needed
                  bottom: 16, // Adjust bottom position as needed
                  child: Text(
                    title,
                    style: AppTypography.loginText.copyWith(color: Colors.white,fontWeight: FontWeight.bold,),
                    textAlign: TextAlign.left, // Align text to the left
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}