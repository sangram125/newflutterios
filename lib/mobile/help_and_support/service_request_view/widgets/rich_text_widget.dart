import 'package:flutter/material.dart';

class RichTextWidget extends StatelessWidget{
  final String label;
  final String value;

  const RichTextWidget({super.key, required this.label,required this.value});

  @override
  Widget build(BuildContext context) {
    return  Text.rich(
      maxLines:1,
      overflow:TextOverflow.ellipsis,
      TextSpan(
        children: [
          TextSpan(
            text:'$label : ',
            style: const TextStyle(
              color: Color(0xFFC7C7C7),
              fontSize: 12,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w400,
              height: 0,
              letterSpacing: -0.40,
            ),
          ),
          TextSpan(
            text:value,
            style: const TextStyle(
              color: Color(0xFF8F8F8F),
              fontSize: 12,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w400,
              height: 0,
              letterSpacing: -0.40,
            ),
          ),
        ],
      ),
    );
  }

}