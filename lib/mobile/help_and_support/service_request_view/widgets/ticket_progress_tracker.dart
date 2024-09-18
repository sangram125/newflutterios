import 'package:flutter/material.dart';

class ProgressTracker extends StatelessWidget {
  final List<Map<String, dynamic>> steps = [
    {'label': 'Request registered'},
    {'label': 'ETA updated'},
    {'label': 'Work in progress'},
    {'label': 'Issue resolved'},
  ];

  ProgressTracker({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        ...steps.asMap().entries.map((entry) {
          int idx = entry.key;
          Map<String, dynamic> step = entry.value;
          Color iconColor = idx < 2 ? const Color(0xFF0CB030):
           Colors.green[900]!;
          return StepWidget(
            isComplete: step['isComplete'] ?? false,
            label: step['label'],
            showLine: idx != steps.length - 1,
            iconColor: iconColor,
          );
        }).toList(),
      ],
    );
  }
}

class StepWidget extends StatelessWidget {
  final bool isComplete;
  final String label;
  final bool showLine;
  final Color iconColor;

  const StepWidget(
      {super.key,
        required this.isComplete,
        required this.label,
        required this.showLine,
        required this.iconColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Icon(
              Icons.check_circle,
              color: iconColor,
              size: 14,
            ),
            if (showLine)
              Container(
                width: 2,
                height: 10,
                color: Colors.grey,
              ),
          ],
        ),
        const SizedBox(width: 21),
        Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: Color(0xFFABABAB),
                fontSize: 8,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w400,
              ),
            )),
      ],
    );
  }
}
