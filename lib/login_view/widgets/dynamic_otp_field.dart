import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FlutterDynamicOTP extends StatefulWidget {
  final int digitsLength;
  final InputDecoration? digitDecoration;
  final TextInputType textInputType;
  final TextStyle? textStyle;
  final double digitWidth;
  final double digitHeight;
  final double digitsPadding;
  final Function(String) onChanged;
  final Function(String)? onSubmit;
  final TextEditingController? controller;

  const FlutterDynamicOTP({
    super.key,
    required this.digitsLength,
    this.digitDecoration,
    required this.textInputType,
    this.textStyle,
    required this.digitWidth,
    required this.digitHeight,
    required this.digitsPadding,
    required this.onChanged,
    this.onSubmit,
    this.controller,
  });

  @override
  State<FlutterDynamicOTP> createState() => _FlutterDynamicOTPState();
}

class _FlutterDynamicOTPState extends State<FlutterDynamicOTP> {
  late List<FocusNode> _nodes;
  late List<TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    _nodes = List.generate(widget.digitsLength, (_) => FocusNode());
    _controllers = List.generate(widget.digitsLength, (_) => TextEditingController());

    if (widget.controller != null) {
      final initialValue = widget.controller!.text;
      for (int i = 0; i < initialValue.length && i < widget.digitsLength; i++) {
        _controllers[i].text = initialValue[i];
      }

      widget.controller!.addListener(() {
        final text = widget.controller!.text;
        setState(() {
          for (int i = 0; i < text.length && i < _controllers.length; i++) {
            _controllers[i].text = text[i];
          }
        });
      });
    }
  }

  @override
  void dispose() {
    disposeControllersAndNodes();
    super.dispose();
  }

  void disposeControllersAndNodes() {
    for (int i = 0; i < _controllers.length; i++) {
      _controllers[i].dispose();
      _nodes[i].dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(widget.digitsLength, (index) {
              return SizedBox(
                width: widget.digitWidth,
                height: widget.digitHeight,
                child: TextField(
                  maxLines: 1,
                  textInputAction: (index < widget.digitsLength - 1)
                      ? TextInputAction.next
                      : TextInputAction.done,
                  keyboardType: widget.textInputType,
                  focusNode: _nodes[index],
                  controller: _controllers[index],
                  textAlign: TextAlign.center,
                  style: widget.textStyle ?? const TextStyle(),
                  decoration: widget.digitDecoration ??
                      InputDecoration(
                        counter: const Offstage(),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(width: 2, color: Colors.blueAccent),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(width: 2, color: Colors.deepOrange),
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                  onChanged: (value) {
                    widget.onChanged(getDigitsValue());
                    if (index < widget.digitsLength - 1 && value.isNotEmpty) {
                      _nodes[index].nextFocus();
                    } else if (index == widget.digitsLength - 1 && !isNotComplete()) {
                      _nodes[index].unfocus();
                    }
                  },
                  onSubmitted: (value) {
                    if (widget.onSubmit != null && value.length == _controllers.length) {
                      widget.onSubmit!(getDigitsValue());
                    }
                  },
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  String getDigitsValue() {
    String value = '';
    for (int i = 0; i < _controllers.length; i++) {
      value += _controllers[i].text;
    }
    return value;
  }

  bool isNotComplete() {
    for (int i = 0; i < _controllers.length; i++) {
      if (_controllers[i].text.isEmpty) {
        return true;
      }
    }
    return false;
  }
}