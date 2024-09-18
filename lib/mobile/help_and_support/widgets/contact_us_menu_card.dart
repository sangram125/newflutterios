import 'package:dor_companion/data/models/constants.dart';
import 'package:dor_companion/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ContactUsMenuCard extends StatelessWidget {
  final String icon;
  final String title;
  final String description;
  final VoidCallback onTap;
  final bool? isWhatsapp;
  const ContactUsMenuCard(
      {super.key,
        required this.title,
        required this.description,
        required this.icon,
        required this.onTap,
      this.isWhatsapp});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          children: [
            GestureDetector(
              onTap: onTap,
              child: Row(
                children: [
                  SvgPicture.asset(
                    color:const Color(0xFF8F8F8F),
                    icon, // Make sure to add the SVG file in the assets folder
                    width: 32,
                    height: 32,
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        description,
                        style: AppTypography.addNewTextWatlist.copyWith(
                          color: const Color(0xFF8F8F8F),
                          fontSize: 12,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            title,
                            style:AppTypography.remoteTextHomePage.copyWith(
                              color: Colors.white,
                              fontSize: 12,
                            )
                          ),
                          isWhatsapp! ? Loader():SizedBox.shrink()
                        ],
                      ),
                    ],
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: Color(0xFF8F8F8F),
                    size: 18,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DottedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = const Color(0xFF474747)
      ..strokeWidth = 1;

    double dashWidth = 6;
    double dashSpace = 4;
    double startX = 1;

    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
