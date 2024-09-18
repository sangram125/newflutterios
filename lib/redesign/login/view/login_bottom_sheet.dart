import 'package:dor_companion/redesign/login/login_vm.dart';
import 'package:dor_companion/redesign/login/view/loading_widget.dart';
import 'package:dor_companion/redesign/login/view/login_widget.dart';
import 'package:dor_companion/redesign/login/view/otp_widget.dart';
import 'package:dor_companion/widgets/common_pop_up_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginBottomSheet extends StatefulWidget {
  const LoginBottomSheet({super.key});

  @override
  State<LoginBottomSheet> createState() => _LoginBottomSheetState();
}

class _LoginBottomSheetState extends State<LoginBottomSheet> {
  late LoginVm loginVm;

  @override
  void initState() {
    loginVm = LoginVm();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: ChangeNotifierProvider(
            create: (context) => loginVm,
            child: Consumer<LoginVm>(
                builder: (context, value, child) => WillPopScope(
                    onWillPop: () async {
                      if (value.currentStatus == LoginStatus.otp) {
                        final shouldClose = await showDialog<bool>(
                            context: context,
                            builder: (BuildContext context) {
                              return PreventPopupDialog(
                                  onYesPressed: () => Navigator.of(context).pop(true),
                                  onNoPressed: () => Navigator.of(context).pop(false));
                            });
                        return shouldClose ?? false;
                      } else {
                        return true;
                      }
                    },
                    child: Container(
                        decoration: const BoxDecoration(
                            color: Color(0xFF171717),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
                        child: Column(mainAxisSize: MainAxisSize.min, children: [
                          Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Consumer<LoginVm>(
                                  builder: (context, value, child) =>
                                      value.currentStatus == LoginStatus.mobileNumber
                                          ? const LoginWidget()
                                          : value.currentStatus == LoginStatus.otp
                                              ? const OtpWidget()
                                              : value.currentStatus == LoginStatus.loading
                                                  ? const LoadingWidget()
                                                  : const SizedBox())),
                          const SizedBox(height: 20)
                        ]))))));
  }
}

void showLoginBottomSheet(BuildContext context) {
  showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      barrierColor: Colors.black.withOpacity(0.6000000238418579),
      backgroundColor: Colors.transparent,
      builder: (context) => GestureDetector(onVerticalDragDown: (_) {}, child: const LoginBottomSheet()));
}

class CustomCheckbox extends StatelessWidget {
  final bool isChecked;
  final Function(bool?)? onChanged;

  const CustomCheckbox({super.key, required this.isChecked, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => onChanged?.call(isChecked),
        child: Container(
            height: 22,
            width: 22,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.white, width: 2.0),
                borderRadius: BorderRadius.circular(6.0)),
            child: isChecked
                ? const Padding(
                    padding: EdgeInsets.all(2.0), child: Icon(Icons.check, color: Colors.black, size: 14))
                : null));
  }
}
