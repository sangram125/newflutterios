import 'package:flutter/material.dart';

class CommonAlertDialog {
  static void showAlertDialog(
      {required BuildContext context,
      required Widget child,
      EdgeInsets? insetPadding,
      double? elevation,
      EdgeInsetsGeometry? contentPadding,
      Color? backgroundColor}) {
    showDialog(
        barrierColor: Colors.black.withOpacity(0.75),
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              backgroundColor: backgroundColor ?? Colors.transparent,
              contentPadding: contentPadding ?? EdgeInsets.zero,
              elevation: elevation ?? 0.0,
              insetPadding: insetPadding ??
                  const EdgeInsets.symmetric(horizontal: 20)
                      .copyWith(top: MediaQuery.sizeOf(context).height * 0.5, bottom: kToolbarHeight + 40),
              content: child);
        });
  }

  static Widget commonDialogContent(
      {required BuildContext context,
      required String title,
      required String yesText,
      required Function onYes,
      required Function onNo}) {
    return Column(mainAxisAlignment: MainAxisAlignment.end, children: [
      Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.only(top: 20, left: 5, right: 5, bottom: 2),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.white.withOpacity(0.10000000149011612)),
              color: const Color(0xFF040834),
              borderRadius: const BorderRadius.all(Radius.circular(12))),
          child: Column(children: [
            const SizedBox(height: 15),
            Text(title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600, fontFamily: 'Roboto')),
            const SizedBox(height: 24),
            Container(height: 1, width: double.infinity, color: const Color(0xFF2C2C2C)),
            ListTile(
                onTap: onNo as void Function()?,
                title: const Center(
                    child: Text('No',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Color(0xFFE2E2E2),
                            fontSize: 20,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w400,
                            height: 0)))),
            Container(height: 1, width: double.infinity, color: const Color(0xFF2C2C2C)),
            ListTile(
                onTap: onYes as void Function()?,
                title: Center(
                    child: Text(yesText,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: Color(0xFFDA0C15),
                            fontSize: 20,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w600,
                            height: 0))))
          ]))
    ]);
  }
}
