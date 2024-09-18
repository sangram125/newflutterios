import 'package:flutter/material.dart';

class RaiseTicketButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  bool? isReviewed;
  bool? isSameIssuePresent;

   RaiseTicketButton({
    Key? key,
    required this.onPressed,
    this.text = 'Raise ticket',
    this.isReviewed=false,this.isSameIssuePresent=false
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: (isReviewed! && isSameIssuePresent!)?null:onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric( vertical: 12),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class ButtonWithBorder extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  const ButtonWithBorder({
    Key? key,
    required this.onPressed,
    this.text = 'Close ticket',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.grey),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child:Text(
         text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Color(0xFF8F8F8F),
            fontSize: 14,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w500,
            letterSpacing: 0.10,
          ),
        ),
      ),
    );
  }
}
