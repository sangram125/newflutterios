import 'package:flutter/material.dart';
class SwitchButton extends StatefulWidget{
   bool switchValue;
   Function()? onTap;
  SwitchButton({super.key, required this.switchValue, required this.onTap});

  @override
  State<SwitchButton> createState() => _SwitchButtonState();
}

class _SwitchButtonState extends State<SwitchButton> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedContainer(
        padding: const EdgeInsets.all(1),
        duration: const Duration(milliseconds: 200),
        width: 60.0,
        height: 32.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: widget.switchValue ? Colors.green : Colors.grey,
        ),
        child: Stack(
          children: <Widget>[
            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeIn,
              left: widget.switchValue ? 30.0 : 0.0,
              right: widget.switchValue ? 0.0 : 30.0,
              child: Container(
                width: 30.0,
                height: 30.0,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}