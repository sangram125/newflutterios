import 'package:dor_companion/onboarding_view/model/onboarding_model.dart';
import 'package:flutter/material.dart';

class OnBoardContent extends StatelessWidget {
  final OnboardingModel onboardingModel;
  final VoidCallback onTap;

  const OnBoardContent({
    super.key,
    required this.onboardingModel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          //flex: 4,
          child: Stack(
            alignment: AlignmentDirectional.bottomCenter,
            children: [
              Image.asset(
                onboardingModel.backgroundImagePath,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
              ),
              onboardingModel.isSkipButtonRequred
                  ? Container(
                alignment: Alignment.topRight,
                child: InkWell(
                  onTap: onTap,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20, right: 20),
                    child: Text(
                      "skip",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontFamily: "OpenSans",
                          decoration: TextDecoration.underline),
                    ),
                  ),
                ),
              )
                  : Container(),
              Image.asset(
                height: 80,
                onboardingModel.blurImagePath,
              ),
            ],
          ),
        ),
        _buildOnBoardingQuotation(
          context: context,
          largeFontTitle: onboardingModel.largeFontTitle,
          smallFontTitle: onboardingModel.smallFontTitle,
        ),
      ],
    );
  }

  Expanded _buildOnBoardingQuotation({
    required BuildContext context,
    required String largeFontTitle,
    required String smallFontTitle,
  }) {
    return Expanded(
      //flex: 3,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            largeFontTitle,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
              fontSize: 32,
              fontWeight: FontWeight.w700,
              fontFamily: "OpenSans",
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            smallFontTitle,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w400,
              fontFamily: "OpenSans",
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

