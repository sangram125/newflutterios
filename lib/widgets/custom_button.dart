import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final double height;
  final VoidCallback onPressed;

  const CustomButton({Key? key,
    required this.text,
    this.height = 54.0,
    required this.onPressed,});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        height: height,
        width: 200,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(100),
          border: Border.all(
            color: Colors.white, // Border color
            width: 1, // Border width
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontFamily: 'DMSans',
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class DeactivatedBtn extends StatelessWidget {
  final String text;
  final double height;
  final VoidCallback onPressed;
  const DeactivatedBtn({super.key,
    required this.text,
    this.height = 54.0,
    required this.onPressed
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        height: height,
        width: 118,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: const Color(0xff333333),
            borderRadius: BorderRadius.circular(100)
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontFamily: 'DMSans',
            fontSize: 16,
            color: Color(0xff666666),
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class OutlineButton extends StatelessWidget {
  final String text;
  final double height;
  final VoidCallback onPressed;

  const OutlineButton({super.key,
    required this.text,
    this.height = 54.0,
    required this.onPressed
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        height: height,
        width: 118,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
          border: Border.all(
              color: const Color(0xffE5E5E5),
            width: 1
          )
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontFamily: 'DMSans',
            fontSize: 16,
            color: Color(0xffE5E5E5),
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class ImgButton extends StatelessWidget {
  final String text;
  final double height;
  final VoidCallback onPressed;
  final String? leftImage;
  final String? rightImage;
  final double ? width;

  const ImgButton({Key? key,
    required this.text,
    this.height = 54.0,
    required this.onPressed,
    this.leftImage,
    this.rightImage,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: IntrinsicWidth(
        child: Container(
          height: height,
          width: width,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(100)
          ),
          child: Row(
            children: [
              if (leftImage != null) ...[
                SvgPicture.asset(
                  leftImage!,
                  height: 24,
                  width: 24,
                ),
                const SizedBox(width: 8),
              ],
              Text(
                text,
                style: const TextStyle(
                  fontFamily: 'DMSans',
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (rightImage != null) ...[
                const SizedBox(width: 8),
                SvgPicture.asset(
                  rightImage.toString(),
                  height: 24,
                  width: 24,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class BorderBtnIcon extends StatelessWidget {
  final String text;
  final double height;
  final double ? width;
  final VoidCallback onPressed;
  final String? leftImage;
  final String? rightImage;

  const BorderBtnIcon({
    Key? key,
    required this.text,
    this.height = 54.0,
    this.width,
    required this.onPressed,
    this.leftImage,
    this.rightImage,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: IntrinsicWidth(
        child: Container(
          height: height,
          width: width,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            border: Border.all(
              color: const Color(0xffE5E5E5),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (leftImage != null) ...[
                SvgPicture.asset(
                  leftImage!,
                  height: 24,
                  width: 24,
                ),
                const SizedBox(width: 8),
              ],
              Text(
                text,
                style: const TextStyle(
                  fontFamily: 'DMSans',
                  fontSize: 16,
                  color: Color(0xffE5E5E5),
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (rightImage != null) ...[
                const SizedBox(width: 8),
                SvgPicture.asset(
                  rightImage!,
                  height: 24,
                  width: 24,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class SmallButton extends StatelessWidget {
  final String text;
  const SmallButton({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      width: 87,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(100)
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: 'DMSans',
          fontSize: 14,
          color: Colors.black,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class SDeactivatedBtn extends StatelessWidget {
  final String text;
  const SDeactivatedBtn({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      width: 87,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: const Color(0xff333333),
          borderRadius: BorderRadius.circular(100)
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: 'DMSans',
          fontSize: 14,
          color: Color(0xff666666),
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class SOutlineButton extends StatelessWidget {
  final String text;
  const SOutlineButton({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      width: 87,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          border: Border.all(
              color: const Color(0xffE5E5E5),
              width: 1
          )
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: 'DMSans',
          fontSize: 16,
          color: Color(0xffE5E5E5),
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}