

import 'package:flutter/material.dart';

class DoIndicator extends StatelessWidget {
  final bool isActive;
  const DoIndicator({
    super.key,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 8,
      width: isActive ? 20 : 8,
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onPrimary,
          borderRadius: const BorderRadius.all(Radius.circular(12))),
    );
  }
}
