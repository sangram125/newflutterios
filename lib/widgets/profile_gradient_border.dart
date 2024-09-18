import 'package:flutter/material.dart';

class GradientBorderProfile extends StatelessWidget{
  final Widget child;

  const GradientBorderProfile({super.key, required this.child});
  @override
  Widget build(BuildContext context) {
   return Container(
     width: 120,
     height: 120,
     decoration: ShapeDecoration(
       shape: RoundedRectangleBorder(
         borderRadius: BorderRadius.circular(34.00),
       ),
       gradient: const LinearGradient(
         begin: Alignment.topCenter,
         end: Alignment.bottomCenter,
         colors: [
           Colors.white,
           Colors.grey,
           Colors.black,
         ],
       ),
     ),
     child: Padding(
       padding: const EdgeInsets.all(4.0),
       child: Container(
         clipBehavior: Clip.antiAlias,
         padding: const EdgeInsets.all(4),
         // color: Color(0xFF010521),
         decoration: ShapeDecoration(
           color: const Color(0xFF010521),
           shape: RoundedRectangleBorder(
             borderRadius: BorderRadius.circular(32.00),
           ),
         ),
         child: Container(
           // clipBehavior: Clip.antiAlias,
           decoration: ShapeDecoration(
             shape: RoundedRectangleBorder(
               borderRadius: BorderRadius.circular(30.00),
             ),
           ),
           child:ClipRRect(
             borderRadius: const BorderRadius.all(Radius.circular(32)),
               child: child)
         ),
       ),
     ),
   );
  }

}