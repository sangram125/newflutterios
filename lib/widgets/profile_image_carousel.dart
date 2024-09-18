import 'package:carousel_slider/carousel_slider.dart';
import 'package:dor_companion/widgets/profile_gradient_border.dart';
import 'package:flutter/cupertino.dart';

class ProfileImageCarousel extends StatefulWidget {
  final List<String> imagePath;

  const ProfileImageCarousel({
    Key? key,
    required this.imagePath,
  }) : super(key: key);

  @override
  _ProfileImageCarouselState createState() => _ProfileImageCarouselState();
}

class _ProfileImageCarouselState extends State<ProfileImageCarousel> {
  int _activeIndex = 0; // Move _activeIndex outside build method

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double activeSize = screenWidth * 0.4;
    return CarouselSlider.builder(
      itemCount: widget.imagePath.length,
      itemBuilder: (context, index, realIndex) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 5.0),
          child: index == _activeIndex
              ? GradientBorderProfile(
            child: Image.network(
              widget.imagePath[index],
              fit: BoxFit.cover,
            ),
          )
              : Container(
            decoration:
            const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(32))),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(32.0),
              child: Image.network(
                widget.imagePath[index],
                fit: BoxFit.cover,
                width: 120,
                height: 120,
              ),
            ),
          ),
        );
      },
      options: CarouselOptions(
        enableInfiniteScroll: false,
        padEnds: true,
        enlargeStrategy: CenterPageEnlargeStrategy.zoom,
        height: activeSize,
        viewportFraction: 0.35, // Ensure three items are visible
        enlargeCenterPage: true,
        onPageChanged: (index, reason) {
          // Update _activeIndex when page changes
          setState(() {
            _activeIndex = index;
          });
        },
      ),
    );
  }
}
