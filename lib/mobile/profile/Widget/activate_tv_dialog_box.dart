import 'package:dor_companion/data/models/constants.dart';
import 'package:flutter/material.dart';

class ActivateTvWidget extends StatelessWidget {
  const ActivateTvWidget({super.key, });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Container(
              decoration: ShapeDecoration(
                color:  Colors.black87,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32),
                ),
                shadows: const [
                  BoxShadow(
                    color: Color(0x3F000000),
                    blurRadius: 60,
                    offset: Offset(0, 10),
                    spreadRadius: 0,
                  )
                ],),
              padding: EdgeInsets.only(
                left: 30,
                right: 30,
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                children: [
                  Text(
                    'Activate TV',
                    textAlign: TextAlign.center,
                    style: AppTypography.activateTvTitle,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'To sign in, please confirm that the code below matches this TV: 360 Smart TV',
                    textAlign: TextAlign.center,
                    style: AppTypography.activateTvSubTitle,
                  ),
                  const SizedBox(height: 32),
                  Text(
                    '6122-4122',
                    textAlign: TextAlign.center,
                    style: AppTypography.activateTvCode,
                  ),
                  const SizedBox(height: 32),
                  GestureDetector(
                    onTap: (){},
                    child: Container(
                      width: double.infinity,
                      height: 44,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      clipBehavior: Clip.antiAlias,
                      decoration: ShapeDecoration(
                        color: Colors.white.withOpacity(0.9599999785423279),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child:  const Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Sign in to TV',
                            textAlign: TextAlign.center,
                            style: AppTypography.signInOnTvText,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: (){Navigator.pop(context);},
                    child: Container(
                      width: double.infinity,
                      height: 44,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      clipBehavior: Clip.antiAlias,
                      decoration: ShapeDecoration(
                        color: const Color(0x2D5E5E5E),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Cancel',
                            textAlign: TextAlign.center,
                            style: AppTypography.signInOnTvCancelText
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10,),
                  const Text(
                    'If the code doesn’t match, press Cancel and rescan the QR code on your TV.',
                    textAlign: TextAlign.center,
                    style: AppTypography.signInOnTvBottomText,
                  ),
                  const SizedBox(height: 22),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
