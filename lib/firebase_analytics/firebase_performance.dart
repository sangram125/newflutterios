import 'package:flutter/material.dart';
import 'package:firebase_performance/firebase_performance.dart';
class PerformanceTrackedWidget extends StatefulWidget {
  final String widgetName;
  final Widget child;
  const PerformanceTrackedWidget({Key? key, required this.widgetName, required this.child})
      : super(key: key);
  @override
  _PerformanceTrackedWidgetState createState() => _PerformanceTrackedWidgetState();
}
class _PerformanceTrackedWidgetState extends State<PerformanceTrackedWidget> {
  late Trace _trace;
  @override
  void initState() {
    super.initState();
    _trace = FirebasePerformance.instance.newTrace(widget.widgetName);
    _trace.start();
  }
  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
  @override
  void dispose() {
    _trace.stop();
    super.dispose();
  }
}