import 'package:flutter/material.dart';
import '../../../../data/models/constants.dart';
class LanguageItemView extends StatelessWidget {
  final int languageId;
  final String languageName;
  final String languageSymbol;
  final bool isFavorite;
  const LanguageItemView(
      this.languageId, this.languageName, this.languageSymbol, this.isFavorite,
      {super.key});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 106,
      height: 106,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Stack(
          children: [
            Center(
              child: Text(
                languageSymbol,
                style: AppTypography.settingViewLangSymbol,
              ),
            ),
            Positioned.fill(
              bottom: 16,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  languageName,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSecondary,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            Positioned.fill(
              top: 8,
              right: 8,
              child: Align(
                alignment: Alignment.topRight,
                child: isFavorite
                    ? const Icon(
                  Icons.favorite,
                  color: Colors.red,
                  size: 28,
                )
                    : Icon(
                  Icons.favorite_border,
                  color: Theme.of(context).colorScheme.onSecondary,
                  size: 28,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}