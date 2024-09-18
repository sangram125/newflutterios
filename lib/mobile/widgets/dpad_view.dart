import 'package:dor_companion/data/models/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../remote_buttons_icons.dart';
import '../screens/remote_view.dart';

class DPadView extends StatelessWidget {
  final ButtonUpCallback callback;

  const DPadView({
    super.key,
    required this.callback,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        buildBackground(),
        ...buildArrows(),
        buildOk(),
      ],
    );
  }

  Center buildOk() {
    return Center(
      child: Container(
        width: 64.0,
        height: 64.0,
        decoration: BoxDecoration(
          color: const Color(0xFFFFFFFF).withOpacity(0.2),
          shape: BoxShape.rectangle,
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
            width: 1.0,
            style: BorderStyle.solid,
          ),
          boxShadow: const <BoxShadow>[
            BoxShadow(
              color: Colors.black12,
              spreadRadius: 8.0,
              blurRadius: 8.0,
            )
          ],
          borderRadius: const BorderRadius.all(Radius.circular(20.0)),
        ),
        child: Material(
          type: MaterialType.transparency,
          color: const Color(0xFFFFFFFF).withOpacity(0.2),
          child: InkResponse(
            containedInkWell: false,
            highlightShape: BoxShape.rectangle,
            borderRadius: const BorderRadius.all(Radius.circular(18.0)),
            highlightColor: const Color(0xFF444444),
            splashColor: const Color(0x00FFFFFF),
            child: const Center(
              child: Text(
                'OK',
                style: AppTypography.dpadView,
              ),
            ),
            onTapDown: (details) {
              callback(RemoteButton.ok);
            },
          ),
        ),
      ),
    );
  }

  Container buildBackground() {
    return Container(
      width: 140.0,
      height: 140.0,
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF).withOpacity(0.2),
        shape: BoxShape.rectangle,
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1.0,
          style: BorderStyle.solid,
        ),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Colors.black12,
            spreadRadius: 8.0,
            blurRadius: 8.0,
          )
        ],
        borderRadius: const BorderRadius.all(Radius.circular(40.0)),
      ),
    );
  }

  List<Widget> buildArrows() {
    return [
      Positioned(
        top: 2.0,
        left: 2.0,
        right: 2.0,
        child: ClipRect(
          child: Material(
            type: MaterialType.transparency,
            child: InkResponse(
              containedInkWell: false,
              highlightShape: BoxShape.rectangle,
              highlightColor: const Color(0xFF444444),
              splashColor: const Color(0x00FFFFFF),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(40.0),
                topRight: Radius.circular(40.0),
              ),
              child: const SizedBox(
                height: 40,
                width: 120,
                child: Icon(
                  size: 18.2,
                  RemoteButtons.up_arrow,
                  color: Color(0xEEFFFFFF),
                ),
              ),
              onTapDown: (details) {
                callback(RemoteButton.up);
                HapticFeedback.lightImpact();
              },
            ),
          ),
        ),
      ),
      Positioned(
        bottom: 2.0,
        left: 2.0,
        right: 2.0,
        child: ClipRect(
          child: Material(
            type: MaterialType.transparency,
            child: InkResponse(
              containedInkWell: false,
              highlightShape: BoxShape.rectangle,
              highlightColor: const Color(0xFF444444),
              splashColor: const Color(0x00FFFFFF),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(40.0),
                bottomRight: Radius.circular(40.0),
              ),
              child: const SizedBox(
                height: 40,
                width: 120,
                child: Icon(
                  size: 18.2,
                  RemoteButtons.down_arrow,
                  color: Color(0xEEFFFFFF),
                ),
              ),
              onTapDown: (details) {
                callback(RemoteButton.down);
                HapticFeedback.lightImpact();
              },
            ),
          ),
        ),
      ),
      Positioned(
        top: 2.0,
        bottom: 2.0,
        left: 2.0,
        child: ClipRect(
          child: Material(
            type: MaterialType.transparency,
            child: InkResponse(
              containedInkWell: false,
              highlightShape: BoxShape.rectangle,
              highlightColor: const Color(0xFF444444),
              splashColor: const Color(0x00FFFFFF),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(40.0),
                bottomLeft: Radius.circular(40.0),
              ),
              child: const SizedBox(
                height: 56,
                width: 40,
                child: Icon(
                  size: 18.2,
                  RemoteButtons.left_arrow,
                  color: Color(0xEEFFFFFF),
                ),
              ),
              onTapDown: (details) {
                callback(RemoteButton.left);
                HapticFeedback.lightImpact();
              },
            ),
          ),
        ),
      ),
      Positioned(
        top: 2.0,
        bottom: 2.0,
        right: 2.0,
        child: ClipRect(
          child: Material(
            type: MaterialType.transparency,
            child: InkResponse(
              containedInkWell: false,
              highlightShape: BoxShape.rectangle,
              highlightColor: const Color(0x00FFFFFF),
              splashColor: const Color(0x00FFFFFF),
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(40.0),
                bottomRight: Radius.circular(40.0),
              ),
              child: const SizedBox(
                height: 56,
                width: 40,
                child: Icon(
                  size: 18.2,
                  RemoteButtons.right_arrow,
                  color: Color(0xEEFFFFFF),
                ),
              ),
              onTapDown: (details) {
                callback(RemoteButton.right);
                HapticFeedback.lightImpact();
              },
            ),
          ),
        ),
      ),
    ];
  }
}
