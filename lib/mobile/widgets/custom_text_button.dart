import 'package:dor_companion/data/models/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomTextButton extends StatefulWidget {
  final String text;
  final Widget icon;
  final VoidCallback onPressed;
  final bool showToggleButton;
  final bool showForwardButton;

  const CustomTextButton({
    Key? key,
    required this.text,
    required this.icon,
    required this.onPressed,
    required this.showToggleButton,
    required this.showForwardButton,
  }) : super(key: key);

  @override
  State<CustomTextButton> createState() => _CustomTextButtonState();
}

class _CustomTextButtonState extends State<CustomTextButton> {
  bool isToggled = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(5),
      ),
      margin: const EdgeInsets.only(left: 24, right: 24),
      padding: const EdgeInsets.only(left: 10),
      child: TextButton(
        onPressed: widget.onPressed,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            widget.icon,
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(left: 8),
                child: Text(
                  widget.text,
                  style: AppTypography.customTextButton,
                ),
              ),
            ),
            if (widget.showForwardButton) ...[
              SvgPicture.asset(
                'assets/icons/arrow_right_alt.svg',
                color: Colors.white,
              )
            ],
            if (widget.showToggleButton) ...[
              GestureDetector(
                onTap: () {
                  setState(() {
                    isToggled = !isToggled;
                  });
                },
                child: Icon(
                  isToggled ? Icons.toggle_off_outlined : Icons.toggle_on_sharp,
                  color: Colors.white,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
