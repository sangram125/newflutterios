import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FullScreenToast extends StatelessWidget {

  const FullScreenToast({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFF040523),
      body: Container(
        margin: const EdgeInsets.only(top: 80,left: 10),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Row(
                children: [
                  IconButton(
                      icon: const Icon(Icons.close), onPressed: () {
                    Navigator.of(context).pop();                    },
                      iconSize: 38.0
                  ),
                  Container(
                      margin: const EdgeInsets.only(left: 15),
                      child: const Text("Listening..",style: TextStyle(fontSize: 32),)),
                ],
              ),),
            Expanded(
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF3158CE),
                    ),
                    child: IconButton(
                        icon: const Icon(Icons.keyboard_voice_outlined), onPressed: () {
                      Fluttertoast.cancel();
                    },
                        iconSize: 42.0
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void showFullScreenBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return Builder(
        builder: (BuildContext context) {
          return const FullScreenToast();
        },
      );
    },
  );
}
